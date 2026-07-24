import 'package:go_router/go_router.dart';

import '../../core/routing/app_routes.dart';
import 'presentation/pages/showcase_page.dart';

/// Route for the demo hub that lists every delivered screen.
abstract final class ShowcaseRoutes {
  static List<RouteBase> get routes => [
    GoRoute(
      path: AppRoutes.showcase,
      builder: (context, state) => const ShowcasePage(),
    ),
  ];
}
