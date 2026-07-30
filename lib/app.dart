import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/connectivity/connectivity_cubit.dart';
import 'core/constants/app_constants.dart';
import 'core/di/injection.dart';
import 'core/localization/app_localization_delegates.dart';
import 'core/localization/locale_cubit.dart';
import 'core/routing/app_router.dart';
import 'core/theme/app_theme.dart';
import 'l10n/generated/app_localizations.dart';
import 'shared/widgets/banners/offline_banner.dart';

class UbuzimaConnectApp extends StatelessWidget {
  const UbuzimaConnectApp({super.key});

  @override
  Widget build(BuildContext context) {
    final router = getIt<AppRouter>().router;

    // Both cubits sit above MaterialApp so their state (the EN/RW/FR
    // switcher on AUTH-05, and OFFLINE-01's banner) rebuilds the whole
    // tree, not just whichever screen happens to host them.
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: getIt<LocaleCubit>()),
        BlocProvider.value(value: getIt<ConnectivityCubit>()),
      ],
      child: BlocBuilder<LocaleCubit, Locale?>(
        builder: (context, locale) {
          return MaterialApp.router(
            title: AppConstants.appName,
            debugShowCheckedModeBanner: false,
            theme: AppTheme.light,
            darkTheme: AppTheme.dark,
            themeMode: ThemeMode.system,
            locale: locale,
            routerConfig: router,
            localizationsDelegates: appLocalizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            // OFFLINE-01: one banner, wrapped around every routed screen,
            // instead of each feature remembering to add its own.
            builder: (context, child) {
              return Column(
                children: [
                  const OfflineBanner(),
                  Expanded(child: child ?? const SizedBox.shrink()),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
