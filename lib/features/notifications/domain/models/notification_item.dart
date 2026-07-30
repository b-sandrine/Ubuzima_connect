import 'package:flutter/material.dart';

/// One entry in a notifications list — deliberately generic (icon or avatar
/// leading, an optional badge, an optional action) so the same widget
/// renders a doctor's clinical alert and a patient's medication reminder
/// without needing separate card types.
class NotificationItem {
  final String id;
  final String title;
  final String subtitleLine;
  final String description;
  final String timestampLabel;
  final String badgeLabel;
  final Color badgeColor;

  /// Filled badges read as active/urgent (HIGH, Today, Accepted); outlined
  /// badges read as neutral/settled (2:00 PM, Read).
  final bool badgeFilled;

  final Color accentColor;
  final IconData icon;

  /// When set, the card shows this photo instead of [icon] — the design
  /// uses a patient photo for appointment cards but a generic icon for
  /// system events (cancellations, referrals, AI insights).
  final String? avatarUrl;

  final String? actionLabel;
  final IconData? actionIcon;

  /// Read notifications render at reduced visual weight and drop the
  /// action button, matching the design's "Appointment Cancelled · Read"
  /// card.
  final bool isRead;

  const NotificationItem({
    required this.id,
    required this.title,
    required this.subtitleLine,
    required this.description,
    required this.timestampLabel,
    required this.badgeLabel,
    required this.badgeColor,
    required this.accentColor,
    required this.icon,
    this.badgeFilled = true,
    this.avatarUrl,
    this.actionLabel,
    this.actionIcon,
    this.isRead = false,
  });
}
