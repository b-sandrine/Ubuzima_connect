import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/routing/app_routes.dart';
import '../../../../shared/widgets/navigation/ubuzima_bottom_nav.dart';
import '../../../authentication/domain/usecases/sign_out.dart';

/// Shared CHW bottom navigation used across dashboard, patients, alerts,
/// settings, and clinical screens.
class ChwBottomNav extends StatelessWidget {
  final int currentIndex;

  const ChwBottomNav({super.key, required this.currentIndex});

  static Future<void> handleTap(BuildContext context, int index) async {
    switch (index) {
      case 0:
        context.go(AppRoutes.chwDashboard);
      case 1:
        context.go(AppRoutes.chwPatientList);
      case 2:
        context.push(AppRoutes.newPatientIntake);
      case 3:
        context.go(AppRoutes.chwNotifications);
      case 4:
        context.go(AppRoutes.chwSettings);
    }
  }

  static Future<void> signOut(BuildContext context) async {
    final result = await getIt<SignOut>()();
    if (!context.mounted) return;
    result.fold(
      (failure) => ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(failure.message))),
      (_) => context.go(AppRoutes.splash),
    );
  }

  @override
  Widget build(BuildContext context) {
    return UbuzimaBottomNav(
      currentIndex: currentIndex,
      onTap: (i) => handleTap(context, i),
      items: const [
        BottomNavItem(icon: LucideIcons.house, label: 'Home'),
        BottomNavItem(icon: LucideIcons.users, label: 'Patients'),
        BottomNavItem(
          icon: LucideIcons.userPlus,
          label: 'Register',
          isPrimary: true,
        ),
        BottomNavItem(icon: LucideIcons.triangleAlert, label: 'Alerts'),
        BottomNavItem(icon: LucideIcons.settings, label: 'Settings'),
      ],
    );
  }
}
