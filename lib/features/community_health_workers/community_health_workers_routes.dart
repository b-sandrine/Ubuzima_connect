import 'package:go_router/go_router.dart';

import '../../core/routing/app_routes.dart';
import 'presentation/pages/chw_referral_page.dart';

/// Route definitions owned by the community health workers feature (CHW-06b),
/// appended into the single `GoRouter` in `core/routing/app_router.dart`.
abstract final class CommunityHealthWorkersRoutes {
  static List<RouteBase> get routes => [
    GoRoute(
      path: AppRoutes.chwReferral,
      builder: (context, state) => const ChwReferralPage(),
    ),
  ];
}
