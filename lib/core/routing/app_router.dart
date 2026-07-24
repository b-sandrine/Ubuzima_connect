import 'package:go_router/go_router.dart';
import 'package:injectable/injectable.dart';

import '../../features/authentication/authentication_routes.dart';
import '../../features/community_health_workers/community_health_workers_routes.dart';
import '../../features/medical_records/medical_records_routes.dart';
import '../../features/prescriptions/prescriptions_routes.dart';
import '../../features/referrals/referrals_routes.dart';
import 'app_routes.dart';
import 'auth_session.dart';
import 'pages/not_found_page.dart';
import 'pages/placeholder_page.dart';
import 'pages/splash_page.dart';
import 'route_guards.dart';

/// Single `GoRouter` instance for the whole app. Each feature contributes
/// its own routes via a `<feature>_routes.dart` exposing a
/// `List<RouteBase>` — appended below as features land. Deep links resolve
/// through this same table, so there is never a second, parallel
/// navigation stack.
@lazySingleton
class AppRouter {
  final AuthSessionProvider _authSessionProvider;

  AppRouter(this._authSessionProvider);

  late final GoRouter router = GoRouter(
    initialLocation: AppRoutes.splash,
    debugLogDiagnostics: true,
    redirect: (context, state) =>
        RouteGuards.redirect(_authSessionProvider, state),
    routes: [
      GoRoute(
        path: AppRoutes.splash,
        builder: (context, state) => const SplashPage(),
      ),
      GoRoute(
        path: AppRoutes.login,
        builder: (context, state) => const PlaceholderPage(title: 'Login'),
      ),
      GoRoute(
        path: AppRoutes.register,
        builder: (context, state) =>
            const PlaceholderPage(title: 'Create Account'),
      ),
      GoRoute(
        path: AppRoutes.home,
        builder: (context, state) => const PlaceholderPage(title: 'Home'),
      ),
      ...AuthenticationRoutes.routes,
      ...PrescriptionsRoutes.routes,
      ...ReferralsRoutes.routes,
      ...CommunityHealthWorkersRoutes.routes,
      ...MedicalRecordsRoutes.routes,
      // Further feature route contributions are appended here, e.g.:
      //   ...PatientsRoutes.routes,
      //   ...AppointmentsRoutes.routes,
    ],
    errorBuilder: (context, state) => const NotFoundPage(),
  );
}
