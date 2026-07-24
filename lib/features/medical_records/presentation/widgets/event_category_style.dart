import 'package:flutter/material.dart';

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
      icon: Icons.emergency_outlined,
    ),
    EventCategory.labResult => const EventCategoryStyle(
      color: AppColors.warning,
      label: 'Lab Result',
      icon: Icons.science_outlined,
    ),
    EventCategory.prescription => const EventCategoryStyle(
      color: Color(0xFF6366F1),
      label: 'Prescription',
      icon: Icons.medication_outlined,
    ),
    EventCategory.visit => const EventCategoryStyle(
      color: AppColors.primary,
      label: 'Visit',
      icon: Icons.event_available_outlined,
    ),
    EventCategory.diagnosis => const EventCategoryStyle(
      color: AppColors.secondary,
      label: 'Diagnosis',
      icon: Icons.assignment_outlined,
    ),
    EventCategory.referral => const EventCategoryStyle(
      color: Color(0xFFF59E0B),
      label: 'Referral',
      icon: Icons.share_outlined,
    ),
  };
}
