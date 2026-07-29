import '../../domain/models/ai_insight.dart';
import '../../domain/models/dashboard_stat.dart';
import '../../domain/models/doctor.dart';
import '../../domain/models/emergency_alert.dart';
import '../../domain/models/queue_patient.dart';
import '../../domain/models/referral.dart';
import '../../domain/models/schedule_item.dart';
import '../../domain/repositories/doctor_dashboard_repository.dart';
import '../dummy/dummy_doctor_dashboard_data.dart';

/// Mock implementation of [DoctorDashboardRepository] used until the
/// Firestore-backed doctor dashboard is wired up. Every call goes through
/// `Future.delayed` to mimic a real network round trip, so the presentation
/// layer's loading states are exercised even against fake data.
class MockDoctorDashboardRepository implements DoctorDashboardRepository {
  const MockDoctorDashboardRepository();

  static const _simulatedLatency = Duration(milliseconds: 400);

  @override
  Future<Doctor> getCurrentDoctor() {
    return Future.delayed(
      _simulatedLatency,
      () => DummyDoctorDashboardData.doctor,
    );
  }

  @override
  Future<List<EmergencyAlert>> getEmergencyAlerts() {
    return Future.delayed(
      _simulatedLatency,
      () => DummyDoctorDashboardData.emergencyAlerts,
    );
  }

  @override
  Future<List<DashboardStat>> getDashboardStats() {
    return Future.delayed(
      _simulatedLatency,
      () => DummyDoctorDashboardData.dashboardStats,
    );
  }

  @override
  Future<List<ScheduleItem>> getTodaySchedule() {
    return Future.delayed(
      _simulatedLatency,
      () => DummyDoctorDashboardData.todaySchedule,
    );
  }

  @override
  Future<List<QueuePatient>> getPatientQueue() {
    return Future.delayed(
      _simulatedLatency,
      () => DummyDoctorDashboardData.patientQueue,
    );
  }

  @override
  Future<List<Referral>> getReferrals() {
    return Future.delayed(
      _simulatedLatency,
      () => DummyDoctorDashboardData.referrals,
    );
  }

  @override
  Future<AiInsight> getAiInsight() {
    return Future.delayed(
      _simulatedLatency,
      () => DummyDoctorDashboardData.aiInsight,
    );
  }
}
