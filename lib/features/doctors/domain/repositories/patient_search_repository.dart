import '../models/ai_insight.dart';
import '../models/dashboard_stat.dart';
import '../models/patient_record.dart';

/// The data contract the Patient Search screen is built against.
///
/// [MockPatientSearchRepository] fulfills it today with seeded,
/// `Future.delayed` data; a later Firestore-backed implementation can
/// implement the same interface without the screen changing.
abstract class PatientSearchRepository {
  Future<List<DashboardStat>> getPatientStats();

  Future<AiInsight> getFollowUpInsight();

  Future<List<PatientRecord>> getRecentPatients();
}
