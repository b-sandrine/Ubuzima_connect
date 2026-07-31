import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../../core/constants/app_constants.dart';
import '../../../../../core/constants/firestore_paths.dart';
import '../../../../../core/exceptions/app_exceptions.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../domain/models/records_patient_profile.dart';
import '../../../domain/models/visit_summary.dart';
import '../local/patient_records_local_data_source.dart';

/// Firestore-backed source for the Medical Records screen. Layout:
///
///   patient_records/{patientId}            → profile + totalVisitCount
///   patient_records/{patientId}/visits/{id} → one document per loaded visit
///
/// Seeded from [PatientRecordsLocalDataSource] on first read. Tag icons and
/// visit icon/colour/chips stay a local cosmetic lookup by label/id — only
/// the descriptive fields are read from Firestore.
abstract interface class PatientRecordsRemoteDataSource {
  Future<RecordsPatientProfile> readProfile();

  Future<List<VisitSummary>> readVisitSummaries();

  Future<int> readTotalVisitCount();
}

@LazySingleton(as: PatientRecordsRemoteDataSource)
class PatientRecordsRemoteDataSourceImpl
    implements PatientRecordsRemoteDataSource {
  final FirebaseFirestore _firestore;
  final PatientRecordsLocalDataSource _seed;

  PatientRecordsRemoteDataSourceImpl(this._firestore, this._seed);

  DocumentReference<Map<String, dynamic>> get _doc => _firestore
      .collection(FirestorePaths.patientRecords)
      .doc(AppConstants.demoPatientId);

  CollectionReference<Map<String, dynamic>> get _visits =>
      _doc.collection('visits');

  @override
  Future<RecordsPatientProfile> readProfile() async {
    final data = await _readOrSeed();
    final cosmetics = _seed.readProfile();
    return RecordsPatientProfile(
      fullName: data['fullName'] as String? ?? '',
      displayId: data['displayId'] as String? ?? '',
      dobLabel: data['dobLabel'] as String? ?? '',
      photoUrl: data['photoUrl'] as String?,
      verified: data['verified'] as bool? ?? false,
      tags: cosmetics.tags,
    );
  }

  @override
  Future<int> readTotalVisitCount() async {
    final data = await _readOrSeed();
    return (data['totalVisitCount'] as num?)?.toInt() ?? 0;
  }

  @override
  Future<List<VisitSummary>> readVisitSummaries() async {
    await _readOrSeed();
    final cosmeticsById = {
      for (final visit in _seed.readVisitSummaries()) visit.id: visit,
    };

    final visitDocs = await _visits.orderBy('sortOrder').get();
    return visitDocs.docs.map((d) {
      final data = d.data();
      final cosmetics = cosmeticsById[d.id];
      return VisitSummary(
        id: d.id,
        title: data['title'] as String? ?? '',
        dateLabel: data['dateLabel'] as String? ?? '',
        statusLabel: data['statusLabel'] as String? ?? '',
        statusColor: cosmetics?.statusColor ?? AppColors.textTertiary,
        icon: cosmetics?.icon ?? LucideIcons.stethoscope,
        iconColor: cosmetics?.iconColor ?? AppColors.textTertiary,
        doctorLine: data['doctorLine'] as String? ?? '',
        description: data['description'] as String? ?? '',
        chips: cosmetics?.chips ?? const [],
      );
    }).toList();
  }

  Future<Map<String, dynamic>> _readOrSeed() async {
    try {
      final snapshot = await _doc.get();
      if (!snapshot.exists) {
        await _seedFirestore();
        return (await _doc.get()).data() ?? const {};
      }
      return snapshot.data() ?? const {};
    } on FirebaseException catch (e) {
      throw ServerException(e.message ?? 'Could not load medical records.');
    }
  }

  Future<void> _seedFirestore() async {
    final profile = _seed.readProfile();
    final visits = _seed.readVisitSummaries();
    final batch = _firestore.batch();

    batch.set(_doc, {
      'fullName': profile.fullName,
      'displayId': profile.displayId,
      'dobLabel': profile.dobLabel,
      'photoUrl': profile.photoUrl,
      'verified': profile.verified,
      'totalVisitCount': _seed.readTotalVisitCount(),
    });

    for (var i = 0; i < visits.length; i++) {
      final visit = visits[i];
      batch.set(_visits.doc(visit.id), {
        'title': visit.title,
        'dateLabel': visit.dateLabel,
        'statusLabel': visit.statusLabel,
        'doctorLine': visit.doctorLine,
        'description': visit.description,
        'sortOrder': i,
      });
    }

    await batch.commit();
  }
}
