import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/accessibility/accessibility_cubit.dart';
import '../../../../core/accessibility/accessibility_settings.dart';
import '../../../../core/theme/app_colors.dart';

/// The "– Aa +" trailing control on the Text Size row — reads and drives
/// [AccessibilityCubit] directly rather than threading callbacks through
/// [SettingsTile], since it's the one row with more than an on/off state.
class TextSizeStepper extends StatelessWidget {
  const TextSizeStepper({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<AccessibilityCubit>();
    final stepIndex = context.select<AccessibilityCubit, int>(
      (c) => c.state.textScaleStepIndex,
    );
    final maxIndex = AccessibilitySettings.textScaleSteps.length - 1;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _StepButton(
          icon: LucideIcons.minus,
          onTap: stepIndex > 0 ? cubit.decreaseTextSize : null,
        ),
        const SizedBox(width: 8),
        const Text(
          'Aa',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(width: 8),
        _StepButton(
          icon: LucideIcons.plus,
          onTap: stepIndex < maxIndex ? cubit.increaseTextSize : null,
        ),
      ],
    );
  }
}

class _StepButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;

  const _StepButton({required this.icon, this.onTap});

  @override
  Widget build(BuildContext context) {
    final enabled = onTap != null;

    return Material(
      color: AppColors.lightBackground,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          width: 28,
          height: 28,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.border),
          ),
          child: Icon(
            icon,
            size: 14,
            color: enabled ? AppColors.textSecondary : AppColors.textTertiary,
          ),
        ),
      ),
    );
  }
}
