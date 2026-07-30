import 'package:flutter/material.dart';

import 'notification_item.dart';

/// A labelled group of notifications, e.g. "Appointment Reminders" or
/// "Referral Updates" — both the doctor and patient feeds are just
/// different seeded lists of these.
class NotificationSection {
  final String title;
  final IconData icon;
  final Color color;
  final List<NotificationItem> items;

  const NotificationSection({
    required this.title,
    required this.icon,
    required this.color,
    required this.items,
  });
}
