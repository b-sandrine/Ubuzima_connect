import '../../domain/models/ai_health_insight.dart';
import '../../domain/models/bp_trend_point.dart';
import '../../domain/models/care_item.dart';
import '../../domain/models/health_score.dart';
import '../../domain/models/medication_reminder.dart';
import '../../domain/models/patient_profile.dart';
import '../../domain/models/quick_link.dart';
import '../../domain/models/vital_reading.dart';
import '../../domain/repositories/patient_dashboard_repository.dart';
import '../dummy/dummy_patient_dashboard_data.dart';

/// Mock implementation of [PatientDashboardRepository] used until the
/// Firestore-backed patient dashboard is wired up. Every call goes through
/// `Future.delayed` to mimic a real network round trip, so the presentation
/// layer's loading states are exercised even against fake data.
class MockPatientDashboardRepository implements PatientDashboardRepository {
  const MockPatientDashboardRepository();

  static const _simulatedLatency = Duration(milliseconds: 400);

  @override
  Future<PatientProfile> getCurrentPatient() {
    return Future.delayed(
      _simulatedLatency,
      () => DummyPatientDashboardData.patient,
    );
  }

  @override
  Future<HealthScore> getHealthScore() {
    return Future.delayed(
      _simulatedLatency,
      () => DummyPatientDashboardData.healthScore,
    );
  }

  @override
  Future<List<VitalReading>> getTodayVitals() {
    return Future.delayed(
      _simulatedLatency,
      () => DummyPatientDashboardData.todayVitals,
    );
  }

  @override
  Future<List<MedicationReminder>> getMedicationReminders() {
    return Future.delayed(
      _simulatedLatency,
      () => DummyPatientDashboardData.medicationReminders,
    );
  }

  @override
  Future<List<CareItem>> getUpcomingCare() {
    return Future.delayed(
      _simulatedLatency,
      () => DummyPatientDashboardData.upcomingCare,
    );
  }

  @override
  Future<AiHealthInsight> getAiHealthInsight() {
    return Future.delayed(
      _simulatedLatency,
      () => DummyPatientDashboardData.aiHealthInsight,
    );
  }

  @override
  Future<List<QuickLink>> getQuickLinks() {
    return Future.delayed(
      _simulatedLatency,
      () => DummyPatientDashboardData.quickLinks,
    );
  }

  @override
  Future<List<BpTrendPoint>> getBpTrend() {
    return Future.delayed(
      _simulatedLatency,
      () => DummyPatientDashboardData.bpTrend,
    );
  }
}
