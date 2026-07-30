import 'package:flutter/material.dart';

/// One tile in the dashboard's Quick Actions row.
class QuickLink {
  final String id;
  final IconData icon;
  final String label;
  final Color color;

  /// Whether this tile reads as the current/default section (Health ID in
  /// the design ships with a tinted background rather than plain white).
  final bool selected;

  const QuickLink({
    required this.id,
    required this.icon,
    required this.label,
    required this.color,
    this.selected = false,
  });
}
