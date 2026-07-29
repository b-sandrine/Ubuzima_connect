import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/patient_intake_draft.dart';
import 'intake_inputs.dart';

/// Step 1 — Personal Identity: full name, national ID, date of birth (with
/// the derived age alongside it), gender, and an optional phone number.
class PersonalIdentitySection extends StatelessWidget {
  final PatientIntakeDraft draft;
  final ValueChanged<PatientIntakeDraft> onChanged;

  const PersonalIdentitySection({
    super.key,
    required this.draft,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return IntakeSectionCard(
      icon: LucideIcons.idCard,
      title: 'Personal Identity',
      tint: AppColors.rolePatientTint,
      iconColor: AppColors.rolePatient,
      children: [
        IntakeTextField(
          label: 'Full Name',
          hint: 'e.g. Marie Uwimana',
          value: draft.fullName,
          required: true,
          onChanged: (v) => onChanged(draft.copyWith(fullName: v)),
        ),
        IntakeTextField(
          label: 'National ID / NID (optional)',
          hint: '1 1234 5678 9012 3',
          value: draft.nationalId,
          keyboardType: TextInputType.number,
          suffixIcon: const Icon(
            LucideIcons.scanLine,
            size: 18,
            color: AppColors.primary,
          ),
          onChanged: (v) => onChanged(draft.copyWith(nationalId: v)),
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 3,
              child: IntakeDateField(
                label: 'Date of Birth',
                required: true,
                value: draft.dateOfBirth,
                onChanged: (v) => onChanged(draft.copyWith(dateOfBirth: v)),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              flex: 2,
              child: IntakeReadOnlyField(
                label: 'Age',
                value: draft.age == null ? '—' : '${draft.age}',
              ),
            ),
          ],
        ),
        IntakeSelectCards<Gender>(
          label: 'Gender',
          required: true,
          selected: draft.gender,
          activeColor: AppColors.rolePatient,
          onSelected: (g) => onChanged(draft.copyWith(gender: g)),
          options: const [
            IntakeOption(
              value: Gender.female,
              label: 'Female',
              icon: LucideIcons.venus,
            ),
            IntakeOption(
              value: Gender.male,
              label: 'Male',
              icon: LucideIcons.mars,
            ),
          ],
        ),
        IntakeTextField(
          label: 'Phone Number',
          hint: '078 123 4567',
          value: draft.identityPhone,
          keyboardType: TextInputType.phone,
          prefixText: '+250 ',
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          onChanged: (v) => onChanged(draft.copyWith(identityPhone: v)),
        ),
      ],
    );
  }
}
