import 'package:flutter/material.dart';

/// One tile in Today's Vitals — a single measurement with its status badge.
class VitalReading {
  final String id;
  final String label;
  final String value;
  final String subLabel;
  final IconData icon;
  final Color iconColor;
  final String badgeLabel;
  final Color badgeColor;

  const VitalReading({
    required this.id,
    required this.label,
    required this.value,
    required this.subLabel,
    required this.icon,
    required this.iconColor,
    required this.badgeLabel,
    required this.badgeColor,
  });
}
