import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/health_record.dart';
import 'health_record_style.dart';
import 'section_header.dart';

/// The Next Steps list: the CHW's outstanding actions for this patient, each
/// a tile with a kind icon, a title/detail, and a due-or-status badge.
class NextStepsSection extends StatelessWidget {
  final List<NextStep> steps;
  final ValueChanged<String> onComplete;

  const NextStepsSection({
    super.key,
    required this.steps,
    required this.onComplete,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          icon: LucideIcons.listChecks,
          label: 'Next Steps',
          tint: AppColors.primary.withValues(alpha: 0.12),
          iconColor: AppColors.primary,
          trailing: _PendingBadge(count: steps.length),
        ),
        const SizedBox(height: 12),
        for (var i = 0; i < steps.length; i++) ...[
          _StepTile(step: steps[i], onComplete: () => onComplete(steps[i].id)),
          if (i != steps.length - 1) const SizedBox(height: 10),
        ],
      ],
    );
  }
}

class _PendingBadge extends StatelessWidget {
  final int count;

  const _PendingBadge({required this.count});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFEA580C).withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        '$count Pending',
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: Color(0xFFEA580C),
        ),
      ),
    );
  }
}

class _StepTile extends StatelessWidget {
  final NextStep step;
  final VoidCallback onComplete;

  const _StepTile({required this.step, required this.onComplete});

  @override
  Widget build(BuildContext context) {
    final style = HealthRecordStyle.nextStep(step.kind);

    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onComplete,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.border),
          ),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: style.color.withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(style.icon, size: 19, color: style.color),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      step.title,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      step.detail,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              _Badge(label: step.badge, color: style.color),
              const SizedBox(width: 8),
              // Tapping the tile (or this check) completes the step.
              Icon(
                LucideIcons.circleCheck,
                size: 20,
                color: AppColors.primary.withValues(alpha: 0.6),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  final String label;
  final Color color;

  const _Badge({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11.5,
          fontWeight: FontWeight.w700,
          color: color,
        ),
      ),
    );
  }
}
