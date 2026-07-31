import '../models/ai_insight.dart';
import '../models/dashboard_stat.dart';
import '../models/patient_record.dart';

/// The data contract the Patient Search screen is built against.
///
/// Fulfilled by `FirestorePatientSearchRepository` in production.
abstract class PatientSearchRepository {
  Future<List<DashboardStat>> getPatientStats();

  Future<AiInsight> getFollowUpInsight();

  Future<List<PatientRecord>> getRecentPatients();
}
