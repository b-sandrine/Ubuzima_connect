import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../domain/models/allergy.dart';
import '../../domain/models/emergency_alert.dart';
import '../../domain/models/patient_record.dart';
import '../../domain/models/queue_patient.dart';
import '../../domain/models/referral.dart';
import '../../domain/models/schedule_item.dart';
import '../../domain/models/vital_sign.dart';

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

  static Color patientRecordStatusColor(PatientRecordStatus status) {
    return switch (status) {
      PatientRecordStatus.critical => AppColors.danger,
      PatientRecordStatus.urgent => AppColors.warning,
      PatientRecordStatus.stable => AppColors.success,
      PatientRecordStatus.scheduled => AppColors.secondary,
      PatientRecordStatus.routine => AppColors.textTertiary,
    };
  }

  static String patientRecordStatusLabel(PatientRecordStatus status) {
    return switch (status) {
      PatientRecordStatus.critical => 'Critical',
      PatientRecordStatus.urgent => 'Urgent',
      PatientRecordStatus.stable => 'Stable',
      PatientRecordStatus.scheduled => 'Scheduled',
      PatientRecordStatus.routine => 'Routine',
    };
  }

  static Color vitalStatusColor(VitalStatus status) {
    return switch (status) {
      VitalStatus.high => AppColors.danger,
      VitalStatus.elevated => AppColors.warning,
      VitalStatus.normal => AppColors.success,
    };
  }

  static String vitalStatusLabel(VitalStatus status) {
    return switch (status) {
      VitalStatus.high => 'High',
      VitalStatus.elevated => 'Elevated',
      VitalStatus.normal => 'Normal',
    };
  }

  static Color allergySeverityColor(AllergySeverity severity) {
    return switch (severity) {
      AllergySeverity.severe => AppColors.danger,
      AllergySeverity.moderate => AppColors.warning,
      AllergySeverity.mild => const Color(0xFFFB923C), // orange-400
    };
  }

  static String allergySeverityLabel(AllergySeverity severity) {
    return switch (severity) {
      AllergySeverity.severe => 'Severe',
      AllergySeverity.moderate => 'Moderate',
      AllergySeverity.mild => 'Mild',
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
