import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/health_record.dart';
import 'health_record_style.dart';
import 'section_header.dart';

/// The Conditions & Symptoms card: active symptoms, chronic conditions, and
/// special status, each as a row of tinted chips.
class ConditionsCard extends StatelessWidget {
  final ConditionsSummary conditions;

  const ConditionsCard({super.key, required this.conditions});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          icon: LucideIcons.heart,
          label: 'Conditions & Symptoms',
          tint: AppColors.danger.withValues(alpha: 0.12),
          iconColor: AppColors.danger,
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _GroupLabel('ACTIVE SYMPTOMS'),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final symptom in conditions.activeSymptoms)
                    _Chip(
                      label: symptom.label,
                      icon: HealthRecordStyle.symptomIcon(symptom.label),
                      color: HealthRecordStyle.symptomColor(symptom.tone),
                    ),
                ],
              ),
              const _Separator(),
              const _GroupLabel('CHRONIC CONDITIONS'),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  if (conditions.chronicConditions.isEmpty)
                    const _Chip(
                      label: 'None Reported',
                      icon: LucideIcons.check,
                      color: AppColors.primary,
                    )
                  else
                    for (final condition in conditions.chronicConditions)
                      _Chip(
                        label: condition,
                        icon: LucideIcons.circleAlert,
                        color: AppColors.danger,
                      ),
                ],
              ),
              const _Separator(),
              const _GroupLabel('SPECIAL STATUS'),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final status in conditions.specialStatus)
                    _Chip(
                      label: status,
                      icon: status.toLowerCase().contains('pregnant')
                          ? LucideIcons.baby
                          : LucideIcons.circleCheck,
                      color: status.toLowerCase().contains('pregnant')
                          ? const Color(0xFFEC4899)
                          : AppColors.primary,
                    ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _GroupLabel extends StatelessWidget {
  final String label;

  const _GroupLabel(this.label);

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: const TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.8,
        color: AppColors.textTertiary,
      ),
    );
  }
}

class _Separator extends StatelessWidget {
  const _Separator();

  @override
  Widget build(BuildContext context) => const Padding(
    padding: EdgeInsets.symmetric(vertical: 14),
    child: Divider(height: 1, color: AppColors.border),
  );
}

class _Chip extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;

  const _Chip({required this.label, required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: color.withValues(alpha: 0.25)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 12.5,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
