import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';

/// Compact tile for a single vital sign / measurement (blood pressure,
/// heart rate, temperature, weight) — used across `medical_records`,
/// `risk_assessment`, and CHW field-collection screens so a reading always
/// renders the same way regardless of which feature captured it.
class VitalSignTile extends StatelessWidget {
  final String label;
  final String value;
  final String unit;
  final IconData icon;
  final bool isAbnormal;

  const VitalSignTile({
    super.key,
    required this.label,
    required this.value,
    required this.unit,
    required this.icon,
    this.isAbnormal = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = isAbnormal ? AppColors.danger : AppColors.primary;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(AppSpacing.sm),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: Theme.of(context).textTheme.labelSmall),
                Text(
                  '$value $unit',
                  style: Theme.of(
                    context,
                  ).textTheme.titleMedium?.copyWith(color: color),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
