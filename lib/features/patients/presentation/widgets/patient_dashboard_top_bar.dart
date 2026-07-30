import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/branding/ubuzima_wordmark.dart';
import '../../../../shared/widgets/pills/status_pill.dart';

/// The brand lockup + "LIVE" status pill + notification bell row shared by
/// every top-level patient screen.
class PatientDashboardTopBar extends StatelessWidget {
  final VoidCallback? onNotificationsTap;

  const PatientDashboardTopBar({super.key, this.onNotificationsTap});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(child: UbuzimaWordmark(compact: true)),
        const SizedBox(width: 8),
        const StatusPill(
          label: 'LIVE',
          color: AppColors.success,
          leadingDot: true,
        ),
        const SizedBox(width: 8),
        _NotificationButton(onTap: onNotificationsTap),
      ],
    );
  }
}

class _NotificationButton extends StatelessWidget {
  final VoidCallback? onTap;

  const _NotificationButton({this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      shape: const CircleBorder(),
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: const Padding(
          padding: EdgeInsets.all(10),
          child: Icon(LucideIcons.bell, size: 20, color: AppColors.textPrimary),
        ),
      ),
    );
  }
}
