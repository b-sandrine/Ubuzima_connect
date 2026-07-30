import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../domain/models/vital_sign.dart';
import 'dashboard_style.dart';

/// One tile in the Latest Vitals grid: icon + optional status pill, the
/// big value, the label, and an optional trend row.
///
/// Distinct from the app-wide `VitalSignTile` (used elsewhere for compact,
/// colour-block readings) — this screen's design calls for a taller white
/// card with a status pill and trend line.
class VitalSignCard extends StatelessWidget {
  final VitalSign vital;

  const VitalSignCard({super.key, required this.vital});

  @override
  Widget build(BuildContext context) {
    final status = vital.status;
    final statusColor = status != null
        ? DashboardStyle.vitalStatusColor(status)
        : AppColors.primary;

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
            children: [
              Icon(vital.icon, size: 18, color: statusColor),
              const Spacer(),
              if (status != null)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 9,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(AppRadius.full),
                  ),
                  child: Text(
                    DashboardStyle.vitalStatusLabel(status),
                    style: TextStyle(
                      fontSize: 10.5,
                      fontWeight: FontWeight.w700,
                      color: statusColor,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 10),
          Text.rich(
            TextSpan(
              text: vital.value,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
              ),
              children: [
                if (vital.unit.isNotEmpty)
                  TextSpan(
                    text: ' ${vital.unit}',
                    style: const TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textSecondary,
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 2),
          Text(
            vital.label,
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
          ),
          if (vital.trend != null && vital.trendText != null) ...[
            const SizedBox(height: 4),
            Text(
              '${_arrow(vital.trend!)} ${vital.trendText}',
              style: TextStyle(
                fontSize: 11.5,
                fontWeight: FontWeight.w600,
                color: statusColor,
              ),
            ),
          ],
        ],
      ),
    );
  }

  String _arrow(VitalTrendDirection direction) {
    return switch (direction) {
      VitalTrendDirection.up => '↑',
      VitalTrendDirection.down => '↓',
      VitalTrendDirection.stable => '→',
    };
  }
}
