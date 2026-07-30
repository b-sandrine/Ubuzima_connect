import '../models/records_patient_profile.dart';
import '../models/visit_summary.dart';

/// The data contract the Medical Records screen is built against.
///
/// [MockPatientRecordsRepository] fulfills it today with seeded,
/// `Future.delayed` data; a later Firestore-backed implementation can
/// implement the same interface, and `PatientRecordsPage` won't need to
/// change at all.
abstract class PatientRecordsRepository {
  Future<RecordsPatientProfile> getPatientProfile();

  Future<List<VisitSummary>> getVisitSummaries();

  Future<int> getTotalVisitCount();
}
