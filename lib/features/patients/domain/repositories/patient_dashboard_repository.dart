import '../models/ai_health_insight.dart';
import '../models/bp_trend_point.dart';
import '../models/care_item.dart';
import '../models/health_score.dart';
import '../models/medication_reminder.dart';
import '../models/patient_profile.dart';
import '../models/quick_link.dart';
import '../models/vital_reading.dart';

/// The data contract the Patient Dashboard is built against.
///
/// [PatientDashboardRepositoryImpl] fulfills it with a Firestore-backed data
/// source, seeded once from [PatientDashboardLocalDataSource] on first read.
abstract class PatientDashboardRepository {
  Future<PatientProfile> getCurrentPatient();

  Future<HealthScore> getHealthScore();

  Future<List<VitalReading>> getTodayVitals();

  Future<List<MedicationReminder>> getMedicationReminders();

  Future<List<CareItem>> getUpcomingCare();

  Future<AiHealthInsight> getAiHealthInsight();

  Future<List<QuickLink>> getQuickLinks();

  Future<List<BpTrendPoint>> getBpTrend();
}
