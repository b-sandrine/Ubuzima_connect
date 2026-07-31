import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';

import '../../../../../core/constants/app_constants.dart';
import '../../../../../core/constants/firestore_paths.dart';
import '../../../../../core/exceptions/app_exceptions.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../domain/models/dashboard_stat.dart';
import '../../../domain/models/patient_record.dart';

/// Firestore-backed store for the Patient Search / Records screen. Layout:
///
///   doctors/{doctorId}                → the doctor doc's `patientStats` map
///   doctors/{doctorId}/patients/{id}  → any patient records added directly
///
/// A doctor-scoped subcollection rather than the shared top-level
/// `patients` collection — that one is keyed by a single canonical demo
/// patient for the referrals/medical-records/prescriptions features, while
/// this screen inherently needs a whole panel of patients.
///
/// Referred patients are merged in live from the same `referrals`
/// collection DOC-06 owns (incoming, not declined) — otherwise a patient
/// who's actually been referred to this doctor would never appear in
/// their own patient list.
abstract interface class PatientSearchRemoteDataSource {
  Future<List<DashboardStat>> getPatientStats();

  Future<List<PatientRecord>> getRecentPatients();
}

@LazySingleton(as: PatientSearchRemoteDataSource)
class PatientSearchRemoteDataSourceImpl
    implements PatientSearchRemoteDataSource {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  PatientSearchRemoteDataSourceImpl(this._firestore, this._auth);

  String get _doctorId => _auth.currentUser?.uid ?? AppConstants.demoDoctorId;

  DocumentReference<Map<String, dynamic>> get _doc =>
      _firestore.collection(FirestorePaths.doctors).doc(_doctorId);

  CollectionReference<Map<String, dynamic>> get _patients =>
      _doc.collection('patients');

  CollectionReference<Map<String, dynamic>> get _referrals =>
      _firestore.collection(FirestorePaths.referrals);

  DocumentReference<Map<String, dynamic>> get _referralPatientDoc => _firestore
      .collection(FirestorePaths.patients)
      .doc(AppConstants.demoPatientId);

  PatientRecordStatus _statusFromCriticality(String criticality) =>
      switch (criticality.toLowerCase()) {
        'critical' => PatientRecordStatus.critical,
        'urgent' => PatientRecordStatus.urgent,
        'stable' => PatientRecordStatus.stable,
        'scheduled' => PatientRecordStatus.scheduled,
        _ => PatientRecordStatus.routine,
      };

  @override
  Future<List<DashboardStat>> getPatientStats() async {
    try {
      final patients = await getRecentPatients();
      final critical = patients
          .where((p) => p.status == PatientRecordStatus.critical)
          .length;

      return [
        DashboardStat(
          id: 'stat-total',
          label: 'Total Patients',
          value: patients.length,
          color: AppColors.primary,
        ),
        // No real "seen today" signal exists yet (that needs a completed
        // consultation to mark it) — kept at 0 rather than fabricated.
        DashboardStat(
          id: 'stat-seen-today',
          label: 'Seen Today',
          value: 0,
          color: AppColors.secondary,
        ),
        DashboardStat(
          id: 'stat-critical',
          label: 'Critical',
          value: critical,
          color: AppColors.danger,
        ),
      ];
    } on FirebaseException catch (e) {
      throw ServerException(e.message ?? 'Could not load patient stats.');
    }
  }

  @override
  Future<List<PatientRecord>> getRecentPatients() async {
    try {
      final docs = await _patients.orderBy('sortOrder').get();
      final stored = docs.docs.map((d) {
        final data = d.data();
        return PatientRecord(
          id: d.id,
          name: data['name'] as String? ?? '',
          patientCode: data['patientCode'] as String? ?? '',
          gender: data['gender'] as String? ?? '',
          age: (data['age'] as num?)?.toInt() ?? 0,
          location: data['location'] as String? ?? '',
          status: PatientRecordStatus.values.byName(
            data['status'] as String? ?? 'routine',
          ),
          tags: ((data['tags'] as List?) ?? const []).cast<String>(),
          lastActivityLabel: data['lastActivityLabel'] as String? ?? '',
          photoUrl: data['photoUrl'] as String?,
        );
      }).toList();

      if (stored.any((p) => p.id == 'patient-001')) return stored;

      final referred = await _referredPatientRecord();
      return referred == null ? stored : [referred, ...stored];
    } on FirebaseException catch (e) {
      throw ServerException(e.message ?? 'Could not load recent patients.');
    }
  }

  /// The real referred patient, built from the same identity/referral
  /// records the Dashboard's queue and Referral Management already read —
  /// null when there's no incoming, non-declined referral at all.
  Future<PatientRecord?> _referredPatientRecord() async {
    final referralDocs = await _referrals
        .where('direction', isEqualTo: 'incoming')
        .get();
    final active = referralDocs.docs.where(
      (d) => d.data()['status'] != 'declined',
    );
    if (active.isEmpty) return null;

    final patient = (await _referralPatientDoc.get()).data();
    if (patient == null) return null;

    final mostRecent = active.first.data();
    final summary = patient['summary'] as String?;

    return PatientRecord(
      id: 'patient-001',
      name: patient['name'] as String? ?? '',
      patientCode: patient['displayId'] as String? ?? '',
      gender: '',
      age: 0,
      location: mostRecent['facility'] as String? ?? '',
      status: _statusFromCriticality(patient['criticality'] as String? ?? ''),
      tags: summary != null && summary.isNotEmpty ? [summary] : const [],
      lastActivityLabel: mostRecent['receivedLabel'] as String? ?? 'Referred',
      photoUrl: null,
    );
  }
}
