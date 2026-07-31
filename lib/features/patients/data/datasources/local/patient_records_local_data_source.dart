import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../domain/models/patient_tag.dart';
import '../../../domain/models/records_patient_profile.dart';
import '../../../domain/models/visit_summary.dart';

/// Seed values for the Medical Records screen, written into Firestore on
/// first read. Icon/colour/chips are cosmetic constants keyed by tag label
/// or visit id — [PatientRecordsRemoteDataSource] pairs them with the live
/// title/date/status/description fields.
abstract interface class PatientRecordsLocalDataSource {
  RecordsPatientProfile readProfile();

  List<VisitSummary> readVisitSummaries();

  int readTotalVisitCount();
}

@LazySingleton(as: PatientRecordsLocalDataSource)
class PatientRecordsLocalDataSourceImpl
    implements PatientRecordsLocalDataSource {
  static const Color _labPurple = Color(0xFF8B5CF6);
  static const Color _mildOrange = Color(0xFFFB923C);

  @override
  RecordsPatientProfile readProfile() => const RecordsPatientProfile(
    fullName: 'Marie Uwase',
    displayId: 'RW-2847',
    dobLabel: '14 Mar 1985',
    verified: true,
    tags: [
      PatientTag(icon: LucideIcons.droplet, label: 'B+'),
      PatientTag(icon: LucideIcons.shieldAlert, label: 'Penicillin'),
      PatientTag(icon: LucideIcons.heartPulse, label: 'HTN · T2DM'),
    ],
  );

  @override
  int readTotalVisitCount() => 8;

  @override
  List<VisitSummary> readVisitSummaries() => const [
    VisitSummary(
      id: 'visit-bp-followup',
      title: 'BP Follow-Up',
      dateLabel: 'May 28, 2025 · 10:15 AM',
      statusLabel: 'Reviewed',
      statusColor: AppColors.success,
      icon: LucideIcons.stethoscope,
      iconColor: AppColors.secondary,
      doctorLine: 'Dr. Amina Mukamana · CHC Kigali',
      description:
          'BP readings improved to 138/88 mmHg. Medication adjusted — '
          'Amlodipine increased to 5mg. Advised low-sodium diet and daily '
          'walking. Next review in 2 weeks.',
      chips: [
        VisitChip(
          icon: LucideIcons.pill,
          label: '2 Rx Updated',
          color: AppColors.secondary,
        ),
        VisitChip(
          icon: LucideIcons.flaskConical,
          label: 'Lab Ordered',
          color: _labPurple,
        ),
      ],
    ),
    VisitSummary(
      id: 'visit-diabetes-review',
      title: 'Diabetes Review',
      dateLabel: 'May 10, 2025 · 09:00 AM',
      statusLabel: 'Monitor',
      statusColor: AppColors.warning,
      icon: LucideIcons.stethoscope,
      iconColor: AppColors.warning,
      doctorLine: 'Dr. Jean Habimana · CHC Kigali',
      description:
          'HbA1c at 7.2% — slightly above target. Metformin dose '
          'maintained. Encouraged regular glucose monitoring and dietary '
          'adjustments.',
      chips: [
        VisitChip(
          icon: LucideIcons.pill,
          label: '1 Rx Renewed',
          color: AppColors.warning,
        ),
      ],
    ),
    VisitSummary(
      id: 'visit-general-consultation',
      title: 'General Consultation',
      dateLabel: 'Apr 22, 2025 · 11:30 AM',
      statusLabel: 'Stable',
      statusColor: AppColors.success,
      icon: LucideIcons.stethoscope,
      iconColor: _mildOrange,
      doctorLine: 'Dr. Amina Mukamana · CHC Kigali',
      description:
          'Routine wellness check. Weight stable at 67kg. No new '
          'complaints. Annual lab panel ordered for June 2025.',
    ),
  ];
}
