import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../domain/models/allergy.dart';
import 'dashboard_style.dart';

/// One chip in the Allergies & Alerts panel: a warning glyph, the allergen,
/// and its severity.
class AllergyChip extends StatelessWidget {
  final Allergy allergy;

  const AllergyChip({super.key, required this.allergy});

  @override
  Widget build(BuildContext context) {
    final color = DashboardStyle.allergySeverityColor(allergy.severity);
    final severityLabel = DashboardStyle.allergySeverityLabel(allergy.severity);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 7),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(AppRadius.full),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(LucideIcons.triangleAlert, size: 13, color: color),
          const SizedBox(width: 5),
          Text(
            '${allergy.label} — $severityLabel',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
