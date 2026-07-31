import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../domain/models/ai_health_insight.dart';
import '../../../domain/models/bp_trend_point.dart';
import '../../../domain/models/care_item.dart';
import '../../../domain/models/health_score.dart';
import '../../../domain/models/medication_reminder.dart';
import '../../../domain/models/patient_profile.dart';
import '../../../domain/models/quick_link.dart';
import '../../../domain/models/vital_reading.dart';

/// Seed values for the patient Home dashboard, written into Firestore on
/// first read. Icon/colour for vitals, medications, care items and quick
/// links are cosmetic constants keyed by id —
/// [PatientDashboardRemoteDataSource] pairs them with the live
/// value/status/label fields.
abstract interface class PatientDashboardLocalDataSource {
  PatientProfile readPatient();

  HealthScore readHealthScore();

  List<VitalReading> readTodayVitals();

  List<MedicationReminder> readMedicationReminders();

  List<CareItem> readUpcomingCare();

  AiHealthInsight readAiHealthInsight();

  List<QuickLink> readQuickLinks();

  List<BpTrendPoint> readBpTrend();
}

@LazySingleton(as: PatientDashboardLocalDataSource)
class PatientDashboardLocalDataSourceImpl
    implements PatientDashboardLocalDataSource {
  static const Color _aiPurple = Color(0xFF7C3AED);
  static const Color _labPurple = Color(0xFF8B5CF6);
  static const Color _glucoseTeal = Color(0xFF0D9488);

  @override
  PatientProfile readPatient() => const PatientProfile(
    id: 'pat-2847',
    fullName: 'Marie Uwase',
    displayId: 'RW-2847',
    dateLabel: 'Monday, Jun 2',
    verified: true,
  );

  @override
  HealthScore readHealthScore() => const HealthScore(
    score: 82,
    maxScore: 100,
    statusLabel: 'Good',
    trendLabel: 'Stable trend',
    weeklyChangeLabel: '+4 pts this week',
  );

  @override
  List<VitalReading> readTodayVitals() => [
    const VitalReading(
      id: 'vital-bp',
      label: 'Blood Pressure',
      value: '138/88',
      subLabel: 'mmHg · 7:14 AM',
      icon: LucideIcons.heartPulse,
      iconColor: AppColors.danger,
      badgeLabel: 'Monitor',
      badgeColor: AppColors.warning,
    ),
    VitalReading(
      id: 'vital-glucose',
      label: 'Blood Glucose',
      value: '5.6',
      subLabel: 'mmol/L · Fasting',
      icon: LucideIcons.droplet,
      iconColor: _glucoseTeal,
      badgeLabel: 'Normal',
      badgeColor: AppColors.success,
    ),
    const VitalReading(
      id: 'vital-weight',
      label: 'Weight',
      value: '67.2',
      subLabel: 'kg · BMI 24.1',
      icon: LucideIcons.weight,
      iconColor: AppColors.secondary,
      badgeLabel: 'Stable',
      badgeColor: AppColors.secondary,
    ),
    const VitalReading(
      id: 'vital-spo2',
      label: 'SpO2',
      value: '98%',
      subLabel: 'Oxygen Sat.',
      icon: LucideIcons.wind,
      iconColor: _aiPurple,
      badgeLabel: 'Normal',
      badgeColor: AppColors.success,
    ),
  ];

  @override
  List<MedicationReminder> readMedicationReminders() => const [
    MedicationReminder(
      id: 'med-amlodipine',
      name: 'Amlodipine 5mg',
      detailLine: '08:00 AM · 1 tablet · Hypertension',
      icon: LucideIcons.pill,
      iconColor: AppColors.warning,
      status: MedicationStatus.dueNow,
      pillLabel: 'DUE NOW',
      pillColor: AppColors.warning,
    ),
    MedicationReminder(
      id: 'med-lisinopril',
      name: 'Lisinopril 10mg',
      detailLine: '06:00 AM · 1 tablet',
      icon: LucideIcons.pill,
      iconColor: AppColors.success,
      status: MedicationStatus.taken,
      pillLabel: 'TAKEN',
      pillColor: AppColors.success,
      pillCaption: 'Taken at 6:08 AM',
      streakDays: 14,
    ),
    MedicationReminder(
      id: 'med-metformin',
      name: 'Metformin 500mg',
      detailLine: 'With lunch · 1 tablet · Diabetes',
      icon: LucideIcons.syringe,
      iconColor: AppColors.secondary,
      status: MedicationStatus.upcoming,
      pillLabel: '12:00 PM',
      pillColor: AppColors.textTertiary,
    ),
  ];

  @override
  List<CareItem> readUpcomingCare() => [
    const CareItem(
      id: 'care-bp-followup',
      title: 'BP Follow-Up',
      subtitle: 'Dr. A. Mukamana',
      detail: 'Jun 3 · 10:00 AM · CHC Kigali, Room 3',
      dateLabel: 'Tomorrow',
      dateColor: AppColors.secondary,
      icon: LucideIcons.calendarClock,
      iconColor: AppColors.secondary,
      primaryActionLabel: 'Confirm',
      primaryActionIcon: LucideIcons.calendarCheck,
      secondaryActionLabel: 'Reschedule',
    ),
    CareItem(
      id: 'care-lab-tests',
      title: 'Lab Tests Due',
      subtitle: 'HbA1c, Lipid Panel, Kidney Function',
      detail: 'CHC Kigali Lab · Fasting required',
      dateLabel: 'Jun 10',
      dateColor: _labPurple,
      icon: LucideIcons.flaskConical,
      iconColor: _labPurple,
    ),
  ];

  @override
  AiHealthInsight readAiHealthInsight() => const AiHealthInsight(
    title: 'Trend Detected',
    tagLabel: 'AI',
    message:
        'Your blood pressure readings have been elevated for 3 consecutive '
        'days. Consider reducing sodium intake and increasing hydration.',
    updatedLabel: 'Updated today · 06:00 AM',
  );

  @override
  List<QuickLink> readQuickLinks() => [
    const QuickLink(
      id: 'quick-health-id',
      icon: LucideIcons.grid2x2,
      label: 'Health ID',
      color: AppColors.primary,
      selected: true,
    ),
    const QuickLink(
      id: 'quick-records',
      icon: LucideIcons.folderOpen,
      label: 'Records',
      color: AppColors.secondary,
    ),
    const QuickLink(
      id: 'quick-meds',
      icon: LucideIcons.pill,
      label: 'Meds',
      color: AppColors.warning,
    ),
    QuickLink(
      id: 'quick-ai-insights',
      icon: LucideIcons.brain,
      label: 'AI Insights',
      color: _aiPurple,
    ),
  ];

  @override
  List<BpTrendPoint> readBpTrend() => const [
    BpTrendPoint(dayLabel: 'Mon', systolic: 132, diastolic: 82),
    BpTrendPoint(dayLabel: 'Tue', systolic: 136, diastolic: 84),
    BpTrendPoint(dayLabel: 'Wed', systolic: 140, diastolic: 85),
    BpTrendPoint(dayLabel: 'Thu', systolic: 138, diastolic: 83),
    BpTrendPoint(dayLabel: 'Fri', systolic: 141, diastolic: 86),
    BpTrendPoint(dayLabel: 'Sat', systolic: 137, diastolic: 84),
    BpTrendPoint(dayLabel: 'Sun', systolic: 136, diastolic: 83),
  ];
}
