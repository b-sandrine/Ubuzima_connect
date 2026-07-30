import 'package:go_router/go_router.dart';

import '../../core/routing/app_routes.dart';
import 'presentation/pages/login_page.dart';
import 'presentation/pages/register_page.dart';
import 'presentation/pages/reset_password_page.dart';
import 'presentation/pages/role_selection_page.dart';
import 'presentation/pages/welcome_page.dart';

abstract final class AuthenticationRoutes {
  static List<RouteBase> get routes => [
    GoRoute(
      path: AppRoutes.splash,
      builder: (context, state) => const WelcomePage(),
    ),
    GoRoute(
      path: AppRoutes.roleSelection,
      builder: (context, state) => const RoleSelectionPage(),
    ),
    GoRoute(
      path: AppRoutes.login,
      builder: (context, state) => const LoginPage(),
    ),
    GoRoute(
      path: AppRoutes.register,
      builder: (context, state) => const RegisterPage(),
    ),
    GoRoute(
      path: AppRoutes.resetPassword,
      builder: (context, state) => const ResetPasswordPage(),
    ),
  ];
}
