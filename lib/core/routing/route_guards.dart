import 'package:go_router/go_router.dart';

import 'app_routes.dart';
import 'auth_session.dart';

/// Redirect logic applied to every navigation: unauthenticated users are
/// bounced to the welcome screen; authenticated users landing on onboarding
/// routes are sent to `/home`. Role-based redirects plug in here once
/// feature route metadata describes which roles a route allows.
abstract final class RouteGuards {
  static String? redirect(
    AuthSessionProvider authSessionProvider,
    GoRouterState state,
  ) {
    final status = authSessionProvider.currentStatus;
    final location = state.matchedLocation;
    final atLogin = location == AppRoutes.login;
    final atRegister = location == AppRoutes.register;
    final atSplash = location == AppRoutes.splash;
    final atRoleSelection = location == AppRoutes.roleSelection;
    final atDemoScreen = AppRoutes.demoReachable.contains(location);

    if (status == AuthSessionStatus.unauthenticated &&
        !atLogin &&
        !atRegister &&
        !atSplash &&
        !atRoleSelection &&
        !atDemoScreen) {
      return AppRoutes.splash;
    }

    if (status == AuthSessionStatus.authenticated &&
        (atLogin || atRegister || atSplash || atRoleSelection)) {
      return AppRoutes.home;
    }

    return null;
  }
}
