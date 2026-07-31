import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:ubuzima_connect/core/theme/app_colors.dart';
import 'package:ubuzima_connect/features/doctors/domain/models/ai_insight.dart';
import 'package:ubuzima_connect/features/doctors/domain/models/dashboard_stat.dart';
import 'package:ubuzima_connect/features/doctors/domain/models/doctor.dart';
import 'package:ubuzima_connect/features/doctors/domain/models/emergency_alert.dart';
import 'package:ubuzima_connect/features/doctors/domain/models/queue_patient.dart';
import 'package:ubuzima_connect/features/doctors/domain/models/referral.dart';
import 'package:ubuzima_connect/features/doctors/domain/models/schedule_item.dart';
import 'package:ubuzima_connect/features/doctors/domain/repositories/doctor_dashboard_repository.dart';

/// Deterministic [DoctorDashboardRepository] fixture for widget tests —
/// no Firestore, no AI call, just fixed data the tests assert against.
class FakeDoctorDashboardRepository implements DoctorDashboardRepository {
  const FakeDoctorDashboardRepository();

  @override
  Future<Doctor> getCurrentDoctor() async => const Doctor(
    id: 'doc-001',
    fullName: 'Dr. Jean-Pierre Habimana',
    hospital: 'Kigali District Hospital',
    onDuty: true,
  );

  @override
  Future<List<EmergencyAlert>> getEmergencyAlerts() async => const [
    EmergencyAlert(
      id: 'alert-001',
      severity: AlertSeverity.critical,
      patientName: 'Marie Uwase',
      location: 'Ward 3B',
      description: 'BP 180/110 · Immediate attention required',
    ),
    EmergencyAlert(
      id: 'alert-002',
      severity: AlertSeverity.urgent,
      patientName: 'Jean Mugisha',
      location: 'Lab Results',
      description: 'HbA1c critically elevated · Review now',
    ),
  ];

  @override
  Future<List<DashboardStat>> getDashboardStats() async => const [
    DashboardStat(
      id: 'stat-patients',
      label: 'Patients Today',
      value: 14,
      icon: LucideIcons.users,
      color: AppColors.primary,
    ),
    DashboardStat(
      id: 'stat-queue',
      label: 'In Queue',
      value: 6,
      icon: LucideIcons.clock,
      color: AppColors.secondary,
    ),
    DashboardStat(
      id: 'stat-referrals',
      label: 'Referrals',
      value: 3,
      icon: LucideIcons.send,
      color: AppColors.warning,
    ),
  ];

  @override
  Future<List<ScheduleItem>> getTodaySchedule() async => const [
    ScheduleItem(
      id: 'sched-001',
      time: '08:30 AM',
      patientName: 'Amina Kalisa',
      reason: 'Diabetes follow-up',
      durationMinutes: 30,
      status: ScheduleStatus.now,
    ),
  ];

  @override
  Future<List<QueuePatient>> getPatientQueue() async => const [
    QueuePatient(
      id: 'queue-001',
      queueNumber: 1,
      name: 'Vestine Umubyeyi',
      reason: 'Chest pain',
      priority: QueuePriority.urgent,
    ),
  ];

  @override
  Future<List<Referral>> getReferrals() async => const [
    Referral(
      id: 'ref-001',
      patientName: 'Jean Mugisha',
      specialty: 'Cardiology',
      facility: 'CHUK',
      status: ReferralStatus.pending,
      note: 'Sent 2 days ago',
    ),
  ];

  @override
  Future<AiInsight> getAiInsight() async => const AiInsight(
    title: 'AI Clinical Insight',
    timestampLabel: 'Just now',
    message: 'Test panel insight for follow-up gaps.',
  );
}
