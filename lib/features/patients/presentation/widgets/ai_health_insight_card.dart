import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../shared/widgets/pills/status_pill.dart';
import '../../domain/models/ai_health_insight.dart';

/// The light lavender "AI Health Insight" card: a generated observation with
/// a link into the full AI Insights screen.
class AiHealthInsightCard extends StatelessWidget {
  final AiHealthInsight insight;
  final VoidCallback? onLearnMore;

  static const _purple = Color(0xFF7C3AED);

  const AiHealthInsightCard({
    super.key,
    required this.insight,
    this.onLearnMore,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: _purple.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: _purple.withValues(alpha: 0.15)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: _purple,
              borderRadius: BorderRadius.circular(AppRadius.md + 2),
            ),
            child: const Icon(LucideIcons.brain, size: 18, color: Colors.white),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        insight.title,
                        style: const TextStyle(
                          fontSize: 14.5,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    StatusPill(
                      label: insight.tagLabel,
                      color: _purple,
                      fontSize: 10.5,
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  insight.message,
                  style: const TextStyle(
                    fontSize: 13,
                    height: 1.45,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        insight.updatedLabel,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 11,
                          color: AppColors.textTertiary,
                        ),
                      ),
                    ),
                    Material(
                      color: _purple.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(AppRadius.full),
                      child: InkWell(
                        onTap: onLearnMore,
                        borderRadius: BorderRadius.circular(AppRadius.full),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 5,
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                LucideIcons.info,
                                size: 12,
                                color: _purple,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                insight.learnMoreLabel,
                                style: const TextStyle(
                                  fontSize: 11.5,
                                  fontWeight: FontWeight.w700,
                                  color: _purple,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
