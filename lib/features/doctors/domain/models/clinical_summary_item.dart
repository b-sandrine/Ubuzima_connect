import 'package:flutter/material.dart';

/// One collapsible row in the Clinical Summary Cards section (Current
/// Medications, Lab Results, Follow-Up Plan).
class ClinicalSummaryItem {
  final IconData icon;
  final String title;
  final String subtitle;

  const ClinicalSummaryItem({
    required this.icon,
    required this.title,
    required this.subtitle,
  });
}
