import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/patient_intake_draft.dart';
import 'intake_inputs.dart';

/// Step 2 — Contact Information: primary/alternate phone and an optional
/// emergency contact.
class ContactInformationSection extends StatelessWidget {
  final PatientIntakeDraft draft;
  final ValueChanged<PatientIntakeDraft> onChanged;

  const ContactInformationSection({
    super.key,
    required this.draft,
    required this.onChanged,
  });

  static const List<String> _relationships = [
    'Spouse',
    'Parent',
    'Child',
    'Sibling',
    'Relative',
    'Friend',
    'Neighbor',
    'Other',
  ];

  @override
  Widget build(BuildContext context) {
    final digitsOnly = [FilteringTextInputFormatter.digitsOnly];

    return IntakeSectionCard(
      icon: LucideIcons.phone,
      title: 'Contact Information',
      tint: AppColors.primary.withValues(alpha: 0.12),
      iconColor: AppColors.primary,
      children: [
        IntakeTextField(
          label: 'Primary Phone',
          hint: '078 123 4567',
          value: draft.primaryPhone,
          required: true,
          keyboardType: TextInputType.phone,
          prefixText: '+250 ',
          inputFormatters: digitsOnly,
          onChanged: (v) => onChanged(draft.copyWith(primaryPhone: v)),
        ),
        IntakeTextField(
          label: 'Alternate Phone (optional)',
          hint: '072 987 6543',
          value: draft.alternatePhone,
          keyboardType: TextInputType.phone,
          prefixText: '+250 ',
          inputFormatters: digitsOnly,
          onChanged: (v) => onChanged(draft.copyWith(alternatePhone: v)),
        ),
        IntakeTextField(
          label: 'Emergency Contact Name',
          hint: 'e.g. Jean Habimana',
          value: draft.emergencyContactName,
          onChanged: (v) =>
              onChanged(draft.copyWith(emergencyContactName: v)),
        ),
        IntakeDropdownField(
          label: 'Relationship',
          hint: 'Select relationship...',
          value: draft.relationship.isEmpty ? null : draft.relationship,
          items: _relationships,
          onChanged: (v) => onChanged(draft.copyWith(relationship: v ?? '')),
        ),
        IntakeTextField(
          label: 'Emergency Contact Phone',
          hint: '073 456 7890',
          value: draft.emergencyContactPhone,
          keyboardType: TextInputType.phone,
          prefixText: '+250 ',
          inputFormatters: digitsOnly,
          onChanged: (v) =>
              onChanged(draft.copyWith(emergencyContactPhone: v)),
        ),
      ],
    );
  }
}
