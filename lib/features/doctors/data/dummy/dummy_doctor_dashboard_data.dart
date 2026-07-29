import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/theme/app_colors.dart';
import '../../domain/models/ai_insight.dart';
import '../../domain/models/dashboard_stat.dart';
import '../../domain/models/doctor.dart';
import '../../domain/models/emergency_alert.dart';
import '../../domain/models/queue_patient.dart';
import '../../domain/models/referral.dart';
import '../../domain/models/schedule_item.dart';

/// Seeded data behind [MockDoctorDashboardRepository]. Kept in its own file
/// so swapping in a Firestore-backed repository later is a data-source
/// change only — nothing in `presentation/` has to move.
abstract final class DummyDoctorDashboardData {
  static const Doctor doctor = Doctor(
    id: 'doc-001',
    fullName: 'Dr. Jean-Pierre Habimana',
    hospital: 'Kigali District Hospital',
    onDuty: true,
  );

  static const List<EmergencyAlert> emergencyAlerts = [
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

  static const List<DashboardStat> dashboardStats = [
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

  static const List<ScheduleItem> todaySchedule = [
    ScheduleItem(
      id: 'sched-001',
      time: '08:30 AM',
      patientName: 'Amina Kalisa',
      reason: 'Diabetes follow-up',
      durationMinutes: 30,
      status: ScheduleStatus.now,
    ),
    ScheduleItem(
      id: 'sched-002',
      time: '09:15 AM',
      patientName: 'Patrick Nkurunziza',
      reason: 'Hypertension review',
      durationMinutes: 20,
      status: ScheduleStatus.next,
    ),
    ScheduleItem(
      id: 'sched-003',
      time: '10:00 AM',
      patientName: 'Claudine Mukamana',
      reason: 'Antenatal care',
      durationMinutes: 45,
    ),
  ];

  static const List<QueuePatient> patientQueue = [
    QueuePatient(
      id: 'queue-001',
      queueNumber: 1,
      name: 'Vestine Umubyeyi',
      reason: 'Chest pain',
      priority: QueuePriority.urgent,
    ),
    QueuePatient(
      id: 'queue-002',
      queueNumber: 2,
      name: 'Emmanuel Ndayisaba',
      reason: 'Fever, 38.9°C · 12 min wait',
      priority: QueuePriority.moderate,
    ),
    QueuePatient(
      id: 'queue-003',
      queueNumber: 3,
      name: 'Solange Uwera',
      reason: 'Routine check · 28 min wait',
      priority: QueuePriority.routine,
    ),
  ];

  static const List<Referral> referrals = [
    Referral(
      id: 'ref-001',
      patientName: 'Jean Mugisha',
      specialty: 'Cardiology',
      facility: 'CHUK',
      status: ReferralStatus.pending,
      note: 'Sent 2 days ago',
    ),
    Referral(
      id: 'ref-002',
      patientName: 'Amina Kalisa',
      specialty: 'Endocrinology',
      facility: 'King Faisal',
      status: ReferralStatus.approved,
      note: 'Confirmed',
    ),
  ];

  static const AiInsight aiInsight = AiInsight(
    title: 'AI Clinical Insight',
    timestampLabel: 'Just now',
    message:
        '3 of your patients with hypertension have not had follow-up in '
        'over 30 days. Consider scheduling check-ins for Patrick N., '
        'Claudine M. and 1 other.',
  );
}
