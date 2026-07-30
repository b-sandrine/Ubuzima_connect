import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../shared/widgets/buttons/compact_action_button.dart';
import '../../../../shared/widgets/pills/status_pill.dart';
import '../../domain/models/care_item.dart';

/// One row in Upcoming Care — an appointment (with Confirm / Reschedule
/// actions) or an informational lab order (no actions).
class CareItemCard extends StatelessWidget {
  final CareItem item;
  final VoidCallback? onPrimaryAction;
  final VoidCallback? onSecondaryAction;

  const CareItemCard({
    super.key,
    required this.item,
    this.onPrimaryAction,
    this.onSecondaryAction,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.sm + 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColors.border),
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
                  color: item.iconColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(AppRadius.md + 2),
                ),
                child: Icon(item.icon, size: 19, color: item.iconColor),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 14.5,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      item.subtitle,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 12.5,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 1),
                    Text(
                      item.detail,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 11.5,
                        color: AppColors.textTertiary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              StatusPill(
                label: item.dateLabel,
                color: item.dateColor,
                fontSize: 10.5,
              ),
            ],
          ),
          if (item.primaryActionLabel != null) ...[
            const SizedBox(height: 10),
            Row(
              children: [
                CompactActionButton(
                  label: item.primaryActionLabel!,
                  icon: item.primaryActionIcon,
                  color: item.iconColor,
                  onPressed: onPrimaryAction,
                ),
                if (item.secondaryActionLabel != null) ...[
                  const SizedBox(width: AppSpacing.sm),
                  CompactActionButton(
                    label: item.secondaryActionLabel!,
                    filled: false,
                    onPressed: onSecondaryAction,
                  ),
                ],
              ],
            ),
          ],
        ],
      ),
    );
  }
}
