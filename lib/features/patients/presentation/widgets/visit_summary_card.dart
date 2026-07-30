import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../shared/widgets/pills/status_pill.dart';
import '../../domain/models/visit_summary.dart';

/// One card in the Visit Summaries list: icon, title + date + status, the
/// attending doctor, a description, and a row of quick-fact chips ending in
/// the always-present "Full Report" action.
class VisitSummaryCard extends StatelessWidget {
  final VisitSummary visit;
  final VoidCallback? onFullReport;
  final ValueChanged<VisitChip>? onChipTap;

  const VisitSummaryCard({
    super.key,
    required this.visit,
    this.onFullReport,
    this.onChipTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.sm + 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A0F172A),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: visit.iconColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(AppRadius.md + 2),
                ),
                child: Icon(visit.icon, size: 18, color: visit.iconColor),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  visit.title,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 14.5,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              StatusPill(
                label: visit.statusLabel,
                color: visit.statusColor,
                fontSize: 10.5,
              ),
            ],
          ),
          const SizedBox(height: 2),
          Padding(
            padding: const EdgeInsets.only(left: 48),
            child: Text(
              visit.dateLabel,
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.textTertiary,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.success.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
            child: Row(
              children: [
                const Icon(
                  LucideIcons.userRound,
                  size: 14,
                  color: AppColors.success,
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    visit.doctorLine,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w600,
                      color: AppColors.success,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Text(
            visit.description,
            style: const TextStyle(
              fontSize: 13,
              height: 1.45,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final chip in visit.chips)
                _Chip(
                  icon: chip.icon,
                  label: chip.label,
                  color: chip.color,
                  onTap: () => onChipTap?.call(chip),
                ),
              _Chip(
                icon: LucideIcons.fileText,
                label: 'Full Report',
                color: AppColors.success,
                trailingIcon: LucideIcons.chevronRight,
                onTap: onFullReport,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final IconData? trailingIcon;
  final VoidCallback? onTap;

  const _Chip({
    required this.icon,
    required this.label,
    required this.color,
    this.trailingIcon,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color.withValues(alpha: 0.12),
      borderRadius: BorderRadius.circular(AppRadius.full),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.full),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 12, color: color),
              const SizedBox(width: 5),
              Text(
                label,
                style: TextStyle(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w700,
                  color: color,
                ),
              ),
              if (trailingIcon != null) ...[
                const SizedBox(width: 2),
                Icon(trailingIcon, size: 12, color: color),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
