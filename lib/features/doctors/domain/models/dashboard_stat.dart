import 'package:flutter/material.dart';

/// One tile in a stat row (the dashboard's Patients Today / In Queue /
/// Referrals, or the patient search screen's Total / Seen Today / Critical).
/// [icon] and [color] are carried on the model rather than hard-coded per
/// widget instance so a future Firestore document can drive them too (e.g.
/// an admin-configurable stat set). [icon] is optional — some stat rows
/// (patient search) render as plain number-over-label tiles.
class DashboardStat {
  final String id;
  final String label;
  final int value;
  final IconData? icon;
  final Color color;

  const DashboardStat({
    required this.id,
    required this.label,
    required this.value,
    this.icon,
    required this.color,
  });
}
