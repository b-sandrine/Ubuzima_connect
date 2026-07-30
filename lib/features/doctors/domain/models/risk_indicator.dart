import 'package:flutter/material.dart';

/// One scored risk dimension on the Patient Details screen, e.g.
/// "Cardiovascular" at 78%.
class RiskIndicator {
  final String label;

  /// 0–100.
  final int percentage;
  final IconData icon;
  final Color color;

  const RiskIndicator({
    required this.label,
    required this.percentage,
    required this.icon,
    required this.color,
  });
}

/// The patient's overall risk banner (e.g. "High Risk") plus the individual
/// indicators shown beneath it.
class RiskProfile {
  final String overallLabel;
  final Color overallColor;
  final List<RiskIndicator> indicators;

  const RiskProfile({
    required this.overallLabel,
    required this.overallColor,
    required this.indicators,
  });
}
