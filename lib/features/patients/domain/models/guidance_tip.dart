import 'package:flutter/material.dart';

/// One actionable recommendation in the Personalized Guidance section.
/// [ctaLabel] is null for tips with no follow-on action (e.g. dietary
/// advice you just read), and set for ones with a booking-style action
/// ("Book Now").
class GuidanceTip {
  final String id;
  final IconData icon;
  final Color iconColor;
  final String title;
  final String tagLabel;
  final Color tagColor;
  final String description;
  final String? ctaLabel;

  const GuidanceTip({
    required this.id,
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.tagLabel,
    required this.tagColor,
    required this.description,
    this.ctaLabel,
  });
}
