import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';

import '../../../../../core/constants/app_constants.dart';
import '../../../../../core/constants/firestore_paths.dart';
import '../../../../../core/exceptions/app_exceptions.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../domain/models/dashboard_stat.dart';
import '../../../domain/models/patient_record.dart';
import '../../dummy/dummy_patient_search_data.dart';

/// Firestore-backed store for the Patient Search / Records screen. Layout:
///
///   doctors/{doctorId}                → the doctor doc's `patientStats` map
///   doctors/{doctorId}/patients/{id}  → the recent-patients list
///
/// A doctor-scoped subcollection rather than the shared top-level
/// `patients` collection — that one is keyed by a single canonical demo
/// patient for the referrals/medical-records/prescriptions features, while
/// this screen inherently needs a whole panel of patients.
///
/// Seeded from [DummyPatientSearchData] on first read.
abstract interface class PatientSearchRemoteDataSource {
  Future<List<DashboardStat>> getPatientStats();

  Future<List<PatientRecord>> getRecentPatients();
}

@LazySingleton(as: PatientSearchRemoteDataSource)
class PatientSearchRemoteDataSourceImpl
    implements PatientSearchRemoteDataSource {
  final FirebaseFirestore _firestore;

  PatientSearchRemoteDataSourceImpl(this._firestore);

  static const String _doctorId = AppConstants.demoDoctorId;

  DocumentReference<Map<String, dynamic>> get _doc =>
      _firestore.collection(FirestorePaths.doctors).doc(_doctorId);

  CollectionReference<Map<String, dynamic>> get _patients =>
      _doc.collection('patients');

  /// Seeded state is checked via `patients` rather than the shared
  /// `doctors/{doctorId}` doc's existence — that doc is also written by
  /// [DoctorDashboardRemoteDataSourceImpl] for its own fields, so checking
  /// the doc itself would make whichever screen loads second skip seeding.
  Future<void> _ensureSeeded() async {
    if ((await _patients.limit(1).get()).docs.isNotEmpty) return;
    await _seedFirestore();
  }

  @override
  Future<List<DashboardStat>> getPatientStats() async {
    try {
      await _ensureSeeded();
      final data = (await _doc.get()).data() ?? const {};
      final stats = (data['patientStats'] as Map?) ?? const {};
      return [
        DashboardStat(
          id: 'stat-total',
          label: 'Total Patients',
          value: (stats['stat-total'] as num?)?.toInt() ?? 0,
          color: AppColors.primary,
        ),
        DashboardStat(
          id: 'stat-seen-today',
          label: 'Seen Today',
          value: (stats['stat-seen-today'] as num?)?.toInt() ?? 0,
          color: AppColors.secondary,
        ),
        DashboardStat(
          id: 'stat-critical',
          label: 'Critical',
          value: (stats['stat-critical'] as num?)?.toInt() ?? 0,
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
      await _ensureSeeded();
      final docs = await _patients.orderBy('sortOrder').get();
      return docs.docs.map((d) {
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
    } on FirebaseException catch (e) {
      throw ServerException(e.message ?? 'Could not load recent patients.');
    }
  }

  Future<void> _seedFirestore() async {
    final batch = _firestore.batch();
    final stats = {
      for (final stat in DummyPatientSearchData.patientStats)
        stat.id: stat.value,
    };

    batch.set(_doc, {'patientStats': stats}, SetOptions(merge: true));

    final patients = DummyPatientSearchData.recentPatients;
    for (var i = 0; i < patients.length; i++) {
      final p = patients[i];
      batch.set(_patients.doc(p.id), {
        'name': p.name,
        'patientCode': p.patientCode,
        'gender': p.gender,
        'age': p.age,
        'location': p.location,
        'status': p.status.name,
        'tags': p.tags,
        'lastActivityLabel': p.lastActivityLabel,
        'photoUrl': p.photoUrl,
        'sortOrder': i,
      });
    }

    await batch.commit();
  }
}
