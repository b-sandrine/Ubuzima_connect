import 'package:go_router/go_router.dart';

import '../../core/routing/app_routes.dart';
import 'presentation/pages/patient_dashboard_screen.dart';
import 'presentation/pages/patient_records_page.dart';

/// Route definitions owned by the patients feature, appended into the
/// single `GoRouter` in `core/routing/app_router.dart`.
abstract final class PatientsRoutes {
  static List<RouteBase> get routes => [
    GoRoute(
      path: AppRoutes.patientDashboard,
      builder: (context, state) => const PatientDashboardScreen(),
    ),
    GoRoute(
      path: AppRoutes.patientRecords,
      builder: (context, state) => const PatientRecordsPage(),
    ),
  ];
}
