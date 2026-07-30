import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/branding/ubuzima_wordmark.dart';
import '../../../../shared/widgets/navigation/app_top_bar.dart';
import '../../../../shared/widgets/pills/status_pill.dart';

/// The chrome shared by all three registration steps: the app lockup and
/// notification/avatar row, the back button with the "New Patient" title and
/// the CHW sector pill, and the 3-step progress tracker.
class IntakeHeader extends StatelessWidget {
  static const List<String> stepTitles = [
    'Identity & Household',
    'Demographics & Contact',
    'Confirm & Submit',
  ];

  final int step;
  final String sector;
  final String dateLabel;
  final VoidCallback onBack;

  const IntakeHeader({
    super.key,
    required this.step,
    required this.onBack,
    this.sector = 'CHW · Kigali Sector',
    this.dateLabel = '',
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Expanded(child: UbuzimaWordmark()),
            const CircleIconButton(icon: LucideIcons.bell, showDot: true),
            const SizedBox(width: 8),
            const _ChwAvatar(),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            _BackButton(onTap: onBack),
            const SizedBox(width: 10),
            const Expanded(
              child: Text(
                'New Patient',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            if (dateLabel.isNotEmpty)
              Text(
                dateLabel,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.textTertiary,
                ),
              ),
          ],
        ),
        const SizedBox(height: 10),
        StatusPill(
          label: sector,
          color: AppColors.primary,
          icon: LucideIcons.userRound,
        ),
        const SizedBox(height: 18),
        _StepTracker(step: step),
      ],
    );
  }
}

class _StepTracker extends StatelessWidget {
  final int step;

  const _StepTracker({required this.step});

  @override
  Widget build(BuildContext context) {
    final progress = (step + 1) / 3;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              for (var i = 0; i < 3; i++) ...[
                _StepDot(index: i, currentStep: step),
                if (i != 2)
                  Expanded(
                    child: Container(
                      height: 2,
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      color: i < step ? AppColors.primary : AppColors.border,
                    ),
                  ),
              ],
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              for (var i = 0; i < 3; i++)
                Expanded(
                  child: Text(
                    IntakeHeader.stepTitles[i],
                    textAlign: i == 0
                        ? TextAlign.left
                        : (i == 1 ? TextAlign.center : TextAlign.right),
                    style: TextStyle(
                      fontSize: 10.5,
                      fontWeight: i == step ? FontWeight.w800 : FontWeight.w600,
                      color: i == step
                          ? AppColors.primaryDark
                          : AppColors.textTertiary,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 6,
              backgroundColor: AppColors.border,
              valueColor: const AlwaysStoppedAnimation(AppColors.primary),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${(progress * 100).round()}% complete',
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primaryDark,
                ),
              ),
              Text(
                'Step ${step + 1} of 3',
                style: const TextStyle(
                  fontSize: 11,
                  color: AppColors.textTertiary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StepDot extends StatelessWidget {
  final int index;
  final int currentStep;

  const _StepDot({required this.index, required this.currentStep});

  @override
  Widget build(BuildContext context) {
    final isDone = index < currentStep;
    final isActive = index == currentStep;
    final color = isDone || isActive
        ? AppColors.primary
        : AppColors.textTertiary.withValues(alpha: 0.3);

    return Container(
      width: 28,
      height: 28,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: isDone || isActive ? AppColors.primary : Colors.white,
        shape: BoxShape.circle,
        border: Border.all(color: color, width: 1.6),
      ),
      child: isDone
          ? const Icon(LucideIcons.check, size: 14, color: Colors.white)
          : Text(
              '${index + 1}',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w800,
                color: isActive ? Colors.white : AppColors.textTertiary,
              ),
            ),
    );
  }
}

class _BackButton extends StatelessWidget {
  final VoidCallback onTap;

  const _BackButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.border),
        ),
        child: const Icon(
          LucideIcons.chevronLeft,
          size: 18,
          color: AppColors.textSecondary,
        ),
      ),
    );
  }
}

class _ChwAvatar extends StatelessWidget {
  const _ChwAvatar();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 40,
      height: 40,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          ClipOval(
            child: Image.asset(
              'assets/images/patient_avatar_sample.jpg',
              width: 40,
              height: 40,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                width: 40,
                height: 40,
                color: AppColors.primaryLight,
                child: const Icon(
                  LucideIcons.userRound,
                  size: 20,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          Positioned(
            right: -1,
            bottom: -1,
            child: Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
