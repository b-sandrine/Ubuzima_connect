import 'package:flutter/material.dart';

/// One row in Upcoming Care — an appointment or a pending lab order.
class CareItem {
  final String id;
  final String title;
  final String subtitle;
  final String detail;
  final String dateLabel;
  final Color dateColor;
  final IconData icon;
  final Color iconColor;
  final String? primaryActionLabel;
  final IconData? primaryActionIcon;
  final String? secondaryActionLabel;

  const CareItem({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.detail,
    required this.dateLabel,
    required this.dateColor,
    required this.icon,
    required this.iconColor,
    this.primaryActionLabel,
    this.primaryActionIcon,
    this.secondaryActionLabel,
  });
}
