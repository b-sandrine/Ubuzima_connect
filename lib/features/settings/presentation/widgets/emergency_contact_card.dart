import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../domain/models/emergency_contact.dart';

/// One row in the Emergency Contacts list: icon avatar, name +
/// relationship/phone, a call button, and a more-options button.
class EmergencyContactCard extends StatelessWidget {
  final EmergencyContact contact;
  final VoidCallback? onCall;
  final VoidCallback? onMore;

  const EmergencyContactCard({
    super.key,
    required this.contact,
    this.onCall,
    this.onMore,
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
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: contact.iconColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(AppRadius.md + 2),
            ),
            child: Icon(contact.icon, size: 19, color: contact.iconColor),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  contact.name,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 14.5,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${contact.relationship} · ${contact.phoneNumber}',
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 12.5,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Material(
            color: AppColors.success.withValues(alpha: 0.12),
            shape: const CircleBorder(),
            child: InkWell(
              onTap: onCall,
              customBorder: const CircleBorder(),
              child: const Padding(
                padding: EdgeInsets.all(9),
                child: Icon(LucideIcons.phone, size: 16, color: AppColors.success),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Material(
            color: AppColors.lightBackground,
            shape: const CircleBorder(),
            child: InkWell(
              onTap: onMore,
              customBorder: const CircleBorder(),
              child: const Padding(
                padding: EdgeInsets.all(9),
                child: Icon(
                  LucideIcons.moreHorizontal,
                  size: 16,
                  color: AppColors.textSecondary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
