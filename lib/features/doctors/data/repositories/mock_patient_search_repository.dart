import '../../domain/models/ai_insight.dart';
import '../../domain/models/dashboard_stat.dart';
import '../../domain/models/patient_record.dart';
import '../../domain/repositories/patient_search_repository.dart';
import '../dummy/dummy_patient_search_data.dart';

/// Mock implementation of [PatientSearchRepository] used until the
/// Firestore-backed patient search is wired up. Every call goes through
/// `Future.delayed` to mimic a real network round trip.
class MockPatientSearchRepository implements PatientSearchRepository {
  const MockPatientSearchRepository();

  static const _simulatedLatency = Duration(milliseconds: 400);

  @override
  Future<List<DashboardStat>> getPatientStats() {
    return Future.delayed(
      _simulatedLatency,
      () => DummyPatientSearchData.patientStats,
    );
  }

  @override
  Future<AiInsight> getFollowUpInsight() {
    return Future.delayed(
      _simulatedLatency,
      () => DummyPatientSearchData.followUpInsight,
    );
  }

  @override
  Future<List<PatientRecord>> getRecentPatients() {
    return Future.delayed(
      _simulatedLatency,
      () => DummyPatientSearchData.recentPatients,
    );
  }
}
