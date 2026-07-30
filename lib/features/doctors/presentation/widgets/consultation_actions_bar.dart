import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/theme/app_colors.dart';

/// The "Ready to save consultation" readiness banner, the Save Draft /
/// Complete & Save buttons, and the Refer / Order Lab / Follow-Up quick
/// actions beneath them.
class ConsultationActionsBar extends StatelessWidget {
  final int filledCount;
  final int totalCount;
  final bool isComplete;
  final bool isSaving;
  final VoidCallback onSaveDraft;
  final VoidCallback? onCompleteAndSave;
  final VoidCallback onRefer;
  final VoidCallback onOrderLab;
  final VoidCallback onFollowUp;

  const ConsultationActionsBar({
    super.key,
    required this.filledCount,
    required this.totalCount,
    required this.isComplete,
    required this.isSaving,
    required this.onSaveDraft,
    required this.onCompleteAndSave,
    required this.onRefer,
    required this.onOrderLab,
    required this.onFollowUp,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                isComplete ? LucideIcons.circleCheck : LucideIcons.circleDashed,
                size: 16,
                color: isComplete ? AppColors.success : AppColors.textTertiary,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  isComplete
                      ? 'Ready to save consultation'
                      : 'Recording vitals',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: isComplete
                        ? AppColors.textPrimary
                        : AppColors.textSecondary,
                  ),
                ),
              ),
              Text(
                isComplete ? 'All fields filled' : '$filledCount of $totalCount',
                style: const TextStyle(fontSize: 11.5, color: AppColors.textTertiary),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                flex: 2,
                child: OutlinedButton.icon(
                  onPressed: isSaving ? null : onSaveDraft,
                  icon: const Icon(LucideIcons.save, size: 16),
                  label: const Text('Save Draft'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.textSecondary,
                    side: const BorderSide(color: AppColors.border),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                flex: 3,
                child: ElevatedButton.icon(
                  onPressed: isSaving ? null : onCompleteAndSave,
                  icon: isSaving
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation(Colors.white),
                          ),
                        )
                      : const Icon(LucideIcons.check, size: 16),
                  label: const Text('Complete & Save'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    disabledBackgroundColor: const Color(0xFFCBD5E1),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: _QuickAction(
                  icon: LucideIcons.share2,
                  label: 'Refer',
                  color: AppColors.warning,
                  onTap: onRefer,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _QuickAction(
                  icon: LucideIcons.flaskConical,
                  label: 'Order Lab',
                  color: AppColors.primary,
                  onTap: onOrderLab,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _QuickAction(
                  icon: LucideIcons.calendarClock,
                  label: 'Follow-Up',
                  color: AppColors.secondary,
                  onTap: onFollowUp,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _QuickAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _QuickAction({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color.withValues(alpha: 0.1),
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 11),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 16, color: color),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
