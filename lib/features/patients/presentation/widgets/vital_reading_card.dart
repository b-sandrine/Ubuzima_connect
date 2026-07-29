import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../shared/widgets/pills/status_pill.dart';
import '../../domain/models/vital_reading.dart';

/// One tile in the 2×2 Today's Vitals grid — icon, status badge, big value,
/// label and sub-label.
class VitalReadingCard extends StatelessWidget {
  final VitalReading reading;
  final VoidCallback? onTap;

  const VitalReadingCard({super.key, required this.reading, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(AppRadius.lg),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.sm + 4),
          decoration: BoxDecoration(
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
                children: [
                  Container(
                    width: 34,
                    height: 34,
                    decoration: BoxDecoration(
                      color: reading.iconColor.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(AppRadius.md + 2),
                    ),
                    child: Icon(
                      reading.icon,
                      size: 17,
                      color: reading.iconColor,
                    ),
                  ),
                  const Spacer(),
                  StatusPill(
                    label: reading.badgeLabel,
                    color: reading.badgeColor,
                    fontSize: 10.5,
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                reading.value,
                style: const TextStyle(
                  fontSize: 21,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                reading.label,
                style: const TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 1),
              Text(
                reading.subLabel,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 11,
                  color: AppColors.textTertiary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
