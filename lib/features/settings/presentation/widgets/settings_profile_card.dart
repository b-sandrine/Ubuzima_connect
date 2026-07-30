import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/extensions/string_extensions.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../shared/widgets/pills/status_pill.dart';
import '../../domain/models/user_profile_summary.dart';

/// The identity card at the top of Settings: initials avatar, name, role +
/// facility, an Active badge, the user's ID, and an Edit Profile button.
class SettingsProfileCard extends StatelessWidget {
  final UserProfileSummary profile;
  final VoidCallback? onEditProfile;

  const SettingsProfileCard({
    super.key,
    required this.profile,
    this.onEditProfile,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.sm + 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A0F172A),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _ProfileAvatar(profile: profile),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  profile.fullName,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 15.5,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${profile.roleLabel} · ${profile.facility}',
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 12.5,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    if (profile.isActive)
                      const StatusPill(label: 'Active', color: AppColors.success),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Text(
                        'ID: ${profile.displayId}',
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 11.5,
                          color: AppColors.textTertiary,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Material(
            color: AppColors.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(AppRadius.md + 2),
            child: InkWell(
              onTap: onEditProfile,
              borderRadius: BorderRadius.circular(AppRadius.md + 2),
              child: const Padding(
                padding: EdgeInsets.all(10),
                child: Icon(
                  LucideIcons.squarePen,
                  size: 17,
                  color: AppColors.primary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileAvatar extends StatelessWidget {
  final UserProfileSummary profile;

  const _ProfileAvatar({required this.profile});

  @override
  Widget build(BuildContext context) {
    final photoUrl = profile.photoUrl;

    return Container(
      width: 52,
      height: 52,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [profile.accentColor, AppColors.secondary],
        ),
        borderRadius: BorderRadius.circular(AppRadius.md + 4),
      ),
      child: (photoUrl == null || photoUrl.isEmpty)
          ? Center(
              child: Text(
                profile.fullName.initials,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
            )
          : ClipRRect(
              borderRadius: BorderRadius.circular(AppRadius.md + 4),
              child: Image.network(
                photoUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Center(
                  child: Text(
                    profile.fullName.initials,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}
