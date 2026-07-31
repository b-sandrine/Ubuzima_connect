import 'package:go_router/go_router.dart';

import 'app_routes.dart';
import 'auth_session.dart';
import 'role_home.dart';

/// Redirect logic applied to every navigation: unauthenticated users are
/// bounced to the welcome screen; authenticated users landing on onboarding
/// routes are sent to `/home`. Role-based redirects plug in here once
/// feature route metadata describes which roles a route allows.
abstract final class RouteGuards {
  static const Set<String> _patientRoutes = {AppRoutes.patientMedications};

  static const Set<String> _doctorRoutes = {
    AppRoutes.referralManagement,
    AppRoutes.newReferral,
    AppRoutes.patientTimeline,
    AppRoutes.doctorDashboard,
    AppRoutes.patientSearch,
  };

  static const Set<String> _chwRoutes = {
    AppRoutes.chwDashboard,
    AppRoutes.chwReferral,
    AppRoutes.chwPatientList,
    AppRoutes.chwNotifications,
    AppRoutes.chwSettings,
  };

  static String? redirect(
    AuthSessionProvider authSessionProvider,
    GoRouterState state,
  ) {
    final status = authSessionProvider.currentStatus;
    final role = authSessionProvider.currentRole;
    final location = state.matchedLocation;
    final atLogin = location == AppRoutes.login;
    final atRegister = location == AppRoutes.register;
    final atReset = location == AppRoutes.resetPassword;
    final atSplash = location == AppRoutes.splash;
    final atRoleSelection = location == AppRoutes.roleSelection;
    final atOnboarding = location == AppRoutes.onboarding;
    final atDemoScreen =
        AppRoutes.demoReachable.contains(location) ||
        AppRoutes.isChwHealthRecord(location);

    if (status == AuthSessionStatus.unauthenticated &&
        !atLogin &&
        !atRegister &&
        !atReset &&
        !atSplash &&
        !atRoleSelection &&
        !atOnboarding &&
        !atDemoScreen) {
      return AppRoutes.splash;
    }

    if (status == AuthSessionStatus.authenticated &&
        (atLogin || atRegister || atReset || atSplash || atRoleSelection)) {
      // Stay on role selection until a concrete role is known — avoids the
      // `/home` spinner loop when role is still resolving.
      if (role == UserRole.unknown && atRoleSelection) {
        return null;
      }
      return _defaultAuthorizedRouteFor(role);
    }

    if (status == AuthSessionStatus.authenticated &&
        location == AppRoutes.home &&
        role == UserRole.unknown) {
      return null; // HomePage waits for role, then navigates.
    }

    if (status == AuthSessionStatus.authenticated &&
        !_isAuthorized(role: role, location: location)) {
      return _defaultAuthorizedRouteFor(role);
    }

    return null;
  }

  static bool _isAuthorized({
    required UserRole role,
    required String location,
  }) {
    if (_patientRoutes.contains(location)) {
      return role == UserRole.patient;
    }
    if (_doctorRoutes.contains(location)) {
      return role == UserRole.doctor;
    }
    if (_chwRoutes.contains(location) ||
        AppRoutes.isChwHealthRecord(location)) {
      return role == UserRole.communityHealthWorker;
    }
    return true;
  }

  static String _defaultAuthorizedRouteFor(UserRole role) {
    return RoleHome.forRole(role);
  }
}
