import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../shared/widgets/buttons/compact_action_button.dart';
import '../../../../shared/widgets/pills/status_pill.dart';
import '../../domain/models/medication_reminder.dart';

/// One row in Medication Reminders — renders differently per
/// [MedicationReminder.status]: due-now shows Mark Taken / Snooze actions,
/// taken shows the adherence streak, upcoming is informational only.
class MedicationReminderCard extends StatelessWidget {
  final MedicationReminder reminder;
  final VoidCallback? onMarkTaken;
  final VoidCallback? onSnooze;

  const MedicationReminderCard({
    super.key,
    required this.reminder,
    this.onMarkTaken,
    this.onSnooze,
  });

  bool get _isTaken => reminder.status == MedicationStatus.taken;
  bool get _isDueNow => reminder.status == MedicationStatus.dueNow;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.sm + 4),
      decoration: BoxDecoration(
        color: _isTaken
            ? AppColors.success.withValues(alpha: 0.07)
            : Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(
          color: _isTaken
              ? AppColors.success.withValues(alpha: 0.2)
              : AppColors.border,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: reminder.iconColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(AppRadius.md + 2),
                ),
                child: Icon(reminder.icon, size: 19, color: reminder.iconColor),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      reminder.name,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 14.5,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      reminder.detailLine,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 12.5,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    if (reminder.streakDays != null) ...[
                      const SizedBox(height: 4),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            LucideIcons.check,
                            size: 13,
                            color: AppColors.success,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Streak: ${reminder.streakDays} days in a row',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: AppColors.success,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  StatusPill(
                    label: reminder.pillLabel,
                    color: reminder.pillColor,
                    fontSize: 10.5,
                  ),
                  if (reminder.pillCaption != null) ...[
                    const SizedBox(height: 3),
                    Text(
                      reminder.pillCaption!,
                      style: const TextStyle(
                        fontSize: 10.5,
                        color: AppColors.textTertiary,
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
          if (_isDueNow) ...[
            const SizedBox(height: 10),
            Row(
              children: [
                CompactActionButton(
                  label: 'Mark Taken',
                  icon: LucideIcons.check,
                  color: AppColors.success,
                  onPressed: onMarkTaken,
                ),
                const SizedBox(width: AppSpacing.sm),
                CompactActionButton(
                  label: 'Snooze',
                  filled: false,
                  onPressed: onSnooze,
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
