import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/patient_intake_draft.dart';
import 'intake_inputs.dart';

/// Step 2 — Demographics: marital status, education, occupation, and the
/// health-insurance scheme.
class DemographicsSection extends StatelessWidget {
  final PatientIntakeDraft draft;
  final ValueChanged<PatientIntakeDraft> onChanged;

  const DemographicsSection({
    super.key,
    required this.draft,
    required this.onChanged,
  });

  static const List<String> _educationLevels = [
    'None',
    'Primary',
    'Secondary',
    'Vocational / TVET',
    'University',
    'Postgraduate',
  ];

  @override
  Widget build(BuildContext context) {
    return IntakeSectionCard(
      icon: LucideIcons.users,
      title: 'Demographics',
      tint: AppColors.secondary.withValues(alpha: 0.12),
      iconColor: AppColors.secondary,
      children: [
        IntakeSelectCards<MaritalStatus>(
          label: 'Marital Status',
          selected: draft.maritalStatus,
          activeColor: const Color(0xFFEC4899),
          onSelected: (v) => onChanged(draft.copyWith(maritalStatus: v)),
          options: const [
            IntakeOption(
              value: MaritalStatus.single,
              label: 'Single',
              icon: LucideIcons.user,
            ),
            IntakeOption(
              value: MaritalStatus.married,
              label: 'Married',
              icon: LucideIcons.heart,
            ),
            IntakeOption(
              value: MaritalStatus.widowed,
              label: 'Widowed',
              icon: LucideIcons.userMinus,
            ),
          ],
        ),
        IntakeDropdownField(
          label: 'Education Level',
          hint: 'Select education level...',
          value: draft.educationLevel.isEmpty ? null : draft.educationLevel,
          items: _educationLevels,
          onChanged: (v) => onChanged(draft.copyWith(educationLevel: v ?? '')),
        ),
        IntakeTextField(
          label: 'Occupation',
          hint: 'e.g. Farmer, Teacher, Trader...',
          value: draft.occupation,
          onChanged: (v) => onChanged(draft.copyWith(occupation: v)),
        ),
        IntakeSelectCards<InsuranceType>(
          label: 'Health Insurance',
          selected: draft.insurance,
          onSelected: (v) => onChanged(draft.copyWith(insurance: v)),
          options: const [
            IntakeOption(
              value: InsuranceType.mutuelle,
              label: 'Mutuelle',
              icon: LucideIcons.shield,
            ),
            IntakeOption(
              value: InsuranceType.private_,
              label: 'Private',
              icon: LucideIcons.landmark,
            ),
            IntakeOption(
              value: InsuranceType.rssb,
              label: 'RSSB',
              icon: LucideIcons.building2,
            ),
            IntakeOption(
              value: InsuranceType.none,
              label: 'None',
              icon: LucideIcons.ban,
            ),
          ],
        ),
        IntakeTextField(
          label: 'Insurance Number (if applicable)',
          hint: 'MUT-XXXXXXXX',
          value: draft.insuranceNumber,
          onChanged: (v) => onChanged(draft.copyWith(insuranceNumber: v)),
        ),
      ],
    );
  }
}
