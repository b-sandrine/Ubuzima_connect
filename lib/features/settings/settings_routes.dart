import 'package:go_router/go_router.dart';

import '../../core/routing/app_routes.dart';
import 'presentation/pages/language_settings_page.dart';

/// Route definitions owned by the settings feature (SETTINGS-01), appended
/// into the single `GoRouter` in `core/routing/app_router.dart`.
abstract final class SettingsRoutes {
  static List<RouteBase> get routes => [
    GoRoute(
      path: AppRoutes.languageSettings,
      builder: (context, state) => const LanguageSettingsPage(),
    ),
  ];
}
