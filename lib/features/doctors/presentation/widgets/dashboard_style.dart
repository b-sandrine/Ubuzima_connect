import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../domain/models/emergency_alert.dart';
import '../../domain/models/queue_patient.dart';
import '../../domain/models/referral.dart';
import '../../domain/models/schedule_item.dart';

/// Colour and label lookups shared by the dashboard's status pills, so every
/// card maps the same enum to the same colour instead of each widget
/// re-declaring its own switch statement.
abstract final class DashboardStyle {
  static Color alertSeverityColor(AlertSeverity severity) {
    return switch (severity) {
      AlertSeverity.critical => AppColors.danger,
      AlertSeverity.urgent => AppColors.warning,
    };
  }

  static String alertSeverityLabel(AlertSeverity severity) {
    return switch (severity) {
      AlertSeverity.critical => 'Critical',
      AlertSeverity.urgent => 'Urgent',
    };
  }

  static Color queuePriorityColor(QueuePriority priority) {
    return switch (priority) {
      QueuePriority.urgent => AppColors.danger,
      QueuePriority.moderate => AppColors.warning,
      QueuePriority.routine => AppColors.textTertiary,
    };
  }

  static String queuePriorityLabel(QueuePriority priority) {
    return switch (priority) {
      QueuePriority.urgent => 'Urgent',
      QueuePriority.moderate => 'Moderate',
      QueuePriority.routine => 'Routine',
    };
  }

  static Color referralStatusColor(ReferralStatus status) {
    return switch (status) {
      ReferralStatus.pending => AppColors.warning,
      ReferralStatus.approved => AppColors.success,
    };
  }

  static String referralStatusLabel(ReferralStatus status) {
    return switch (status) {
      ReferralStatus.pending => 'Pending',
      ReferralStatus.approved => 'Approved',
    };
  }

  static Color? scheduleStatusColor(ScheduleStatus status) {
    return switch (status) {
      ScheduleStatus.now => AppColors.success,
      ScheduleStatus.next => AppColors.secondary,
      ScheduleStatus.none => null,
    };
  }

  static String? scheduleStatusLabel(ScheduleStatus status) {
    return switch (status) {
      ScheduleStatus.now => 'Now',
      ScheduleStatus.next => 'Next',
      ScheduleStatus.none => null,
    };
  }
}
