import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/theme/app_colors.dart';
import '../../domain/models/notification_item.dart';
import '../../domain/models/notification_section.dart';

/// Seeded data behind [MockDoctorNotificationsRepository]. Kept in its own
/// file so swapping in a Firestore-backed repository later is a
/// data-source change only — nothing in `presentation/` has to move.
abstract final class DummyDoctorNotificationsData {
  static const Color labPurple = Color(0xFF8B5CF6);
  static const Color referralGreen = Color(0xFF16A34A);

  static const List<NotificationSection> sections = [
    NotificationSection(
      title: 'Priority Alerts',
      icon: LucideIcons.triangleAlert,
      color: AppColors.danger,
      items: [
        NotificationItem(
          id: 'notif-medication-alert',
          title: 'Medication Alert',
          subtitleLine: 'Alice Nzeyimana · ID RW-3381',
          description:
              'Metformin contraindicated — eGFR now 41. Auto-flagged by AI. '
              'Prescription review action needed before next refill.',
          timestampLabel: '1 hr ago',
          badgeLabel: 'HIGH',
          badgeColor: AppColors.danger,
          accentColor: AppColors.danger,
          icon: LucideIcons.pill,
          actionLabel: 'Review Rx',
          actionIcon: LucideIcons.squarePen,
        ),
      ],
    ),
    NotificationSection(
      title: 'Appointment Reminders',
      icon: LucideIcons.calendarClock,
      color: AppColors.secondary,
      items: [
        NotificationItem(
          id: 'notif-appt-soon',
          title: 'Appointment in 30 min',
          subtitleLine: 'Claudine Mutesi · ID RW-4402',
          description: '09:30 AM · Diabetes follow-up · Room 3, CHC Kigali',
          timestampLabel: '2 hr ago',
          badgeLabel: 'Today',
          badgeColor: AppColors.secondary,
          accentColor: AppColors.secondary,
          icon: LucideIcons.userRound,
          actionLabel: 'Open Chart',
          actionIcon: LucideIcons.userRound,
        ),
        NotificationItem(
          id: 'notif-appt-confirmed',
          title: 'Appointment Confirmed',
          subtitleLine: 'Emmanuel Niyonzima · ID RW-2201',
          description: 'Hypertension management review. Patient confirmed via SMS.',
          timestampLabel: '3 hr ago',
          badgeLabel: '2:00 PM',
          badgeColor: AppColors.secondary,
          badgeFilled: false,
          accentColor: AppColors.secondary,
          icon: LucideIcons.userRound,
          actionLabel: 'View Appt',
          actionIcon: LucideIcons.clipboardList,
        ),
        NotificationItem(
          id: 'notif-appt-cancelled',
          title: 'Appointment Cancelled',
          subtitleLine: 'Odette Kayitesi · ID RW-5517',
          description:
              '11:00 AM appointment cancelled. Patient requested reschedule '
              'for next week.',
          timestampLabel: 'Yesterday, 4:45 PM',
          badgeLabel: 'Read',
          badgeColor: AppColors.textTertiary,
          badgeFilled: false,
          accentColor: AppColors.textTertiary,
          icon: LucideIcons.calendarX,
          isRead: true,
        ),
      ],
    ),
    NotificationSection(
      title: 'Referral Updates',
      icon: LucideIcons.share2,
      color: referralGreen,
      items: [
        NotificationItem(
          id: 'notif-referral-accepted',
          title: 'Referral Accepted',
          subtitleLine: 'Marie Uwase → Dr. E. Nkurunziza',
          description:
              'Nephrology referral accepted. Appointment confirmed for '
              'Jun 15, 09:30 AM at CHC Kigali, Room 204.',
          timestampLabel: '5 hr ago',
          badgeLabel: 'Accepted',
          badgeColor: referralGreen,
          accentColor: referralGreen,
          icon: LucideIcons.share2,
          actionLabel: 'View Referral',
          actionIcon: LucideIcons.share2,
        ),
        NotificationItem(
          id: 'notif-referral-pending',
          title: 'Referral Pending',
          subtitleLine: 'Jean Habimana → Cardiology',
          description:
              'Cardiology referral pending response for 48 hrs. Consider '
              "following up with Dr. Mugisha's office directly.",
          timestampLabel: 'Yesterday',
          badgeLabel: 'Awaiting',
          badgeColor: AppColors.warning,
          accentColor: AppColors.warning,
          icon: LucideIcons.history,
          actionLabel: 'Follow Up',
          actionIcon: LucideIcons.phone,
        ),
      ],
    ),
    NotificationSection(
      title: 'Lab & AI Updates',
      icon: LucideIcons.flaskConical,
      color: labPurple,
      items: [
        NotificationItem(
          id: 'notif-ai-clinical-insight',
          title: 'AI Clinical Insight',
          subtitleLine: '3 patients · Pattern detected',
          description:
              'AI detected rising HbA1c trends across 3 diabetic patients. '
              'Early intervention recommended before next scheduled visits.',
          timestampLabel: 'Today, 06:00 AM',
          badgeLabel: 'AI',
          badgeColor: labPurple,
          accentColor: labPurple,
          icon: LucideIcons.brain,
          actionLabel: 'View Insight',
          actionIcon: LucideIcons.refreshCw,
        ),
      ],
    ),
  ];
}
