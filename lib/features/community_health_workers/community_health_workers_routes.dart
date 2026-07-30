import 'package:go_router/go_router.dart';

import '../../core/routing/app_routes.dart';
import 'presentation/pages/chw_dashboard_page.dart';
import 'presentation/pages/chw_health_record_page.dart';
import 'presentation/pages/chw_referral_page.dart';

abstract final class CommunityHealthWorkersRoutes {
  static List<RouteBase> get routes => [
    GoRoute(
      path: AppRoutes.chwDashboard,
      builder: (context, state) => const ChwDashboardPage(),
    ),
    GoRoute(
      path: AppRoutes.chwReferral,
      builder: (context, state) => const ChwReferralPage(),
    ),
    GoRoute(
      path: AppRoutes.chwHealthRecord,
      builder: (context, state) => const ChwHealthRecordPage(),
    ),
  ];
}
