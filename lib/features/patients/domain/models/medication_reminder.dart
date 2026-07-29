import 'package:flutter/material.dart';

/// Where a [MedicationReminder] sits relative to the current time.
enum MedicationStatus {
  /// Due right now — surfaces the Mark Taken / Snooze actions.
  dueNow,

  /// Already taken today — surfaces the streak line instead of actions.
  taken,

  /// Scheduled later today — informational only.
  upcoming,
}

/// One row in Medication Reminders.
class MedicationReminder {
  final String id;
  final String name;
  final String detailLine;
  final IconData icon;
  final Color iconColor;
  final MedicationStatus status;
  final String pillLabel;
  final Color pillColor;

  /// Small caption under the pill, e.g. "Taken at 6:08 AM" — only set when
  /// [status] is [MedicationStatus.taken].
  final String? pillCaption;

  /// Consecutive on-time days, shown as "Streak: N days in a row" — only set
  /// when [status] is [MedicationStatus.taken].
  final int? streakDays;

  const MedicationReminder({
    required this.id,
    required this.name,
    required this.detailLine,
    required this.icon,
    required this.iconColor,
    required this.status,
    required this.pillLabel,
    required this.pillColor,
    this.pillCaption,
    this.streakDays,
  });
}
