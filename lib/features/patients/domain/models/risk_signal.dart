import 'package:flutter/material.dart';

/// How concerning a [RiskSignal] currently is — drives its pill/progress
/// colour on the Risk Signals section.
enum RiskSignalLevel { low, moderate, monitoring, high }

/// One tracked risk area on the AI Insights screen (e.g. "Hypertension
/// Risk"), shown as a labelled progress bar with a short explanation.
class RiskSignal {
  final String id;
  final IconData icon;
  final Color color;
  final String title;
  final String levelLabel;
  final RiskSignalLevel level;

  /// 0.0–1.0 fill for the progress bar.
  final double progress;
  final String description;

  const RiskSignal({
    required this.id,
    required this.icon,
    required this.color,
    required this.title,
    required this.levelLabel,
    required this.level,
    required this.progress,
    required this.description,
  });
}
