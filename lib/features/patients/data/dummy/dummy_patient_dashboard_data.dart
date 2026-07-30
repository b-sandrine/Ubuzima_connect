import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/theme/app_colors.dart';
import '../../domain/models/ai_health_insight.dart';
import '../../domain/models/bp_trend_point.dart';
import '../../domain/models/care_item.dart';
import '../../domain/models/health_score.dart';
import '../../domain/models/medication_reminder.dart';
import '../../domain/models/patient_profile.dart';
import '../../domain/models/quick_link.dart';
import '../../domain/models/vital_reading.dart';

/// Seeded data behind [MockPatientDashboardRepository]. Kept in its own file
/// so swapping in a Firestore-backed repository later is a data-source
/// change only — nothing in `presentation/` has to move.
abstract final class DummyPatientDashboardData {
  /// The AI Insight / Lab / Health-ID accent purple used across the design
  /// file for AI-generated content — not part of the shared palette since
  /// only the doctor and patient AI surfaces use it.
  static const Color aiPurple = Color(0xFF7C3AED);
  static const Color labPurple = Color(0xFF8B5CF6);
  static const Color glucoseTeal = Color(0xFF0D9488);

  static const PatientProfile patient = PatientProfile(
    id: 'pat-2847',
    fullName: 'Marie Uwase',
    displayId: 'RW-2847',
    dateLabel: 'Monday, Jun 2',
    verified: true,
  );

  static const HealthScore healthScore = HealthScore(
    score: 82,
    maxScore: 100,
    statusLabel: 'Good',
    trendLabel: 'Stable trend',
    weeklyChangeLabel: '+4 pts this week',
  );

  static const List<VitalReading> todayVitals = [
    VitalReading(
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
      iconColor: glucoseTeal,
      badgeLabel: 'Normal',
      badgeColor: AppColors.success,
    ),
    VitalReading(
      id: 'vital-weight',
      label: 'Weight',
      value: '67.2',
      subLabel: 'kg · BMI 24.1',
      icon: LucideIcons.weight,
      iconColor: AppColors.secondary,
      badgeLabel: 'Stable',
      badgeColor: AppColors.secondary,
    ),
    VitalReading(
      id: 'vital-spo2',
      label: 'SpO2',
      value: '98%',
      subLabel: 'Oxygen Sat.',
      icon: LucideIcons.wind,
      iconColor: aiPurple,
      badgeLabel: 'Normal',
      badgeColor: AppColors.success,
    ),
  ];

  static const List<MedicationReminder> medicationReminders = [
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

  static const List<CareItem> upcomingCare = [
    CareItem(
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
      dateColor: labPurple,
      icon: LucideIcons.flaskConical,
      iconColor: labPurple,
    ),
  ];

  static const AiHealthInsight aiHealthInsight = AiHealthInsight(
    title: 'Trend Detected',
    tagLabel: 'AI',
    message:
        'Your blood pressure readings have been elevated for 3 consecutive '
        'days. Consider reducing sodium intake and increasing hydration.',
    updatedLabel: 'Updated today · 06:00 AM',
  );

  static const List<QuickLink> quickLinks = [
    QuickLink(
      id: 'quick-health-id',
      icon: LucideIcons.grid2x2,
      label: 'Health ID',
      color: AppColors.primary,
      selected: true,
    ),
    QuickLink(
      id: 'quick-records',
      icon: LucideIcons.folderOpen,
      label: 'Records',
      color: AppColors.secondary,
    ),
    QuickLink(
      id: 'quick-meds',
      icon: LucideIcons.pill,
      label: 'Meds',
      color: AppColors.warning,
    ),
    QuickLink(
      id: 'quick-ai-insights',
      icon: LucideIcons.brain,
      label: 'AI Insights',
      color: aiPurple,
    ),
  ];

  static const List<BpTrendPoint> bpTrend = [
    BpTrendPoint(dayLabel: 'Mon', systolic: 132, diastolic: 82),
    BpTrendPoint(dayLabel: 'Tue', systolic: 136, diastolic: 84),
    BpTrendPoint(dayLabel: 'Wed', systolic: 140, diastolic: 85),
    BpTrendPoint(dayLabel: 'Thu', systolic: 138, diastolic: 83),
    BpTrendPoint(dayLabel: 'Fri', systolic: 141, diastolic: 86),
    BpTrendPoint(dayLabel: 'Sat', systolic: 137, diastolic: 84),
    BpTrendPoint(dayLabel: 'Sun', systolic: 136, diastolic: 83),
  ];
}
