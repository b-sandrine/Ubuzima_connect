import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';

import '../../../../../core/constants/app_constants.dart';
import '../../../../../core/constants/firestore_paths.dart';
import '../../../../../core/exceptions/app_exceptions.dart';
import '../../../domain/entities/referral.dart';
import '../../../domain/entities/referral_board.dart';
import '../../../domain/entities/referral_draft.dart';
import '../local/referral_local_data_source.dart';

/// Firestore-backed referrals store for DOC-06. Layout:
///
///   patients/{patientId}   → the patient the board is about
///   referrals/{reference}  → one document per referral, keyed by its
///                            reference number and tagged with patientId
///
/// The demo board is seeded from [ReferralLocalDataSource] on first read.
abstract interface class ReferralRemoteDataSource {
  Future<ReferralBoard> readBoard();

  Future<ReferralBoard> setStatus(
    String reference,
    ReferralStatus status, {
    String? routedSpecialty,
  });

  Future<String> addReferral(ReferralDraft draft);

  Future<ReferralBoard> deleteReferral(String reference);
}

@LazySingleton(as: ReferralRemoteDataSource)
class ReferralRemoteDataSourceImpl implements ReferralRemoteDataSource {
  final FirebaseFirestore _firestore;
  final ReferralLocalDataSource _seed;

  ReferralRemoteDataSourceImpl(this._firestore, this._seed);

  static const String _patientId = AppConstants.demoPatientId;

  DocumentReference<Map<String, dynamic>> get _patientDoc =>
      _firestore.collection(FirestorePaths.patients).doc(_patientId);

  CollectionReference<Map<String, dynamic>> get _referrals =>
      _firestore.collection(FirestorePaths.referrals);

  @override
  Future<ReferralBoard> readBoard() async {
    try {
      if (!(await _patientDoc.get()).exists) await _seedFirestore();
      return _assemble();
    } on FirebaseException catch (e) {
      throw ServerException(e.message ?? 'Could not load referrals.');
    }
  }

  @override
  Future<ReferralBoard> setStatus(
    String reference,
    ReferralStatus status, {
    String? routedSpecialty,
  }) async {
    try {
      final update = <String, dynamic>{'status': status.name};
      if (routedSpecialty != null) update['specialty'] = routedSpecialty;
      await _referrals.doc(reference).update(update);
      return _assemble();
    } on FirebaseException catch (e) {
      throw ServerException(e.message ?? 'Could not update the referral.');
    }
  }

  @override
  Future<String> addReferral(ReferralDraft draft) async {
    try {
      final reference = await _nextReference();
      final summary = draft.clinicalSummary.trim();
      final timeline = draft.requestedTimeline.trim();
      await _referrals.doc(reference).set({
        'patientId': _patientId,
        'reference': reference,
        'specialty': draft.specialty,
        'urgency': draft.urgency.name,
        'direction': ReferralDirection.outgoing.name,
        'status': ReferralStatus.pending.name,
        'facility': draft.destinationFacility,
        'receivedLabel': 'Just now',
        'referringPhysician': 'You',
        'referringFacility': 'This facility',
        'reason': draft.reason,
        'clinicalSummary': summary.isEmpty ? null : summary,
        'requestedTimeline': timeline.isEmpty ? 'Not specified' : timeline,
        'timelineIsUrgent': draft.urgency == ReferralUrgency.urgent,
        'routeOptions': const <String>[],
        // Negative so freshly created referrals sort to the top of the list.
        'sortOrder': -DateTime.now().millisecondsSinceEpoch,
      });
      return reference;
    } on FirebaseException catch (e) {
      throw ServerException(e.message ?? 'Could not create the referral.');
    }
  }

  @override
  Future<ReferralBoard> deleteReferral(String reference) async {
    try {
      await _referrals.doc(reference).delete();
      return _assemble();
    } on FirebaseException catch (e) {
      throw ServerException(e.message ?? 'Could not withdraw the referral.');
    }
  }

  Future<ReferralBoard> _assemble() async {
    final patient = (await _patientDoc.get()).data() ?? const {};
    final docs = await _referrals
        .where('patientId', isEqualTo: _patientId)
        .orderBy('sortOrder')
        .get();

    return ReferralBoard(
      patient: ReferralPatient(
        name: patient['name'] as String? ?? '',
        id: patient['displayId'] as String? ?? '',
        summary: patient['summary'] as String? ?? '',
        criticality: patient['criticality'] as String? ?? '',
      ),
      referrals: docs.docs.map((d) => _referralFromMap(d.data())).toList(),
    );
  }

  Referral _referralFromMap(Map<String, dynamic> data) {
    return Referral(
      reference: data['reference'] as String? ?? '',
      specialty: data['specialty'] as String? ?? '',
      urgency: ReferralUrgency.values.byName(
        data['urgency'] as String? ?? 'pending',
      ),
      direction: ReferralDirection.values.byName(
        data['direction'] as String? ?? 'incoming',
      ),
      status: ReferralStatus.values.byName(
        data['status'] as String? ?? 'pending',
      ),
      facility: data['facility'] as String? ?? '',
      receivedLabel: data['receivedLabel'] as String? ?? '',
      referringPhysician: data['referringPhysician'] as String? ?? '',
      referringFacility: data['referringFacility'] as String? ?? '',
      reason: data['reason'] as String? ?? '',
      clinicalSummary: data['clinicalSummary'] as String?,
      requestedTimeline: data['requestedTimeline'] as String? ?? '',
      timelineIsUrgent: data['timelineIsUrgent'] as bool? ?? false,
      routeOptions: ((data['routeOptions'] as List?) ?? const [])
          .cast<String>(),
    );
  }

  /// Next reference number, one past the highest currently stored.
  Future<String> _nextReference() async {
    final docs = await _referrals.get();
    var max = 0;
    for (final doc in docs.docs) {
      final ref = doc.data()['reference'] as String? ?? '';
      final n = int.tryParse(ref.split('-').last) ?? 0;
      if (n > max) max = n;
    }
    return 'RW-REF-${(max + 1).toString().padLeft(4, '0')}';
  }

  Future<void> _seedFirestore() async {
    final board = _seed.readBoard();
    final batch = _firestore.batch();

    batch.set(_patientDoc, {
      'name': board.patient.name,
      'displayId': board.patient.id,
      'summary': board.patient.summary,
      'criticality': board.patient.criticality,
    });

    for (var i = 0; i < board.referrals.length; i++) {
      final r = board.referrals[i];
      batch.set(_referrals.doc(r.reference), {
        'patientId': _patientId,
        'reference': r.reference,
        'specialty': r.specialty,
        'urgency': r.urgency.name,
        'direction': r.direction.name,
        'status': r.status.name,
        'facility': r.facility,
        'receivedLabel': r.receivedLabel,
        'referringPhysician': r.referringPhysician,
        'referringFacility': r.referringFacility,
        'reason': r.reason,
        'clinicalSummary': r.clinicalSummary,
        'requestedTimeline': r.requestedTimeline,
        'timelineIsUrgent': r.timelineIsUrgent,
        'routeOptions': r.routeOptions,
        'sortOrder': i,
      });
    }

    await batch.commit();
  }
}
