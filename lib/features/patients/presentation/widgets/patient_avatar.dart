import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/theme/app_colors.dart';

/// The patient's circular profile photo with a small verified checkmark
/// badge, shown beside the dashboard greeting.
class PatientAvatar extends StatelessWidget {
  final String? photoUrl;
  final bool verified;
  final double size;

  const PatientAvatar({
    super.key,
    this.photoUrl,
    this.verified = false,
    this.size = 48,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(size / 2),
            child: (photoUrl == null || photoUrl!.isEmpty)
                ? Container(
                    color: AppColors.rolePatientTint,
                    child: Icon(
                      LucideIcons.userRound,
                      size: size * 0.45,
                      color: AppColors.rolePatient,
                    ),
                  )
                : Image.network(
                    photoUrl!,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      color: AppColors.rolePatientTint,
                      child: Icon(
                        LucideIcons.userRound,
                        size: size * 0.45,
                        color: AppColors.rolePatient,
                      ),
                    ),
                  ),
          ),
          if (verified)
            Positioned(
              right: -2,
              bottom: -2,
              child: Container(
                width: 16,
                height: 16,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppColors.success,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
                child: const Icon(
                  LucideIcons.check,
                  size: 9,
                  color: Colors.white,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
