import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';

/// A small pill button used for inline card actions (a reminder's "Mark
/// Taken" / "Snooze", an appointment's "Confirm" / "Reschedule") — too
/// compact for [PrimaryButton]'s full-width footprint.
class CompactActionButton extends StatelessWidget {
  final String label;
  final IconData? icon;
  final VoidCallback? onPressed;
  final Color color;

  /// Filled (primary) vs. outlined-grey (secondary) treatment.
  final bool filled;

  const CompactActionButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.color = AppColors.primary,
    this.filled = true,
  });

  @override
  Widget build(BuildContext context) {
    final foreground = filled ? Colors.white : AppColors.textSecondary;

    return Expanded(
      child: Material(
        color: filled ? color : Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.md),
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(AppRadius.md),
          child: Container(
            height: 34,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppRadius.md),
              border: filled ? null : Border.all(color: AppColors.border),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (icon != null) ...[
                  Icon(icon, size: 14, color: foreground),
                  const SizedBox(width: 5),
                ],
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w700,
                    color: foreground,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
