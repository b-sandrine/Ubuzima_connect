import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'core/di/injection.dart';

/// Bring-up sequence executed once, before any widget is built: Firebase →
/// dependency injection → error-zone-wrapped `runApp`.
///
/// Kept separate from `main.dart` so flavor-specific entry points
/// (e.g. a future `main_staging.dart` / `main_production.dart`) can share
/// this exact sequence without duplicating bring-up logic.
Future<void> bootstrap(Widget Function() appBuilder) async {
  await runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();

      try {
        await Firebase.initializeApp();
      } catch (e, stackTrace) {
        // Expected until `flutterfire configure` has been run for this
        // project (no Firebase project is wired up yet) — see
        // docs/ARCHITECTURE.md for the manual setup step.
        debugPrint('Firebase.initializeApp failed: $e\n$stackTrace');
      }

      await configureDependencies();

      runApp(appBuilder());
    },
    (error, stackTrace) {
      debugPrint('Uncaught error: $error\n$stackTrace');
    },
  );
}
