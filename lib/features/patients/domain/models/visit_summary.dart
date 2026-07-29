import 'package:flutter/material.dart';

/// One quick-fact chip on a [VisitSummary] card, e.g. "2 Rx Updated" or
/// "Lab Ordered" — everything except the always-present Full Report action.
class VisitChip {
  final IconData icon;
  final String label;
  final Color color;

  const VisitChip({required this.icon, required this.label, required this.color});
}

/// One entry in the Visit Summaries list on the Medical Records screen.
class VisitSummary {
  final String id;
  final String title;
  final String dateLabel;
  final String statusLabel;
  final Color statusColor;
  final IconData icon;
  final Color iconColor;
  final String doctorLine;
  final String description;
  final List<VisitChip> chips;

  const VisitSummary({
    required this.id,
    required this.title,
    required this.dateLabel,
    required this.statusLabel,
    required this.statusColor,
    required this.icon,
    required this.iconColor,
    required this.doctorLine,
    required this.description,
    this.chips = const [],
  });
}
