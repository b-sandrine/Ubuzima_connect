import 'package:go_router/go_router.dart';

import '../../core/routing/app_routes.dart';
import 'presentation/pages/doctor_dashboard_screen.dart';

/// Route definitions owned by the doctors feature, appended into the single
/// `GoRouter` in `core/routing/app_router.dart`.
abstract final class DoctorsRoutes {
  static List<RouteBase> get routes => [
    GoRoute(
      path: AppRoutes.doctorDashboard,
      builder: (context, state) => const DoctorDashboardScreen(),
    ),
  ];
}
