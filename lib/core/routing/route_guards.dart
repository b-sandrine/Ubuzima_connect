import 'package:go_router/go_router.dart';

import 'app_routes.dart';
import 'auth_session.dart';

/// Redirect logic applied to every navigation: unauthenticated users are
/// bounced to `/login`; authenticated users landing on `/` or `/login` are
/// sent to `/home`. Role-based redirects (e.g. a Patient hitting a
/// CHW-only path) plug in here once feature route metadata exists to
/// describe which roles a route allows.
abstract final class RouteGuards {
  static String? redirect(
    AuthSessionProvider authSessionProvider,
    GoRouterState state,
  ) {
    final status = authSessionProvider.currentStatus;
    final atLogin = state.matchedLocation == AppRoutes.login;
    final atSplash = state.matchedLocation == AppRoutes.splash;
    final atRoleSelection = state.matchedLocation == AppRoutes.roleSelection;

    // Role selection (AUTH-05) is the entry point of onboarding, so it has
    // to be reachable without a session — as does login itself.
    if (status == AuthSessionStatus.unauthenticated &&
        !atLogin &&
        !atRoleSelection) {
      return AppRoutes.roleSelection;
    }

    if (status == AuthSessionStatus.authenticated && (atLogin || atSplash)) {
      return AppRoutes.home;
    }

    return null;
  }
}
