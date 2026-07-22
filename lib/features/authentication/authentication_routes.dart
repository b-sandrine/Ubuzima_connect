import 'package:go_router/go_router.dart';

import '../../core/routing/app_routes.dart';
import 'presentation/pages/role_selection_page.dart';

/// Route definitions owned by the authentication feature, concatenated into
/// the single `GoRouter` in `core/routing/app_router.dart`.
abstract final class AuthenticationRoutes {
  static List<RouteBase> get routes => [
    GoRoute(
      path: AppRoutes.roleSelection,
      builder: (context, state) => const RoleSelectionPage(),
    ),
  ];
}
