import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/patient_intake_draft.dart';
import 'intake_inputs.dart';

/// Step 3 — Registration Summary: a read-only recap of the draft pulled
/// straight off the fields already entered, so the CHW can eyeball it once
/// before submitting.
class RegistrationSummarySection extends StatelessWidget {
  final PatientIntakeDraft draft;

  const RegistrationSummarySection({super.key, required this.draft});

  String get _genderAge {
    final gender = switch (draft.gender) {
      Gender.female => 'Female',
      Gender.male => 'Male',
      null => '—',
    };
    final age = draft.age;
    return age == null ? gender : '$gender · $age years';
  }

  String get _location {
    final parts = [
      draft.sector,
      draft.district,
    ].where((p) => p.trim().isNotEmpty);
    return parts.isEmpty ? '—' : parts.join(', ');
  }

  String get _insurance => switch (draft.insurance) {
    InsuranceType.mutuelle => 'Mutuelle',
    InsuranceType.private_ => 'Private',
    InsuranceType.rssb => 'RSSB',
    InsuranceType.none => 'None',
    null => '—',
  };

  String get _symptoms {
    final symptoms = draft.reportedSymptoms.where((s) => s != 'None');
    return symptoms.isEmpty ? 'None reported' : symptoms.join(', ');
  }

  @override
  Widget build(BuildContext context) {
    final risk = PatientRiskCalculator.calculate(draft);
    final riskColor = switch (risk.level) {
      RiskLevel.low => AppColors.riskLow,
      RiskLevel.moderate => AppColors.riskMedium,
      RiskLevel.high => AppColors.riskHigh,
      RiskLevel.critical => AppColors.riskCritical,
    };
    final flagCount = draft.emergencyFlags.length;

    return IntakeSectionCard(
      icon: LucideIcons.clipboardCheck,
      title: 'Registration Summary',
      tint: AppColors.primary.withValues(alpha: 0.12),
      iconColor: AppColors.primary,
      children: [
        IntakeSummaryRow(
          label: 'Full Name',
          value: draft.fullName.isEmpty ? '—' : draft.fullName,
        ),
        IntakeSummaryRow(label: 'Gender / Age', value: _genderAge),
        IntakeSummaryRow(label: 'Location', value: _location),
        IntakeSummaryRow(
          label: 'Phone',
          value: draft.primaryPhone.isEmpty ? '—' : '+250 ${draft.primaryPhone}',
        ),
        IntakeSummaryRow(label: 'Insurance', value: _insurance),
        IntakeSummaryRow(label: 'Symptoms', value: _symptoms),
        IntakeSummaryRow(
          label: 'Risk Level',
          value: '${risk.level.name[0].toUpperCase()}${risk.level.name.substring(1)} (${risk.score})',
          valueColor: riskColor,
        ),
        IntakeSummaryRow(
          label: 'Emergency Flag',
          value: flagCount == 0 ? 'None' : 'Active ($flagCount)',
          valueColor: flagCount == 0 ? null : AppColors.danger,
        ),
      ],
    );
  }
}
