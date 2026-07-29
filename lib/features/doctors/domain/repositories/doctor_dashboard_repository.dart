import '../models/ai_insight.dart';
import '../models/dashboard_stat.dart';
import '../models/doctor.dart';
import '../models/emergency_alert.dart';
import '../models/queue_patient.dart';
import '../models/referral.dart';
import '../models/schedule_item.dart';

/// The data contract the Doctor Dashboard is built against.
///
/// [MockDoctorDashboardRepository] fulfills it today with seeded,
/// `Future.delayed` data; a later `FirestoreDoctorDashboardRepository` can
/// implement the same interface, and `DoctorDashboardScreen` won't need to
/// change at all.
abstract class DoctorDashboardRepository {
  Future<Doctor> getCurrentDoctor();

  Future<List<EmergencyAlert>> getEmergencyAlerts();

  Future<List<DashboardStat>> getDashboardStats();

  Future<List<ScheduleItem>> getTodaySchedule();

  Future<List<QueuePatient>> getPatientQueue();

  Future<List<Referral>> getReferrals();

  Future<AiInsight> getAiInsight();
}
