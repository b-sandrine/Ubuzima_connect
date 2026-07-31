import '../models/records_patient_profile.dart';
import '../models/visit_summary.dart';

/// The data contract the Medical Records screen is built against.
///
/// [PatientRecordsRepositoryImpl] fulfills it with a Firestore-backed data
/// source, seeded once from [PatientRecordsLocalDataSource] on first read.
abstract class PatientRecordsRepository {
  Future<RecordsPatientProfile> getPatientProfile();

  Future<List<VisitSummary>> getVisitSummaries();

  Future<int> getTotalVisitCount();
}
