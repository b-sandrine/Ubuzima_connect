import 'package:flutter/material.dart';

/// One small status chip under the [AiHealthSummary] paragraph (e.g.
/// "Meds on track").
class AiSummaryTag {
  final IconData icon;
  final String label;
  final Color color;

  const AiSummaryTag({
    required this.icon,
    required this.label,
    required this.color,
  });
}

/// The full narrative "Ubuzima AI Analysis" block on the AI Insights screen
/// — a longer, generated read of the patient's overall trend than the
/// single-line [AiHealthInsight] teaser on the dashboard.
class AiHealthSummary {
  final String patientName;
  final String dateLabel;
  final String body;
  final List<AiSummaryTag> tags;

  const AiHealthSummary({
    required this.patientName,
    required this.dateLabel,
    required this.body,
    required this.tags,
  });
}
