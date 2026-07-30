import 'package:flutter/material.dart';

/// Where a [VitalSign] reading falls — drives its status pill colour, when
/// shown. Not every vital carries one (Weight and Heart Rate render as
/// plain readings in the design).
enum VitalStatus { high, elevated, normal }

/// The direction of a vital's trend arrow.
enum VitalTrendDirection { up, down, stable }

/// One tile in the Latest Vitals grid.
class VitalSign {
  final String label;
  final String value;
  final String unit;
  final IconData icon;

  /// Null hides the status pill (e.g. Weight, Heart Rate).
  final VitalStatus? status;

  /// Null hides the trend row entirely.
  final VitalTrendDirection? trend;

  /// The trend row's text, e.g. "+14 from last" or "Stable". Required
  /// whenever [trend] is non-null.
  final String? trendText;

  const VitalSign({
    required this.label,
    required this.value,
    required this.unit,
    required this.icon,
    this.status,
    this.trend,
    this.trendText,
  });
}
