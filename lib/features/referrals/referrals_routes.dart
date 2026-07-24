import 'package:go_router/go_router.dart';

import '../../core/routing/app_routes.dart';
import 'presentation/pages/new_referral_page.dart';
import 'presentation/pages/referral_management_page.dart';

/// Route definitions owned by the referrals feature (DOC-06), appended into
/// the single `GoRouter` in `core/routing/app_router.dart`. CHW-06b's route
/// is added separately by that feature's work.
abstract final class ReferralsRoutes {
  static List<RouteBase> get routes => [
    GoRoute(
      path: AppRoutes.referralManagement,
      builder: (context, state) => const ReferralManagementPage(),
    ),
    GoRoute(
      path: AppRoutes.newReferral,
      builder: (context, state) => const NewReferralPage(),
    ),
  ];
}
