import 'package:go_router/go_router.dart';

import '../../core/routing/app_routes.dart';
import 'presentation/pages/chw_dashboard_page.dart';
import 'presentation/pages/chw_health_record_page.dart';
import 'presentation/pages/chw_patient_list_page.dart';
import 'presentation/pages/chw_referral_page.dart';
import '../notifications/presentation/pages/notifications_page.dart';
import '../settings/presentation/pages/settings_page.dart';

abstract final class CommunityHealthWorkersRoutes {
  static List<RouteBase> get routes => [
    GoRoute(
      path: AppRoutes.chwDashboard,
      builder: (context, state) => ChwDashboardPage(),
    ),
    GoRoute(
      path: AppRoutes.chwReferral,
      builder: (context, state) => const ChwReferralPage(),
    ),
    GoRoute(
      path: AppRoutes.chwPatientList,
      builder: (context, state) => const ChwPatientListPage(),
    ),
    GoRoute(
      path: AppRoutes.chwNotifications,
      builder: (context, state) =>
          const NotificationsPage(audience: NotificationsAudience.chw),
    ),
    GoRoute(
      path: AppRoutes.chwSettings,
      builder: (context, state) =>
          const SettingsPage(audience: SettingsAudience.chw),
    ),
    GoRoute(
      path: AppRoutes.chwHealthRecord,
      builder: (context, state) => const ChwHealthRecordPage(),
    ),
    GoRoute(
      path: '${AppRoutes.chwHealthRecord}/:patientId',
      builder: (context, state) => ChwHealthRecordPage(
        patientId: state.pathParameters['patientId'],
      ),
    ),
  ];
}
