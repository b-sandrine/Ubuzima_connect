import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/pills/status_pill.dart';
import '../../domain/entities/medication_dose.dart';

/// One row on the Today schedule. The whole card tints to the dose's status
/// and the trailing control changes shape: a filled tick when taken, a
/// "Take" button when due, a time badge when still pending.
class DoseCard extends StatelessWidget {
  final MedicationDose dose;
  final VoidCallback onTake;

  const DoseCard({super.key, required this.dose, required this.onTake});

  @override
  Widget build(BuildContext context) {
    final accent = _statusAccent(dose.status);

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: accent.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: accent.withValues(alpha: 0.22)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: accent.withValues(alpha: 0.16),
              borderRadius: BorderRadius.circular(13),
            ),
            child: Icon(Icons.medication, color: accent, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  dose.name,
                  style: const TextStyle(
                    fontSize: 15.5,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  '${dose.dosage} · ${dose.amount} · ${dose.instruction}',
                  style: const TextStyle(
                    fontSize: 12.5,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: [
                    for (final tag in dose.tags)
                      StatusPill(
                        label: tag.label,
                        color: _tagColor(tag),
                        icon: _tagIcon(tag),
                        fontSize: 10.5,
                      ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          _Trailing(dose: dose, accent: accent, onTake: onTake),
        ],
      ),
    );
  }

  Color _statusAccent(DoseStatus status) => switch (status) {
    DoseStatus.taken => AppColors.primary,
    DoseStatus.dueSoon => AppColors.secondary,
    DoseStatus.pending => const Color(0xFF7C3AED),
  };

  Color _tagColor(DoseTag tag) {
    if (tag.kind == DoseTagKind.instruction) {
      return tag.label.toLowerCase().contains('evening')
          ? const Color(0xFF7C3AED)
          : AppColors.textSecondary;
    }
    return switch (tag.label.toLowerCase()) {
      'hypertension' => const Color(0xFFE11D48),
      'diabetes' => AppColors.warning,
      _ => AppColors.secondary,
    };
  }

  IconData? _tagIcon(DoseTag tag) {
    if (tag.kind == DoseTagKind.condition) return Icons.favorite;
    final label = tag.label.toLowerCase();
    if (label.contains('water')) return Icons.water_drop;
    if (label.contains('food') || label.contains('meal')) {
      return Icons.restaurant;
    }
    if (label.contains('evening')) return Icons.nightlight_round;
    return null;
  }
}

class _Trailing extends StatelessWidget {
  final MedicationDose dose;
  final Color accent;
  final VoidCallback onTake;

  const _Trailing({
    required this.dose,
    required this.accent,
    required this.onTake,
  });

  @override
  Widget build(BuildContext context) {
    switch (dose.status) {
      case DoseStatus.taken:
        return const CircleAvatar(
          radius: 15,
          backgroundColor: AppColors.primary,
          child: Icon(Icons.check, size: 18, color: Colors.white),
        );
      case DoseStatus.dueSoon:
        return Material(
          color: accent.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(12),
          child: InkWell(
            onTap: onTake,
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: accent.withValues(alpha: 0.4)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.check, size: 15, color: accent),
                  const SizedBox(width: 5),
                  Text(
                    'Take',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: accent,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      case DoseStatus.pending:
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 7),
          decoration: BoxDecoration(
            color: AppColors.border.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(999),
          ),
          child: Text(
            dose.timeLabel,
            style: const TextStyle(
              fontSize: 11.5,
              fontWeight: FontWeight.w700,
              color: AppColors.textSecondary,
            ),
          ),
        );
    }
  }
}
