import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/patient_intake_draft.dart';
import 'intake_inputs.dart';

/// Human-readable labels for [SymptomDuration], used by the dropdown and
/// reversed when the user picks one.
abstract final class SymptomDurationLabels {
  static const Map<SymptomDuration, String> labels = {
    SymptomDuration.underOneDay: 'Under 24 hours',
    SymptomDuration.oneToThreeDays: '1–3 days',
    SymptomDuration.fourToSevenDays: '4–7 days',
    SymptomDuration.overOneWeek: 'More than a week',
  };

  static List<String> get options => labels.values.toList(growable: false);

  static SymptomDuration? fromLabel(String? label) {
    for (final entry in labels.entries) {
      if (entry.value == label) return entry.key;
    }
    return null;
  }
}

/// Step 3 — Current Symptoms: how long they've lasted, which ones, and any
/// free-text notes.
class SymptomsSection extends StatelessWidget {
  final PatientIntakeDraft draft;
  final ValueChanged<PatientIntakeDraft> onChanged;

  const SymptomsSection({
    super.key,
    required this.draft,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return IntakeSectionCard(
      icon: LucideIcons.thermometer,
      title: 'Current Symptoms',
      tint: AppColors.warning.withValues(alpha: 0.14),
      iconColor: AppColors.warning,
      trailing: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: AppColors.warning.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(999),
        ),
        child: const Text(
          'Select all that apply',
          style: TextStyle(
            fontSize: 10.5,
            fontWeight: FontWeight.w700,
            color: AppColors.warning,
          ),
        ),
      ),
      children: [
        IntakeDropdownField(
          label: 'Symptom Duration',
          hint: 'How long have symptoms lasted?',
          required: true,
          value: draft.symptomDuration == null
              ? null
              : SymptomDurationLabels.labels[draft.symptomDuration],
          items: SymptomDurationLabels.options,
          onChanged: (v) => onChanged(
            draft.copyWith(
              symptomDuration: SymptomDurationLabels.fromLabel(v),
            ),
          ),
        ),
        IntakeToggleChips(
          label: 'Reported Symptoms',
          options: SymptomCatalogue.all,
          selected: draft.reportedSymptoms,
          onChanged: (v) => onChanged(draft.copyWith(reportedSymptoms: v)),
        ),
        IntakeTextField(
          label: 'Additional Notes (optional)',
          hint: 'Describe any other symptoms or observations...',
          value: draft.additionalNotes,
          maxLines: 3,
          onChanged: (v) => onChanged(draft.copyWith(additionalNotes: v)),
        ),
      ],
    );
  }
}
