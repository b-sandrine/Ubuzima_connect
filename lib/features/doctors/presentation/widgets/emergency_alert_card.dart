import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../domain/models/emergency_alert.dart';
import 'dashboard_style.dart';

/// One row inside the Emergency Alerts panel: severity dot, patient +
/// location, description, and a colour-matched View button.
class EmergencyAlertCard extends StatelessWidget {
  final EmergencyAlert alert;
  final VoidCallback? onView;

  const EmergencyAlertCard({super.key, required this.alert, this.onView});

  @override
  Widget build(BuildContext context) {
    final color = DashboardStyle.alertSeverityColor(alert.severity);
    final severityLabel = DashboardStyle.alertSeverityLabel(alert.severity);

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 5),
            child: Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text.rich(
                  TextSpan(
                    style: const TextStyle(
                      fontSize: 14.5,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                      height: 1.3,
                    ),
                    children: [
                      TextSpan(
                        text: '$severityLabel: ',
                        style: TextStyle(color: color),
                      ),
                      TextSpan(
                        text: '${alert.patientName} — ${alert.location}',
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  alert.description,
                  style: const TextStyle(
                    fontSize: 12.5,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          _ViewButton(color: color, onTap: onView),
        ],
      ),
    );
  }
}

class _ViewButton extends StatelessWidget {
  final Color color;
  final VoidCallback? onTap;

  const _ViewButton({required this.color, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color,
      borderRadius: BorderRadius.circular(AppRadius.md),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.md),
        child: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 9),
          child: Text(
            'View',
            style: TextStyle(
              fontSize: 12.5,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
