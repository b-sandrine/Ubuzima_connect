import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/timeline_event.dart';

/// Presentation mapping for a timeline event category — the node colour, the
/// badge label, and the icon. Kept in one place so the node, the badge, and
/// any legend never drift apart.
class EventCategoryStyle {
  final Color color;
  final String label;
  final IconData icon;

  const EventCategoryStyle({
    required this.color,
    required this.label,
    required this.icon,
  });

  static EventCategoryStyle of(EventCategory category) => switch (category) {
    EventCategory.emergency => const EventCategoryStyle(
      color: AppColors.danger,
      label: 'Emergency',
      icon: LucideIcons.triangleAlert,
    ),
    EventCategory.labResult => const EventCategoryStyle(
      color: AppColors.warning,
      label: 'Lab Results',
      icon: LucideIcons.flaskConical,
    ),
    EventCategory.prescription => const EventCategoryStyle(
      color: Color(0xFF6366F1),
      label: 'Medication',
      icon: LucideIcons.pill,
    ),
    EventCategory.visit => const EventCategoryStyle(
      color: AppColors.primary,
      label: 'Visit',
      icon: LucideIcons.stethoscope,
    ),
    EventCategory.diagnosis => const EventCategoryStyle(
      color: AppColors.secondary,
      label: 'Diagnosis',
      icon: LucideIcons.clipboardList,
    ),
    EventCategory.referral => const EventCategoryStyle(
      color: Color(0xFFF59E0B),
      label: 'Referral',
      icon: LucideIcons.share2,
    ),
  };
}
