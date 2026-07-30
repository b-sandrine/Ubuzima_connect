import 'package:flutter/material.dart';

import '../../../../core/theme/app_spacing.dart';

/// A generic tinted icon + text banner — used for the drug-interaction flag
/// beneath Allergies & Alerts, and reusable anywhere a single-line, colour-
/// coded notice is needed without the AI branding of [AiInsightBanner].
class AlertInfoBanner extends StatelessWidget {
  final IconData icon;
  final String message;
  final Color color;

  const AlertInfoBanner({
    super.key,
    required this.icon,
    required this.message,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.sm + 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: color),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              message,
              style: TextStyle(fontSize: 13, height: 1.35, color: color),
            ),
          ),
        ],
      ),
    );
  }
}
