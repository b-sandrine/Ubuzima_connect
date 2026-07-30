import 'package:go_router/go_router.dart';

import '../../core/routing/app_routes.dart';
import 'presentation/pages/notifications_page.dart';

/// Route definitions owned by the notifications feature, appended into the
/// single `GoRouter` in `core/routing/app_router.dart`. One shared
/// [NotificationsPage] serves both routes, parameterized by audience.
abstract final class NotificationsRoutes {
  static List<RouteBase> get routes => [
    GoRoute(
      path: AppRoutes.doctorNotifications,
      builder: (context, state) =>
          const NotificationsPage(audience: NotificationsAudience.doctor),
    ),
    GoRoute(
      path: AppRoutes.patientNotifications,
      builder: (context, state) =>
          const NotificationsPage(audience: NotificationsAudience.patient),
    ),
  ];
}
