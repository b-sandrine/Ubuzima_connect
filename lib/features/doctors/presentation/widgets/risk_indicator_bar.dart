import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../domain/models/risk_indicator.dart';

/// One row in the Risk Indicators panel: icon, label, percentage, and a
/// filled progress bar.
class RiskIndicatorBar extends StatelessWidget {
  final RiskIndicator indicator;

  const RiskIndicatorBar({super.key, required this.indicator});

  @override
  Widget build(BuildContext context) {
    final fraction = (indicator.percentage.clamp(0, 100)) / 100;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                color: indicator.color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(indicator.icon, size: 15, color: indicator.color),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                indicator.label,
                style: const TextStyle(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            Text(
              '${indicator.percentage}%',
              style: TextStyle(
                fontSize: 13.5,
                fontWeight: FontWeight.w800,
                color: indicator.color,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(999),
          child: LinearProgressIndicator(
            value: fraction.toDouble(),
            minHeight: 7,
            backgroundColor: AppColors.border,
            valueColor: AlwaysStoppedAnimation(indicator.color),
          ),
        ),
      ],
    );
  }
}
