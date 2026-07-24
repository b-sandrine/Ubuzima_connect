import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/patient_timeline.dart';

/// The "BP & Glucose Trend" card on DOC-04: two normalised line series drawn
/// over a shared month axis, with a small legend. Each series is scaled to
/// its own min/max so both read clearly despite very different units.
class TrendChart extends StatelessWidget {
  final List<TrendPoint> points;

  static const Color _systolicColor = AppColors.danger;
  static const Color _glucoseColor = AppColors.warning;

  const TrendChart({super.key, required this.points});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
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
              const Expanded(
                child: Text(
                  'BP & Glucose Trend',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              const _LegendDot(color: _systolicColor, label: 'BP Systolic'),
              const SizedBox(width: 12),
              const _LegendDot(color: _glucoseColor, label: 'Glucose'),
            ],
          ),
          const SizedBox(height: 14),
          SizedBox(
            height: 120,
            child: LayoutBuilder(
              builder: (context, constraints) => CustomPaint(
                size: Size(constraints.maxWidth, 120),
                painter: _TrendPainter(
                  points: points,
                  systolicColor: _systolicColor,
                  glucoseColor: _glucoseColor,
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              for (final point in points)
                Text(
                  point.label,
                  style: const TextStyle(
                    fontSize: 10.5,
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

class _LegendDot extends StatelessWidget {
  final Color color;
  final String label;

  const _LegendDot({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 5),
        Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}

class _TrendPainter extends CustomPainter {
  final List<TrendPoint> points;
  final Color systolicColor;
  final Color glucoseColor;

  _TrendPainter({
    required this.points,
    required this.systolicColor,
    required this.glucoseColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (points.length < 2) return;

    _drawSeries(
      canvas,
      size,
      points.map((p) => p.systolic).toList(),
      systolicColor,
    );
    _drawSeries(
      canvas,
      size,
      points.map((p) => p.glucose).toList(),
      glucoseColor,
    );
  }

  void _drawSeries(Canvas canvas, Size size, List<double> values, Color color) {
    final min = values.reduce((a, b) => a < b ? a : b);
    final max = values.reduce((a, b) => a > b ? a : b);
    final range = (max - min).abs() < 0.001 ? 1.0 : max - min;
    const topPad = 8.0;
    const bottomPad = 8.0;
    final usableHeight = size.height - topPad - bottomPad;
    final step = size.width / (values.length - 1);

    Offset pointAt(int i) {
      final normalised = (values[i] - min) / range;
      final y = topPad + (1 - normalised) * usableHeight;
      return Offset(i * step, y);
    }

    final linePaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.4
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final fillPaint = Paint()
      ..color = color.withValues(alpha: 0.10)
      ..style = PaintingStyle.fill;

    final line = Path()..moveTo(pointAt(0).dx, pointAt(0).dy);
    for (var i = 1; i < values.length; i++) {
      line.lineTo(pointAt(i).dx, pointAt(i).dy);
    }

    final fill = Path.from(line)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();

    canvas.drawPath(fill, fillPaint);
    canvas.drawPath(line, linePaint);

    final dotPaint = Paint()..color = color;
    for (var i = 0; i < values.length; i++) {
      canvas.drawCircle(pointAt(i), 2.6, dotPaint);
    }
  }

  @override
  bool shouldRepaint(_TrendPainter oldDelegate) =>
      oldDelegate.points != points;
}
