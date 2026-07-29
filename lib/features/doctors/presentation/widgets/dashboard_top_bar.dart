import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/branding/ubuzima_wordmark.dart';

/// The brand lockup + notification bell + doctor avatar row shared by every
/// top-level doctor screen (dashboard, patient search, ...).
class DashboardTopBar extends StatelessWidget {
  final String? doctorPhotoUrl;
  final VoidCallback? onNotificationsTap;

  const DashboardTopBar({
    super.key,
    this.doctorPhotoUrl,
    this.onNotificationsTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(child: UbuzimaWordmark(compact: true)),
        const SizedBox(width: 8),
        _NotificationButton(onTap: onNotificationsTap),
        const SizedBox(width: 10),
        _DoctorAvatar(photoUrl: doctorPhotoUrl),
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
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              const Icon(
                LucideIcons.bell,
                size: 20,
                color: AppColors.textPrimary,
              ),
              Positioned(
                right: -2,
                top: -2,
                child: Container(
                  width: 9,
                  height: 9,
                  decoration: BoxDecoration(
                    color: AppColors.danger,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 1.5),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DoctorAvatar extends StatelessWidget {
  final String? photoUrl;

  const _DoctorAvatar({this.photoUrl});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.roleDoctor, width: 2),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: (photoUrl == null || photoUrl!.isEmpty)
            ? Container(
                color: AppColors.roleDoctorTint,
                child: const Icon(
                  LucideIcons.userRound,
                  size: 20,
                  color: AppColors.roleDoctor,
                ),
              )
            : Image.network(
                photoUrl!,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  color: AppColors.roleDoctorTint,
                  child: const Icon(
                    LucideIcons.userRound,
                    size: 20,
                    color: AppColors.roleDoctor,
                  ),
                ),
              ),
      ),
    );
  }
}
