import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/theme/app_colors.dart';
import '../../domain/models/notification_item.dart';
import '../../domain/models/notification_section.dart';

/// Seeded data behind [MockPatientNotificationsRepository].
///
/// No dedicated patient notifications design was available (the design
/// file only had the doctor list), so per product direction this reuses
/// the doctor screen's card language and section structure — icon tile,
/// coloured accent, badge, action button — retold from the patient's own
/// point of view instead of a clinician's. Content stays consistent with
/// the seeded patient dashboard/records data (Marie Uwase, Dr. Mukamana).
abstract final class DummyPatientNotificationsData {
  static const Color aiPurple = Color(0xFF7C3AED);

  static const List<NotificationSection> sections = [
    NotificationSection(
      title: 'Medication Reminders',
      icon: LucideIcons.pill,
      color: AppColors.warning,
      items: [
        NotificationItem(
          id: 'notif-dose-due',
          title: 'Dose Due Now',
          subtitleLine: 'Metformin 500mg',
          description: '1 tablet with lunch. Tap to mark as taken or snooze.',
          timestampLabel: '10 min ago',
          badgeLabel: 'DUE',
          badgeColor: AppColors.warning,
          accentColor: AppColors.warning,
          icon: LucideIcons.pill,
          actionLabel: 'Mark Taken',
          actionIcon: LucideIcons.check,
        ),
        NotificationItem(
          id: 'notif-refill-reminder',
          title: 'Refill Reminder',
          subtitleLine: 'Amlodipine 5mg',
          description: '5 tablets left — refill needed before Jun 7.',
          timestampLabel: '3 hr ago',
          badgeLabel: 'LOW STOCK',
          badgeColor: AppColors.danger,
          accentColor: AppColors.danger,
          icon: LucideIcons.pill,
          actionLabel: 'Request Refill',
          actionIcon: LucideIcons.refreshCw,
        ),
      ],
    ),
    NotificationSection(
      title: 'Appointment Updates',
      icon: LucideIcons.calendarClock,
      color: AppColors.secondary,
      items: [
        NotificationItem(
          id: 'notif-appt-confirmed',
          title: 'Appointment Confirmed',
          subtitleLine: 'Dr. A. Mukamana · CHC Kigali',
          description: 'Your BP Follow-Up is confirmed for 10:00 AM, Room 3.',
          timestampLabel: '5 hr ago',
          badgeLabel: 'Tomorrow',
          badgeColor: AppColors.secondary,
          accentColor: AppColors.secondary,
          icon: LucideIcons.calendarCheck,
          actionLabel: 'View Details',
          actionIcon: LucideIcons.clipboardList,
        ),
        NotificationItem(
          id: 'notif-appt-rescheduled',
          title: 'Appointment Rescheduled',
          subtitleLine: 'Dr. J. Habimana · CHC Kigali',
          description:
              'Your Diabetes Review has been moved to Jun 12, 09:00 AM.',
          timestampLabel: 'Yesterday',
          badgeLabel: 'Read',
          badgeColor: AppColors.textTertiary,
          badgeFilled: false,
          accentColor: AppColors.textTertiary,
          icon: LucideIcons.calendarClock,
          isRead: true,
        ),
      ],
    ),
    NotificationSection(
      title: 'AI Health Insights',
      icon: LucideIcons.brain,
      color: aiPurple,
      items: [
        NotificationItem(
          id: 'notif-ai-trend',
          title: 'Trend Detected',
          subtitleLine: 'Blood Pressure · 3-day pattern',
          description:
              'Your blood pressure readings have been elevated for 3 '
              'consecutive days. Consider reducing sodium intake and '
              'increasing hydration.',
          timestampLabel: 'Today, 06:00 AM',
          badgeLabel: 'AI',
          badgeColor: aiPurple,
          accentColor: aiPurple,
          icon: LucideIcons.brain,
          actionLabel: 'Learn More',
          actionIcon: LucideIcons.info,
        ),
      ],
    ),
  ];
}
