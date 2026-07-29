import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/pills/status_pill.dart';
import '../../domain/models/doctor.dart';
import 'dashboard_top_bar.dart';

/// The dashboard's top section: brand lockup, notification bell, doctor
/// avatar, greeting, and the on-duty / hospital line.
class DashboardHeader extends StatelessWidget {
  final Doctor doctor;
  final VoidCallback? onNotificationsTap;

  const DashboardHeader({
    super.key,
    required this.doctor,
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
        DashboardTopBar(
          doctorPhotoUrl: doctor.photoUrl,
          onNotificationsTap: onNotificationsTap,
        ),
        const SizedBox(height: 18),
        Text(
          _greeting,
          style: const TextStyle(fontSize: 15, color: AppColors.textSecondary),
        ),
        const SizedBox(height: 2),
        Text(
          doctor.fullName,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            if (doctor.onDuty)
              const StatusPill(
                label: 'On Duty',
                color: AppColors.success,
                leadingDot: true,
              ),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                doctor.hospital,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 13.5,
                  color: AppColors.textSecondary,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
