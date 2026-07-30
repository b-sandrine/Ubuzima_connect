import 'package:go_router/go_router.dart';
import 'package:injectable/injectable.dart';

import '../../features/authentication/authentication_routes.dart';
import '../../features/authentication/presentation/pages/home_page.dart';
import '../../features/community_health_workers/community_health_workers_routes.dart';
import '../../features/doctors/doctors_routes.dart';
import '../../features/medical_records/medical_records_routes.dart';
import '../../features/patient_intake/patient_intake_routes.dart';
import '../../features/notifications/notifications_routes.dart';
import '../../features/patients/patients_routes.dart';
import '../../features/prescriptions/prescriptions_routes.dart';
import '../../features/referrals/referrals_routes.dart';
import '../../features/settings/settings_routes.dart';
import '../../features/showcase/showcase_routes.dart';
import 'app_routes.dart';
import 'auth_router_refresh.dart';
import 'auth_session.dart';
import 'pages/not_found_page.dart';
import 'route_guards.dart';

/// Single `GoRouter` instance for the whole app. Each feature contributes
/// its own routes via a `<feature>_routes.dart` exposing a
/// `List<RouteBase>` — appended below as features land. Deep links resolve
/// through this same table, so there is never a second, parallel
/// navigation stack.
@lazySingleton
class AppRouter {
  final AuthSessionProvider _authSessionProvider;
  final AuthRouterRefresh _authRouterRefresh;

  AppRouter(this._authSessionProvider, this._authRouterRefresh);

  late final GoRouter router = GoRouter(
    initialLocation: AppRoutes.showcase,
    debugLogDiagnostics: true,
    refreshListenable: _authRouterRefresh,
    redirect: (context, state) =>
        RouteGuards.redirect(_authSessionProvider, state),
    routes: [
      GoRoute(
        path: AppRoutes.home,
        builder: (context, state) => const HomePage(),
      ),
      ...AuthenticationRoutes.routes,
      ...PrescriptionsRoutes.routes,
      ...ReferralsRoutes.routes,
      ...CommunityHealthWorkersRoutes.routes,
      ...PatientIntakeRoutes.routes,
      ...MedicalRecordsRoutes.routes,
      ...PatientsRoutes.routes,
      ...NotificationsRoutes.routes,
      ...SettingsRoutes.routes,
      ...ShowcaseRoutes.routes,
      ...DoctorsRoutes.routes,
    ],
    errorBuilder: (context, state) => const NotFoundPage(),
  );
}
