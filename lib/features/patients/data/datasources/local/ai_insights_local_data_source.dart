import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../domain/models/ai_health_summary.dart';
import '../../../domain/models/bp_trend_point.dart';
import '../../../domain/models/guidance_tip.dart';
import '../../../domain/models/health_overview.dart';
import '../../../domain/models/recent_insight.dart';
import '../../../domain/models/risk_signal.dart';
import '../../../domain/models/vital_reading.dart';

/// Seed values for the AI Insights screen, written into Firestore on first
/// read. Icon/colour for summary metrics, risk signals, guidance tips and
/// recent insights are cosmetic constants keyed by id —
/// [AiInsightsRemoteDataSource] pairs them with the live value/description
/// fields.
abstract interface class AiInsightsLocalDataSource {
  HealthOverview readHealthOverview();

  List<VitalReading> readHealthSummaryMetrics();

  List<BpTrendPoint> readBpTrend30Days();

  List<RiskSignal> readRiskSignals();

  List<GuidanceTip> readGuidanceTips();

  AiHealthSummary readAiHealthSummary();

  List<RecentInsight> readRecentInsights();
}

@LazySingleton(as: AiInsightsLocalDataSource)
class AiInsightsLocalDataSourceImpl implements AiInsightsLocalDataSource {
  static const Color _aiPurple = Color(0xFF7C3AED);

  @override
  HealthOverview readHealthOverview() => const HealthOverview(
    score: 75,
    maxScore: 100,
    statusLabel: 'Good Health',
    trendLabel: 'Stable',
    signalsCount: 3,
    positiveCount: 2,
    watchCount: 1,
  );

  @override
  List<VitalReading> readHealthSummaryMetrics() => const [
    VitalReading(
      id: 'summary-bp',
      label: 'Blood Pressure',
      value: '138/88',
      subLabel: '↑ +6 mmHg',
      icon: LucideIcons.heartPulse,
      iconColor: AppColors.danger,
      badgeLabel: 'Watch',
      badgeColor: AppColors.warning,
    ),
    VitalReading(
      id: 'summary-glucose',
      label: 'Blood Glucose',
      value: '6.2',
      subLabel: '↓ -0.4 mmol/L',
      icon: LucideIcons.droplet,
      iconColor: Color(0xFF0D9488),
      badgeLabel: 'Good',
      badgeColor: AppColors.success,
    ),
    VitalReading(
      id: 'summary-weight',
      label: 'Body Weight',
      value: '68 kg',
      subLabel: 'No change',
      icon: LucideIcons.weight,
      iconColor: AppColors.secondary,
      badgeLabel: 'Stable',
      badgeColor: AppColors.secondary,
    ),
    VitalReading(
      id: 'summary-medication',
      label: 'Medication',
      value: '92%',
      subLabel: '↑ Adherence',
      icon: LucideIcons.pill,
      iconColor: AppColors.success,
      badgeLabel: 'Good',
      badgeColor: AppColors.success,
    ),
  ];

  @override
  List<BpTrendPoint> readBpTrend30Days() {
    const systolic = [
      130, 131, 133, 132, 134, 136, 135, 137, 139, 138, //
      140, 142, 141, 139, 138, 140, 141, 143, 142, 140, //
      139, 141, 143, 144, 142, 140, 139, 141, 140, 138, //
    ];
    const diastolic = [
      78, 79, 80, 79, 81, 82, 81, 83, 84, 82, //
      85, 86, 84, 82, 81, 83, 84, 85, 83, 82, //
      81, 83, 85, 86, 84, 82, 81, 83, 82, 80, //
    ];
    final start = DateTime(2025, 5, 3);

    return [
      for (var i = 0; i < systolic.length; i++)
        BpTrendPoint(
          dayLabel: _shortDate(start.add(Duration(days: i))),
          systolic: systolic[i].toDouble(),
          diastolic: diastolic[i].toDouble(),
        ),
    ];
  }

  String _shortDate(DateTime date) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', //
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    return '${months[date.month - 1]} ${date.day}';
  }

  @override
  List<RiskSignal> readRiskSignals() => const [
    RiskSignal(
      id: 'risk-hypertension',
      icon: LucideIcons.heartPulse,
      color: AppColors.warning,
      title: 'Hypertension Risk',
      levelLabel: 'Moderate',
      level: RiskSignalLevel.moderate,
      progress: 0.6,
      description:
          'BP readings trending upward over 2 weeks. Consider dietary '
          'review and consult Dr. Mukamana.',
    ),
    RiskSignal(
      id: 'risk-glucose',
      icon: LucideIcons.droplet,
      color: AppColors.success,
      title: 'Glucose Control',
      levelLabel: 'Low Risk',
      level: RiskSignalLevel.low,
      progress: 0.3,
      description:
          'HbA1c stable at 6.2%. Metformin adherence is excellent. Keep '
          'up the good work!',
    ),
    RiskSignal(
      id: 'risk-cardiovascular',
      icon: LucideIcons.wind,
      color: AppColors.secondary,
      title: 'Cardiovascular',
      levelLabel: 'Monitoring',
      level: RiskSignalLevel.monitoring,
      progress: 0.45,
      description:
          'Combined hypertension and diabetes increases cardiovascular '
          'risk. Annual ECG recommended.',
    ),
  ];

  @override
  List<GuidanceTip> readGuidanceTips() => const [
    GuidanceTip(
      id: 'guidance-salt',
      icon: LucideIcons.utensils,
      iconColor: AppColors.success,
      title: 'Reduce Salt Intake',
      tagLabel: 'Priority',
      tagColor: AppColors.warning,
      description:
          'Limit sodium to under 2g/day to help manage your blood '
          'pressure. Avoid processed foods and add less salt when cooking.',
    ),
    GuidanceTip(
      id: 'guidance-walk',
      icon: LucideIcons.footprints,
      iconColor: AppColors.secondary,
      title: 'Daily 30-min Walk',
      tagLabel: 'Suggested',
      tagColor: AppColors.secondary,
      description:
          'Moderate aerobic exercise helps lower blood pressure and '
          'improves insulin sensitivity. Start with 15 minutes if needed.',
    ),
    GuidanceTip(
      id: 'guidance-followup',
      icon: LucideIcons.calendarClock,
      iconColor: _aiPurple,
      title: 'Schedule Follow-Up',
      tagLabel: 'Due Soon',
      tagColor: _aiPurple,
      description:
          'Your last BP check was 3 weeks ago. Book a follow-up with Dr. '
          'Mukamana at Gasabo CHC to reassess your medication dosage.',
      ctaLabel: 'Book Now',
    ),
  ];

  @override
  AiHealthSummary readAiHealthSummary() => const AiHealthSummary(
    patientName: 'Marie Uwase',
    dateLabel: 'June 2, 2025',
    body:
        'Overall, your health is stable and improving. Blood glucose '
        'control is excellent with Metformin adherence at 92%. However, '
        'blood pressure readings have increased slightly over the past 2 '
        'weeks — this warrants attention.\n\n'
        'Your combined risk profile (hypertension + diabetes) places you '
        'at moderate cardiovascular risk. Prioritizing salt reduction, '
        'regular exercise, and your upcoming follow-up will significantly '
        'reduce this risk.',
    tags: [
      AiSummaryTag(
        icon: LucideIcons.circleCheck,
        label: 'Meds on track',
        color: AppColors.success,
      ),
      AiSummaryTag(
        icon: LucideIcons.triangleAlert,
        label: 'BP needs watch',
        color: AppColors.warning,
      ),
      AiSummaryTag(
        icon: LucideIcons.calendarClock,
        label: 'Follow-up due',
        color: _aiPurple,
      ),
    ],
  );

  @override
  List<RecentInsight> readRecentInsights() => const [
    RecentInsight(
      id: 'insight-streak',
      icon: LucideIcons.pill,
      iconColor: AppColors.success,
      title: 'Medication Streak: 7 days',
      timestampLabel: 'Today',
      description:
          'All 3 medications taken on time. Excellent consistency this week.',
    ),
    RecentInsight(
      id: 'insight-bp',
      icon: LucideIcons.heartPulse,
      iconColor: AppColors.danger,
      title: 'BP Elevated Reading',
      timestampLabel: 'Yesterday',
      description:
          'Reading of 142/90 detected. AI flagged for monitoring. Reduce '
          'stress and salt.',
    ),
    RecentInsight(
      id: 'insight-labs',
      icon: LucideIcons.flaskConical,
      iconColor: _aiPurple,
      title: 'Lab Results Reviewed',
      timestampLabel: 'May 30',
      description:
          'HbA1c 6.2%, Creatinine normal. AI analysis: diabetes '
          'well-controlled.',
    ),
  ];
}
