import 'package:flutter/material.dart';

/// One row in the Recent Insights list — a past AI-flagged event with a
/// short explanation, newest first.
class RecentInsight {
  final String id;
  final IconData icon;
  final Color iconColor;
  final String title;
  final String timestampLabel;
  final String description;

  const RecentInsight({
    required this.id,
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.timestampLabel,
    required this.description,
  });
}
