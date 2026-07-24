import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../branding/ubuzima_wordmark.dart';
import '../pills/status_pill.dart';

/// The in-app header row: the compact Ubuzima lockup on the left and a small
/// cluster of actions on the right. Screens vary the right side — a context
/// pill (MEDICATIONS, LIVE), a bell, sometimes an avatar — so those are
/// passed in as [trailing].
class AppTopBar extends StatelessWidget {
  /// Optional context label drawn as an outlined pill next to the actions
  /// (e.g. "MEDICATIONS", "LIVE").
  final String? contextLabel;
  final Color contextColor;
  final IconData? contextIcon;
  final List<Widget> trailing;
  final VoidCallback? onBack;

  const AppTopBar({
    super.key,
    this.contextLabel,
    this.contextColor = AppColors.primary,
    this.contextIcon,
    this.trailing = const [],
    this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (onBack != null) ...[
          _CircleButton(icon: Icons.arrow_back_ios_new, onTap: onBack!),
          const SizedBox(width: 10),
        ],
        // The wordmark takes the free space and stays left-aligned, so the
        // pill and action buttons sit hard against the right edge without a
        // separate Spacer competing for width.
        const Expanded(
          child: Align(
            alignment: Alignment.centerLeft,
            child: UbuzimaWordmark(compact: true),
          ),
        ),
        const SizedBox(width: 8),
        if (contextLabel != null) ...[
          StatusPill(
            label: contextLabel!,
            color: contextColor,
            icon: contextIcon,
            filled: false,
            fontSize: 12,
          ),
          const SizedBox(width: 8),
        ],
        for (var i = 0; i < trailing.length; i++) ...[
          if (i != 0) const SizedBox(width: 8),
          trailing[i],
        ],
      ],
    );
  }
}

/// The soft white circular icon button used for back, bell and overflow in
/// the design headers.
class CircleIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;
  final Color? color;

  /// A small red dot in the top-right (unread notifications).
  final bool showDot;

  const CircleIconButton({
    super.key,
    required this.icon,
    this.onTap,
    this.color,
    this.showDot = false,
  });

  @override
  Widget build(BuildContext context) => _CircleButton(
    icon: icon,
    onTap: onTap ?? () {},
    color: color,
    showDot: showDot,
  );
}

class _CircleButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final Color? color;
  final bool showDot;

  const _CircleButton({
    required this.icon,
    required this.onTap,
    this.color,
    this.showDot = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.border),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x0A0F172A),
                  blurRadius: 8,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Icon(icon, size: 18, color: color ?? AppColors.textSecondary),
          ),
          if (showDot)
            Positioned(
              right: 0,
              top: 0,
              child: Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  color: AppColors.danger,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 1.5),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
