import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

/// One plotted series in a [LineTrendChart] — e.g. a vital's systolic vs.
/// diastolic readings across a week.
class LineTrendSeries {
  final String label;
  final Color color;
  final List<double> values;

  /// Dashed stroke for the secondary series, matching the design's solid
  /// systolic / dotted diastolic convention.
  final bool dashed;

  const LineTrendSeries({
    required this.label,
    required this.color,
    required this.values,
    this.dashed = false,
  });
}

/// Minimal dependency-free multi-series line chart for foundation-stage
/// trend displays (e.g. a week of blood-pressure readings). Swap for a full
/// charting package (e.g. `fl_chart`) once real chart requirements (zoom,
/// tooltips, scrolling) are defined — kept dependency-free for now since
/// none was requested in the tech stack.
class LineTrendChart extends StatelessWidget {
  final List<String> xLabels;
  final List<double> yTicks;
  final List<LineTrendSeries> series;
  final double height;

  const LineTrendChart({
    super.key,
    required this.xLabels,
    required this.yTicks,
    required this.series,
    this.height = 150,
  });

  @override
  Widget build(BuildContext context) {
    final minY = yTicks.first;
    final maxY = yTicks.last;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: height,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                width: 26,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    for (final tick in yTicks.reversed)
                      Text(
                        '${tick.toInt()}',
                        style: const TextStyle(
                          fontSize: 10.5,
                          color: AppColors.textTertiary,
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: CustomPaint(
                  size: Size.infinite,
                  painter: _LineTrendPainter(
                    series: series,
                    minY: minY,
                    maxY: maxY,
                    gridLines: yTicks.length,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 6),
        Padding(
          padding: const EdgeInsets.only(left: 34),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              for (final label in xLabels)
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 10.5,
                    color: AppColors.textTertiary,
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

/// A small colour + line-style swatch row describing each [LineTrendChart]
/// series, placed under the chart (e.g. "— Systolic  ⋯ Diastolic").
class LineTrendLegend extends StatelessWidget {
  final List<LineTrendSeries> series;

  const LineTrendLegend({super.key, required this.series});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 18,
      runSpacing: 6,
      children: [
        for (final entry in series)
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomPaint(
                size: const Size(18, 3),
                painter: _LegendSwatchPainter(
                  color: entry.color,
                  dashed: entry.dashed,
                ),
              ),
              const SizedBox(width: 6),
              Text(
                entry.label,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
      ],
    );
  }
}

class _LegendSwatchPainter extends CustomPainter {
  final Color color;
  final bool dashed;

  const _LegendSwatchPainter({required this.color, required this.dashed});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round;
    final y = size.height / 2;

    if (!dashed) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
      return;
    }

    const dashWidth = 3.5;
    const gapWidth = 3.0;
    var x = 0.0;
    while (x < size.width) {
      canvas.drawLine(Offset(x, y), Offset(x + dashWidth, y), paint);
      x += dashWidth + gapWidth;
    }
  }

  @override
  bool shouldRepaint(covariant _LegendSwatchPainter oldDelegate) =>
      oldDelegate.color != color || oldDelegate.dashed != dashed;
}

class _LineTrendPainter extends CustomPainter {
  final List<LineTrendSeries> series;
  final double minY;
  final double maxY;
  final int gridLines;

  const _LineTrendPainter({
    required this.series,
    required this.minY,
    required this.maxY,
    required this.gridLines,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final gridPaint = Paint()
      ..color = AppColors.border
      ..strokeWidth = 1;

    for (var i = 0; i < gridLines; i++) {
      final y = size.height * i / (gridLines - 1);
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    for (final entry in series) {
      _paintSeries(canvas, size, entry);
    }
  }

  void _paintSeries(Canvas canvas, Size size, LineTrendSeries entry) {
    final points = _pointsFor(size, entry.values);
    final paint = Paint()
      ..color = entry.color
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    if (!entry.dashed) {
      final path = Path()..moveTo(points.first.dx, points.first.dy);
      for (final point in points.skip(1)) {
        path.lineTo(point.dx, point.dy);
      }
      canvas.drawPath(path, paint);

      final dotPaint = Paint()..color = entry.color;
      for (final point in points) {
        canvas.drawCircle(point, 3, dotPaint);
      }
      return;
    }

    const dashLength = 5.0;
    const gapLength = 4.0;
    for (var i = 0; i < points.length - 1; i++) {
      _drawDashedSegment(canvas, points[i], points[i + 1], paint, dashLength, gapLength);
    }
  }

  void _drawDashedSegment(
    Canvas canvas,
    Offset start,
    Offset end,
    Paint paint,
    double dashLength,
    double gapLength,
  ) {
    final total = (end - start).distance;
    if (total == 0) return;
    final direction = (end - start) / total;
    var travelled = 0.0;

    while (travelled < total) {
      final dashEnd = (travelled + dashLength).clamp(0.0, total);
      canvas.drawLine(
        start + direction * travelled,
        start + direction * dashEnd,
        paint,
      );
      travelled += dashLength + gapLength;
    }
  }

  List<Offset> _pointsFor(Size size, List<double> values) {
    final range = maxY - minY == 0 ? 1 : maxY - minY;
    final step = values.length > 1 ? size.width / (values.length - 1) : 0.0;

    return [
      for (var i = 0; i < values.length; i++)
        Offset(
          step * i,
          size.height * (1 - (values[i] - minY) / range),
        ),
    ];
  }

  @override
  bool shouldRepaint(covariant _LineTrendPainter oldDelegate) =>
      oldDelegate.series != series ||
      oldDelegate.minY != minY ||
      oldDelegate.maxY != maxY;
}
