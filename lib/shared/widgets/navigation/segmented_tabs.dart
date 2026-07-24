import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

/// The white pill-strip of filter tabs sitting under the header on every
/// in-app screen (Today / Prescriptions / Adherence, Incoming / Outgoing /
/// Follow-Up, Overview / Vitals / Visits …).
///
/// The active tab fills green; the strip scrolls horizontally so a fourth or
/// fifth tab never overflows on a narrow phone. Some screens give each tab a
/// leading [icons] glyph and a trailing count [badges] (e.g. Incoming · 2).
class SegmentedTabs extends StatelessWidget {
  final List<String> tabs;
  final List<IconData>? icons;
  final List<int?>? badges;
  final int selectedIndex;
  final ValueChanged<int> onSelected;

  const SegmentedTabs({
    super.key,
    required this.tabs,
    required this.selectedIndex,
    required this.onSelected,
    this.icons,
    this.badges,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (var i = 0; i < tabs.length; i++) ...[
            _Tab(
              label: tabs[i],
              icon: icons != null ? icons![i] : null,
              badge: badges != null ? badges![i] : null,
              isActive: i == selectedIndex,
              onTap: () => onSelected(i),
            ),
            if (i != tabs.length - 1) const SizedBox(width: 8),
          ],
        ],
      ),
    );
  }
}

class _Tab extends StatelessWidget {
  final String label;
  final IconData? icon;
  final int? badge;
  final bool isActive;
  final VoidCallback onTap;

  const _Tab({
    required this.label,
    required this.icon,
    required this.badge,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final foreground = isActive ? Colors.white : AppColors.textSecondary;

    return Material(
      color: isActive ? AppColors.primary : Colors.white,
      borderRadius: BorderRadius.circular(999),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(999),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 11),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(999),
            border: Border.all(
              color: isActive ? AppColors.primary : AppColors.border,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(icon, size: 15, color: foreground),
                const SizedBox(width: 6),
              ],
              Text(
                label,
                style: TextStyle(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w700,
                  color: foreground,
                ),
              ),
              if (badge != null) ...[
                const SizedBox(width: 7),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 1,
                  ),
                  constraints: const BoxConstraints(minWidth: 18),
                  decoration: BoxDecoration(
                    color: isActive
                        ? Colors.white.withValues(alpha: 0.25)
                        : AppColors.primary.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    '$badge',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: isActive ? Colors.white : AppColors.primary,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
