import 'package:go_router/go_router.dart';

import '../../core/routing/app_routes.dart';
import 'presentation/pages/onboarding_page.dart';

/// Route definitions owned by the onboarding feature (TUTORIAL-01),
/// appended into the single `GoRouter` in `core/routing/app_router.dart`.
abstract final class OnboardingRoutes {
  static List<RouteBase> get routes => [
    GoRoute(
      path: AppRoutes.onboarding,
      builder: (context, state) => const OnboardingPage(),
    ),
  ];
}
