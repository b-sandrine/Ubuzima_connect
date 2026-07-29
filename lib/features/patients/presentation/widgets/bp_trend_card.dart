import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../shared/widgets/charts/line_trend_chart.dart';
import '../../domain/models/bp_trend_point.dart';

/// The "BP Trend · Last 7 Days" card: a dual-series line chart (solid
/// systolic, dotted diastolic) with a colour legend underneath.
class BpTrendCard extends StatelessWidget {
  final List<BpTrendPoint> points;

  const BpTrendCard({super.key, required this.points});

  @override
  Widget build(BuildContext context) {
    final series = [
      LineTrendSeries(
        label: 'Systolic',
        color: AppColors.danger,
        values: [for (final p in points) p.systolic],
      ),
      LineTrendSeries(
        label: 'Diastolic',
        color: AppColors.warning,
        values: [for (final p in points) p.diastolic],
        dashed: true,
      ),
    ];

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
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
          LineTrendChart(
            xLabels: [for (final p in points) p.dayLabel],
            yTicks: const [80, 100, 120, 140],
            series: series,
          ),
          const SizedBox(height: 14),
          LineTrendLegend(series: series),
        ],
      ),
    );
  }
}
