import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/patient_intake_draft.dart';
import 'intake_inputs.dart';

/// Step 3 — Risk Screening: chronic conditions, pregnancy status, COVID-19
/// vaccination, and the auto-analyzed AI Risk Assessment beneath them.
class RiskScreeningSection extends StatelessWidget {
  final PatientIntakeDraft draft;
  final ValueChanged<PatientIntakeDraft> onChanged;

  const RiskScreeningSection({
    super.key,
    required this.draft,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final risk = PatientRiskCalculator.calculate(draft);

    return IntakeSectionCard(
      icon: LucideIcons.shield,
      title: 'Risk Screening',
      tint: AppColors.secondary.withValues(alpha: 0.12),
      iconColor: AppColors.secondary,
      children: [
        IntakeToggleChips(
          label: 'Chronic Conditions',
          options: ChronicConditionCatalogue.all,
          selected: draft.chronicConditions,
          onChanged: (v) => onChanged(draft.copyWith(chronicConditions: v)),
        ),
        if (draft.gender != Gender.male)
          IntakeSelectCards<PregnancyStatus>(
            label: 'Pregnancy Status',
            selected: draft.pregnancyStatus,
            activeColor: const Color(0xFFEC4899),
            onSelected: (v) => onChanged(draft.copyWith(pregnancyStatus: v)),
            options: const [
              IntakeOption(
                value: PregnancyStatus.notPregnant,
                label: 'Not Pregnant',
                icon: LucideIcons.minus,
              ),
              IntakeOption(
                value: PregnancyStatus.pregnant,
                label: 'Pregnant',
                icon: LucideIcons.baby,
              ),
              IntakeOption(
                value: PregnancyStatus.unknown,
                label: 'Unknown',
                icon: LucideIcons.circleHelp,
              ),
            ],
          ),
        IntakeSelectCards<VaccinationStatus>(
          label: 'COVID-19 Vaccination',
          selected: draft.vaccinationStatus,
          onSelected: (v) => onChanged(draft.copyWith(vaccinationStatus: v)),
          options: const [
            IntakeOption(
              value: VaccinationStatus.fully,
              label: 'Fully',
              icon: LucideIcons.circleCheck,
            ),
            IntakeOption(
              value: VaccinationStatus.partial,
              label: 'Partial',
              icon: LucideIcons.shieldAlert,
            ),
            IntakeOption(
              value: VaccinationStatus.none,
              label: 'None',
              icon: LucideIcons.circleHelp,
            ),
          ],
        ),
        _AiRiskCard(risk: risk),
      ],
    );
  }
}

class _AiRiskCard extends StatelessWidget {
  final RiskAssessment risk;

  const _AiRiskCard({required this.risk});

  Color get _color => switch (risk.level) {
    RiskLevel.low => AppColors.riskLow,
    RiskLevel.moderate => AppColors.riskMedium,
    RiskLevel.high => AppColors.riskHigh,
    RiskLevel.critical => AppColors.riskCritical,
  };

  String get _label => switch (risk.level) {
    RiskLevel.low => 'Low Risk',
    RiskLevel.moderate => 'Moderate Risk',
    RiskLevel.high => 'High Risk',
    RiskLevel.critical => 'Critical Risk',
  };

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFF5F3FF), Color(0xFFEFF6FF)],
        ),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE9D5FF)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                LucideIcons.brain,
                size: 15,
                color: Color(0xFF7C3AED),
              ),
              const SizedBox(width: 6),
              const Expanded(
                child: Text(
                  'AI Risk Assessment',
                  style: TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 3,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF7C3AED).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: const Text(
                  'Auto-analyzed',
                  style: TextStyle(
                    fontSize: 9.5,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF7C3AED),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Icon(LucideIcons.triangleAlert, size: 15, color: _color),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        _label,
                        style: TextStyle(
                          fontSize: 13.5,
                          fontWeight: FontWeight.w800,
                          color: _color,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 44,
                height: 44,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: _color.withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: _color.withValues(alpha: 0.35),
                    width: 1.4,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '${risk.score}',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: _color,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 4),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  SizedBox(height: 4),
                  Text(
                    'Risk\nScore',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 9, color: AppColors.textTertiary),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            risk.summary,
            style: const TextStyle(
              fontSize: 12,
              height: 1.45,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
