import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../domain/models/quick_link.dart';

/// One tile in the dashboard's Quick Actions row — an icon over a label,
/// tinted per action. [QuickLink.selected] renders a tinted card background
/// instead of white, matching the design's Health ID default-selected tile.
class QuickLinkCard extends StatelessWidget {
  final QuickLink link;
  final VoidCallback? onTap;

  const QuickLinkCard({super.key, required this.link, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: link.selected ? link.color.withValues(alpha: 0.1) : Colors.white,
      borderRadius: BorderRadius.circular(AppRadius.lg),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppRadius.lg),
            border: link.selected
                ? Border.all(color: link.color.withValues(alpha: 0.3))
                : null,
            boxShadow: link.selected
                ? null
                : const [
                    BoxShadow(
                      color: Color(0x0A0F172A),
                      blurRadius: 12,
                      offset: Offset(0, 4),
                    ),
                  ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: link.color.withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(AppRadius.md + 2),
                ),
                child: Icon(link.icon, size: 20, color: link.color),
              ),
              const SizedBox(height: 8),
              Text(
                link.label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
