import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/pills/status_pill.dart';
import '../../domain/entities/medication_dose.dart';

/// PAT-05. Opened from [DoseCard]'s new `onTap`. Shows everything about one
/// scheduled dose that the compact card can't fit: full instructions, every
/// tag, and the two actions that matter here — marking it taken, or
/// flagging that a refill is needed.
///
/// The refill action dispatches the same schedule-level
/// `MedicationEvent.refillRequested()` PAT-03's banner already uses, rather
/// than inventing a separate per-medication refill entity — the schedule
/// only tracks one active refill reminder today, so "request a refill for
/// this medication" and "request the refill" are the same action for now.
Future<void> showPrescriptionDetailsSheet(
  BuildContext context, {
  required MedicationDose dose,
  required Color tileColor,
  required VoidCallback onTake,
  required VoidCallback onRequestRefill,
}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => _PrescriptionDetailsSheet(
      dose: dose,
      tileColor: tileColor,
      onTake: onTake,
      onRequestRefill: onRequestRefill,
    ),
  );
}

class _PrescriptionDetailsSheet extends StatelessWidget {
  final MedicationDose dose;
  final Color tileColor;
  final VoidCallback onTake;
  final VoidCallback onRequestRefill;

  const _PrescriptionDetailsSheet({
    required this.dose,
    required this.tileColor,
    required this.onTake,
    required this.onRequestRefill,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        margin: const EdgeInsets.fromLTRB(10, 0, 10, 10),
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: const [
            BoxShadow(
              color: Color(0x33000000),
              blurRadius: 30,
              offset: Offset(0, -6),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.border,
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
            ),
            const SizedBox(height: 18),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: tileColor.withValues(alpha: 0.16),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Icon(LucideIcons.pill, color: tileColor, size: 26),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        dose.name,
                        style: const TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        '${dose.dosage} · ${dose.amount}',
                        style: const TextStyle(
                          fontSize: 13.5,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                _StatusBadge(status: dose.status),
              ],
            ),
            const SizedBox(height: 18),
            _DetailRow(
              icon: LucideIcons.clock,
              label: 'Scheduled Time',
              value: dose.timeLabel,
            ),
            const SizedBox(height: 12),
            _DetailRow(
              icon: LucideIcons.notebookText,
              label: 'Instructions',
              value: dose.instruction,
            ),
            if (dose.tags.isNotEmpty) ...[
              const SizedBox(height: 16),
              const Text(
                'TAGS',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1,
                  color: AppColors.textTertiary,
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
                      color: tag.kind == DoseTagKind.condition
                          ? AppColors.warning
                          : AppColors.secondary,
                      fontSize: 11,
                    ),
                ],
              ),
            ],
            const SizedBox(height: 22),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      Navigator.of(context).pop();
                      onRequestRefill();
                    },
                    icon: const Icon(LucideIcons.refreshCw, size: 16),
                    label: const Text('Request Refill'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.secondary,
                      side: const BorderSide(color: AppColors.secondary),
                      padding: const EdgeInsets.symmetric(vertical: 13),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: dose.status == DoseStatus.taken
                        ? null
                        : () {
                            Navigator.of(context).pop();
                            onTake();
                          },
                    icon: const Icon(LucideIcons.check, size: 16),
                    label: Text(
                      dose.status == DoseStatus.taken
                          ? 'Already Taken'
                          : 'Mark as Taken',
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      disabledBackgroundColor: AppColors.border,
                      padding: const EdgeInsets.symmetric(vertical: 13),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final DoseStatus status;

  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    final (label, color) = switch (status) {
      DoseStatus.taken => ('Taken', AppColors.primary),
      DoseStatus.dueSoon => ('Due Soon', AppColors.secondary),
      DoseStatus.pending => ('Pending', AppColors.textSecondary),
    };
    return StatusPill(label: label, color: color, fontSize: 11);
  }
}

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 17, color: AppColors.textTertiary),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textTertiary,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
