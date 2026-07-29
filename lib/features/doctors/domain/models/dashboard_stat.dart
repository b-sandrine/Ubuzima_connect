import 'package:flutter/material.dart';

/// One tile in the dashboard's stat row (Patients Today, In Queue,
/// Referrals). [icon] and [color] are carried on the model rather than
/// hard-coded per widget instance so a future Firestore document can drive
/// them too (e.g. an admin-configurable stat set).
class DashboardStat {
  final String id;
  final String label;
  final int value;
  final IconData icon;
  final Color color;

  const DashboardStat({
    required this.id,
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });
}
