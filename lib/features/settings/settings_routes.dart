import 'package:go_router/go_router.dart';

import '../../core/routing/app_routes.dart';
import 'presentation/pages/language_settings_page.dart';
import 'presentation/pages/settings_page.dart';

/// Route definitions owned by the settings feature, appended into the
/// single `GoRouter` in `core/routing/app_router.dart`. One shared
/// [SettingsPage] serves both role routes, parameterized by audience.
abstract final class SettingsRoutes {
  static List<RouteBase> get routes => [
    GoRoute(
      path: AppRoutes.languageSettings,
      builder: (context, state) => const LanguageSettingsPage(),
    ),
    GoRoute(
      path: AppRoutes.doctorSettings,
      builder: (context, state) =>
          const SettingsPage(audience: SettingsAudience.doctor),
    ),
    GoRoute(
      path: AppRoutes.patientSettings,
      builder: (context, state) =>
          const SettingsPage(audience: SettingsAudience.patient),
    ),
  ];
}
