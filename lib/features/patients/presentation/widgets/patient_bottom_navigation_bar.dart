import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/navigation/ubuzima_bottom_nav.dart';

/// The patient role's five-tab bottom navigation: Home, Records, AI
/// Insights, Alerts, Settings. Wraps the shared [UbuzimaBottomNav] with the
/// patient-specific destinations rather than duplicating the nav bar shell.
class PatientBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int>? onTap;

  const PatientBottomNavigationBar({
    super.key,
    required this.currentIndex,
    this.onTap,
  });

  static const List<BottomNavItem> _items = [
    BottomNavItem(icon: LucideIcons.house, label: 'Home'),
    BottomNavItem(icon: LucideIcons.folderOpen, label: 'Records'),
    BottomNavItem(icon: LucideIcons.brain, label: 'AI Insights'),
    BottomNavItem(
      icon: LucideIcons.bell,
      label: 'Alerts',
      showDot: true,
      dotColor: AppColors.warning,
    ),
    BottomNavItem(icon: LucideIcons.settings, label: 'Settings'),
  ];

  @override
  Widget build(BuildContext context) {
    return UbuzimaBottomNav(
      items: _items,
      currentIndex: currentIndex,
      onTap: onTap,
    );
  }
}
