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
///   doctors/{doctorId}/patients/{id}  → the recent-patients list
///
/// A doctor-scoped subcollection rather than the shared top-level
/// `patients` collection — that one is keyed by a single canonical demo
/// patient for the referrals/medical-records/prescriptions features, while
/// this screen inherently needs a whole panel of patients.
///
/// No seed data — a fresh Firestore project reads back an empty list until
/// patients are added directly in Firestore.
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

  @override
  Future<List<DashboardStat>> getPatientStats() async {
    try {
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
}
