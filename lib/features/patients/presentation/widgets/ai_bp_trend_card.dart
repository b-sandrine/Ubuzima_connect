import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/charts/line_trend_chart.dart';
import '../../domain/models/bp_trend_point.dart';

/// The 30-day "Blood Pressure Trend" chart on the AI Insights screen — the
/// same dual-series [LineTrendChart] the dashboard's 7-day card uses, but
/// with day labels thinned out (every ~4th point) so 30 dates don't crowd
/// the x-axis.
class AiBpTrendCard extends StatelessWidget {
  final List<BpTrendPoint> points;

  const AiBpTrendCard({super.key, required this.points});

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
        color: AppColors.secondary,
        values: [for (final p in points) p.diastolic],
        dashed: true,
      ),
    ];
    final step = (points.length / 8).ceil().clamp(1, points.length);
    final xLabels = [
      for (var i = 0; i < points.length; i += step) points[i].dayLabel,
      if ((points.length - 1) % step != 0) points.last.dayLabel,
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LineTrendChart(
          xLabels: xLabels,
          yTicks: const [70, 100, 130, 160],
          series: series,
        ),
        const SizedBox(height: 14),
        LineTrendLegend(series: series),
      ],
    );
  }
}
