import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../domain/models/notification_item.dart';

/// The single reusable notification row shared by every audience and every
/// category — a colour-coded left accent bar, an icon or avatar leading, a
/// title + status badge, a subtitle, a description, a timestamp, and an
/// optional action button. Read notifications render muted with no action.
class NotificationCard extends StatelessWidget {
  final NotificationItem item;
  final VoidCallback? onTap;
  final VoidCallback? onAction;

  const NotificationCard({
    super.key,
    required this.item,
    this.onTap,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    final accent = item.isRead ? AppColors.textTertiary : item.accentColor;

    return ClipRRect(
      borderRadius: BorderRadius.circular(AppRadius.lg),
      child: Material(
        color: Colors.white,
        child: InkWell(
          onTap: onTap,
          child: DecoratedBox(
            decoration: item.isRead
                ? const BoxDecoration()
                : const BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Color(0x0A0F172A),
                        blurRadius: 12,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
            child: IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(width: 4, color: accent),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(AppSpacing.sm + 4),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _Leading(item: item, muted: item.isRead),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  item.title,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 14.5,
                                    fontWeight: FontWeight.w700,
                                    color: item.isRead
                                        ? AppColors.textSecondary
                                        : AppColors.textPrimary,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              _Badge(
                                label: item.badgeLabel,
                                color: item.isRead
                                    ? AppColors.textTertiary
                                    : item.badgeColor,
                                filled: item.badgeFilled && !item.isRead,
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Padding(
                            padding: const EdgeInsets.only(left: 42),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.subtitleLine,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 12.5,
                                    fontWeight: FontWeight.w600,
                                    color: item.isRead
                                        ? AppColors.textTertiary
                                        : AppColors.textSecondary,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  item.description,
                                  style: TextStyle(
                                    fontSize: 12.5,
                                    height: 1.4,
                                    color: item.isRead
                                        ? AppColors.textTertiary
                                        : AppColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 42),
                                child: Text(
                                  item.timestampLabel,
                                  style: const TextStyle(
                                    fontSize: 11.5,
                                    color: AppColors.textTertiary,
                                  ),
                                ),
                              ),
                              const Spacer(),
                              if (item.actionLabel != null && !item.isRead)
                                _ActionButton(
                                  label: item.actionLabel!,
                                  icon: item.actionIcon,
                                  color: item.accentColor,
                                  onPressed: onAction,
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Leading extends StatelessWidget {
  final NotificationItem item;
  final bool muted;

  const _Leading({required this.item, required this.muted});

  @override
  Widget build(BuildContext context) {
    final color = muted ? AppColors.textTertiary : item.accentColor;
    final photo = item.avatarUrl;

    if (photo != null && photo.isNotEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(AppRadius.md + 2),
        child: Image.network(
          photo,
          width: 32,
          height: 32,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => _IconTile(
            icon: LucideIcons.userRound,
            color: color,
          ),
        ),
      );
    }

    return _IconTile(icon: item.icon, color: color);
  }
}

class _IconTile extends StatelessWidget {
  final IconData icon;
  final Color color;

  const _IconTile({required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(AppRadius.md + 2),
      ),
      child: Icon(icon, size: 16, color: color),
    );
  }
}

class _Badge extends StatelessWidget {
  final String label;
  final Color color;
  final bool filled;

  const _Badge({required this.label, required this.color, required this.filled});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
      decoration: BoxDecoration(
        color: filled ? color.withValues(alpha: 0.14) : Colors.transparent,
        borderRadius: BorderRadius.circular(AppRadius.full),
        border: filled ? null : Border.all(color: color.withValues(alpha: 0.4)),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 10.5,
          fontWeight: FontWeight.w700,
          color: color,
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final String label;
  final IconData? icon;
  final Color color;
  final VoidCallback? onPressed;

  const _ActionButton({
    required this.label,
    required this.color,
    this.icon,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color.withValues(alpha: 0.12),
      borderRadius: BorderRadius.circular(AppRadius.md),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(AppRadius.md),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(icon, size: 13, color: color),
                const SizedBox(width: 5),
              ],
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
