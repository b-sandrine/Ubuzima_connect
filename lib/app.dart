import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/accessibility/accessibility_cubit.dart';
import 'core/accessibility/accessibility_settings.dart';
import 'core/connectivity/connectivity_cubit.dart';
import 'core/constants/app_constants.dart';
import 'core/di/injection.dart';
import 'core/localization/app_localization_delegates.dart';
import 'core/localization/locale_cubit.dart';
import 'core/routing/app_router.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_cubit.dart';
import 'l10n/generated/app_localizations.dart';
import 'shared/widgets/banners/offline_banner.dart';

class UbuzimaConnectApp extends StatelessWidget {
  const UbuzimaConnectApp({super.key});

  @override
  Widget build(BuildContext context) {
    final router = getIt<AppRouter>().router;

    // These cubits sit above MaterialApp so Settings' language, dark mode,
    // accessibility toggles, and OFFLINE-01's banner all rebuild the whole
    // tree, not just whichever screen happens to host them.
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: getIt<LocaleCubit>()),
        BlocProvider.value(value: getIt<ThemeCubit>()),
        BlocProvider.value(value: getIt<AccessibilityCubit>()),
        BlocProvider.value(value: getIt<ConnectivityCubit>()),
      ],
      child: BlocBuilder<LocaleCubit, Locale?>(
        builder: (context, locale) {
          return BlocBuilder<ThemeCubit, ThemeMode>(
            builder: (context, themeMode) {
              return BlocBuilder<AccessibilityCubit, AccessibilitySettings>(
                builder: (context, accessibility) {
                  return MaterialApp.router(
                    title: AppConstants.appName,
                    debugShowCheckedModeBanner: false,
                    theme: accessibility.highContrast
                        ? AppTheme.highContrastLight
                        : AppTheme.light,
                    darkTheme: accessibility.highContrast
                        ? AppTheme.highContrastDark
                        : AppTheme.dark,
                    themeMode: themeMode,
                    locale: locale,
                    routerConfig: router,
                    localizationsDelegates: appLocalizationsDelegates,
                    supportedLocales: AppLocalizations.supportedLocales,
                    // Applies the accessibility text-scale AND wraps every
                    // routed screen with OFFLINE-01's banner — both need
                    // this single builder slot, so they're combined here
                    // rather than each feature adding its own.
                    builder: (context, child) {
                      final mediaQuery = MediaQuery.of(context);
                      return MediaQuery(
                        data: mediaQuery.copyWith(
                          textScaler: TextScaler.linear(
                            accessibility.textScale,
                          ),
                        ),
                        child: Column(
                          children: [
                            const OfflineBanner(),
                            Expanded(child: child ?? const SizedBox.shrink()),
                          ],
                        ),
                      );
                    },
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
