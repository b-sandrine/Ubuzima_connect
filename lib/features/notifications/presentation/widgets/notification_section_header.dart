import 'package:flutter/material.dart';

import '../../domain/models/notification_section.dart';

/// The small coloured icon + uppercase label above each notification group
/// (e.g. "Appointment Reminders", "Referral Updates").
class NotificationSectionHeader extends StatelessWidget {
  final NotificationSection section;

  const NotificationSectionHeader({super.key, required this.section});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(section.icon, size: 15, color: section.color),
        const SizedBox(width: 6),
        Text(
          section.title.toUpperCase(),
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.6,
            color: section.color,
          ),
        ),
      ],
    );
  }
}
