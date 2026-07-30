import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../domain/models/patient_profile.dart';
import 'patient_avatar.dart';
import 'patient_dashboard_top_bar.dart';

/// The dashboard's top section: brand lockup + LIVE pill + bell, then the
/// greeting row with the patient's name, ID, and avatar.
class PatientDashboardHeader extends StatelessWidget {
  final PatientProfile patient;
  final VoidCallback? onNotificationsTap;

  const PatientDashboardHeader({
    super.key,
    required this.patient,
    this.onNotificationsTap,
  });

  String get _greeting {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good morning,';
    if (hour < 17) return 'Good afternoon,';
    return 'Good evening,';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        PatientDashboardTopBar(onNotificationsTap: onNotificationsTap),
        const SizedBox(height: 18),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _greeting,
                    style: const TextStyle(
                      fontSize: 15,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    patient.fullName,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${patient.dateLabel} · ID ${patient.displayId}',
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.textTertiary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            PatientAvatar(
              photoUrl: patient.photoUrl,
              verified: patient.verified,
            ),
          ],
        ),
      ],
    );
  }
}
