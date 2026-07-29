import 'package:go_router/go_router.dart';

import '../../core/routing/app_routes.dart';
import 'presentation/pages/patient_dashboard_screen.dart';

/// Route definitions owned by the patients feature, appended into the
/// single `GoRouter` in `core/routing/app_router.dart`.
abstract final class PatientsRoutes {
  static List<RouteBase> get routes => [
    GoRoute(
      path: AppRoutes.patientDashboard,
      builder: (context, state) => const PatientDashboardScreen(),
    ),
  ];
}
