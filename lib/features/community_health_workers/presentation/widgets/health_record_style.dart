import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/health_record.dart';

/// Presentation mappings for the CHW health record — kept in one place so the
/// header badge, the risk ring, the symptom chips, and the next-step tiles
/// never drift from the design's colour language.
abstract final class HealthRecordStyle {
  static Color riskColor(RiskLevel level) => switch (level) {
    RiskLevel.low => AppColors.primary,
    RiskLevel.moderate => const Color(0xFFEA580C),
    RiskLevel.high => AppColors.danger,
    RiskLevel.critical => const Color(0xFF7F1D1D),
  };

  static String riskLabel(RiskLevel level) => switch (level) {
    RiskLevel.low => 'Low',
    RiskLevel.moderate => 'Moderate',
    RiskLevel.high => 'High',
    RiskLevel.critical => 'Critical',
  };

  static Color symptomColor(SymptomTone tone) => switch (tone) {
    SymptomTone.caution => const Color(0xFFEA580C),
    SymptomTone.watch => AppColors.secondary,
  };

  static IconData symptomIcon(String label) {
    final key = label.toLowerCase();
    if (key.contains('fatigue')) return LucideIcons.batteryLow;
    if (key.contains('nausea')) return LucideIcons.circleAlert;
    if (key.contains('swelling')) return LucideIcons.droplet;
    return LucideIcons.circleDot;
  }

  static ({IconData icon, Color color}) nextStep(NextStepKind kind) =>
      switch (kind) {
        NextStepKind.visit => (
          icon: LucideIcons.calendarCheck,
          color: const Color(0xFFEA580C),
        ),
        NextStepKind.check => (
          icon: LucideIcons.pencil,
          color: AppColors.secondary,
        ),
        NextStepKind.referral => (
          icon: LucideIcons.share2,
          color: const Color(0xFF7C3AED),
        ),
      };

  static IconData demographicIcon(String label) {
    final key = label.toLowerCase();
    if (key.contains('birth')) return LucideIcons.calendar;
    if (key.contains('household size')) return LucideIcons.users;
    if (key.contains('household')) return LucideIcons.house;
    if (key.contains('phone')) return LucideIcons.phone;
    if (key.contains('emergency')) return LucideIcons.contactRound;
    if (key.contains('language')) return LucideIcons.languages;
    return LucideIcons.idCard;
  }
}
