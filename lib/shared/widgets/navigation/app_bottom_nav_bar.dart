import 'package:flutter/material.dart';

class AppBottomNavItem {
  final IconData icon;
  final IconData? selectedIcon;
  final String label;

  const AppBottomNavItem({
    required this.icon,
    required this.label,
    this.selectedIcon,
  });
}

/// Role-aware bottom navigation shell. Each role's home shell
/// (CHW / Doctor / Patient) supplies its own [items] and [onTap] — this
/// widget only renders, it has no opinion on what tabs exist per role.
class AppBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final List<AppBottomNavItem> items;
  final ValueChanged<int> onTap;

  const AppBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.items,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      selectedIndex: currentIndex,
      onDestinationSelected: onTap,
      destinations: [
        for (final item in items)
          NavigationDestination(
            icon: Icon(item.icon),
            selectedIcon: item.selectedIcon != null
                ? Icon(item.selectedIcon)
                : null,
            label: item.label,
          ),
      ],
    );
  }
}
