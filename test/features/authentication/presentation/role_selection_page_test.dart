import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ubuzima_connect/core/routing/app_routes.dart';
import 'package:ubuzima_connect/core/di/injection.dart';
import 'package:ubuzima_connect/core/errors/failure.dart';
import 'package:ubuzima_connect/core/localization/app_localization_delegates.dart';
import 'package:ubuzima_connect/core/localization/locale_cubit.dart';
import 'package:ubuzima_connect/core/storage/local_storage_service.dart';
import 'package:ubuzima_connect/features/authentication/domain/entities/user_role.dart';
import 'package:ubuzima_connect/features/authentication/domain/usecases/get_selected_role.dart';
import 'package:ubuzima_connect/features/authentication/domain/usecases/save_selected_role.dart';
import 'package:ubuzima_connect/features/authentication/presentation/bloc/role_selection_bloc.dart';
import 'package:ubuzima_connect/features/authentication/presentation/pages/role_selection_page.dart';
import 'package:ubuzima_connect/features/authentication/presentation/widgets/role_option_card.dart';
import 'package:ubuzima_connect/l10n/generated/app_localizations.dart';
import 'package:ubuzima_connect/shared/widgets/buttons/gradient_button.dart';

class _MockGetSelectedRole extends Mock implements GetSelectedRole {}

class _MockSaveSelectedRole extends Mock implements SaveSelectedRole {}

/// The switcher only needs somewhere to write the chosen language; nothing
/// in these tests depends on it surviving a restart.
class _InMemoryLocalStorage implements LocalStorageService {
  final Map<String, Object> _values = {};

  @override
  String? getString(String key) => _values[key] as String?;

  @override
  Future<bool> setString(String key, String value) async {
    _values[key] = value;
    return true;
  }

  @override
  bool? getBool(String key) => _values[key] as bool?;

  @override
  Future<bool> setBool(String key, bool value) async {
    _values[key] = value;
    return true;
  }

  @override
  int? getInt(String key) => _values[key] as int?;

  @override
  Future<bool> setInt(String key, int value) async {
    _values[key] = value;
    return true;
  }

  @override
  Future<bool> remove(String key) async {
    _values.remove(key);
    return true;
  }
}

void main() {
  late _MockGetSelectedRole getSelectedRole;
  late _MockSaveSelectedRole saveSelectedRole;

  setUpAll(() => registerFallbackValue(UserRole.patient));

  setUp(() {
    getSelectedRole = _MockGetSelectedRole();
    saveSelectedRole = _MockSaveSelectedRole();

    when(
      () => getSelectedRole(),
    ).thenAnswer((_) async => const Right<Failure, UserRole?>(null));
    when(
      () => saveSelectedRole(any()),
    ).thenAnswer((_) async => const Right(unit));

    getIt.registerFactory<RoleSelectionBloc>(
      () => RoleSelectionBloc(getSelectedRole, saveSelectedRole),
    );
  });

  tearDown(() => getIt.reset());

  Future<void> pumpPage(WidgetTester tester) async {
    // The design is a tall phone screen; the default 800x600 test surface
    // would push the two auth buttons off-stage and make taps miss.
    tester.view.physicalSize = const Size(1080, 4000);
    tester.view.devicePixelRatio = 3.0;
    addTearDown(tester.view.reset);

    // A real router, not a bare `home:` — the page navigates on success and
    // `context.go` needs a GoRouter above it.
    final router = GoRouter(
      initialLocation: AppRoutes.roleSelection,
      routes: [
        GoRoute(
          path: AppRoutes.roleSelection,
          builder: (_, _) => const RoleSelectionPage(),
        ),
        GoRoute(
          path: AppRoutes.login,
          builder: (_, _) => const Scaffold(body: Text('login-screen')),
        ),
        GoRoute(
          path: AppRoutes.register,
          builder: (_, _) => const Scaffold(body: Text('register-screen')),
        ),
      ],
    );

    await tester.pumpWidget(
      BlocProvider(
        create: (_) => LocaleCubit(_InMemoryLocalStorage()),
        // Mirrors app.dart: the cubit sits above MaterialApp so switching
        // language rebuilds the whole tree, not just the switcher.
        child: BlocBuilder<LocaleCubit, Locale?>(
          builder: (context, locale) => MaterialApp.router(
            locale: locale,
            localizationsDelegates: appLocalizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            routerConfig: router,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('renders one card per role', (tester) async {
    await pumpPage(tester);

    expect(find.byType(RoleOptionCard), findsNWidgets(UserRole.values.length));
    expect(find.text('Community Health Worker'), findsOneWidget);
    expect(find.text('Doctor / Clinician'), findsOneWidget);
    // 'Patient' is both the card title and its badge.
    expect(find.text('Patient'), findsNWidgets(2));
  });

  testWidgets('both auth buttons stay disabled until a role is tapped', (
    tester,
  ) async {
    await pumpPage(tester);

    expect(
      tester.widget<GradientButton>(find.byType(GradientButton)).onPressed,
      isNull,
    );
    expect(
      tester
          .widget<OutlinedPillButton>(find.byType(OutlinedPillButton))
          .onPressed,
      isNull,
    );

    await tester.tap(find.text('Doctor / Clinician'));
    await tester.pump();

    expect(
      tester.widget<GradientButton>(find.byType(GradientButton)).onPressed,
      isNotNull,
    );
    expect(
      tester
          .widget<OutlinedPillButton>(find.byType(OutlinedPillButton))
          .onPressed,
      isNotNull,
    );
  });

  testWidgets('Sign In saves the role and lands on login', (tester) async {
    await pumpPage(tester);

    await tester.tap(find.text('Community Health Worker'));
    await tester.pump();
    await tester.tap(find.byType(GradientButton));
    await tester.pumpAndSettle();

    verify(() => saveSelectedRole(UserRole.communityHealthWorker)).called(1);
    expect(find.text('login-screen'), findsOneWidget);
  });

  testWidgets('Create Account saves the role and lands on register', (
    tester,
  ) async {
    await pumpPage(tester);

    await tester.tap(find.text('Patient').first);
    await tester.pump();
    await tester.tap(find.byType(OutlinedPillButton));
    await tester.pumpAndSettle();

    verify(() => saveSelectedRole(UserRole.patient)).called(1);
    expect(find.text('register-screen'), findsOneWidget);
  });

  testWidgets('the language switcher changes the app locale', (tester) async {
    await pumpPage(tester);

    await tester.tap(find.text('RW'));
    await tester.pumpAndSettle();

    expect(find.text('Community Healthcare'), findsNothing);
    expect(find.text("Ubuvuzi bw'Abaturage"), findsOneWidget);
  });
}
