import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ubuzima_connect/core/routing/app_routes.dart';
import 'package:ubuzima_connect/core/di/injection.dart';
import 'package:ubuzima_connect/core/errors/failure.dart';
import 'package:ubuzima_connect/features/authentication/domain/entities/user_role.dart';
import 'package:ubuzima_connect/features/authentication/domain/usecases/get_selected_role.dart';
import 'package:ubuzima_connect/features/authentication/domain/usecases/save_selected_role.dart';
import 'package:ubuzima_connect/features/authentication/presentation/bloc/role_selection_bloc.dart';
import 'package:ubuzima_connect/features/authentication/presentation/pages/role_selection_page.dart';
import 'package:ubuzima_connect/features/authentication/presentation/widgets/role_option_card.dart';
import 'package:ubuzima_connect/l10n/generated/app_localizations.dart';
import 'package:ubuzima_connect/shared/widgets/buttons/primary_button.dart';

class _MockGetSelectedRole extends Mock implements GetSelectedRole {}

class _MockSaveSelectedRole extends Mock implements SaveSelectedRole {}

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
      ],
    );

    await tester.pumpWidget(
      MaterialApp.router(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        routerConfig: router,
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('renders one card per role', (tester) async {
    await pumpPage(tester);

    expect(find.byType(RoleOptionCard), findsNWidgets(UserRole.values.length));
    expect(find.text('Patient'), findsOneWidget);
    expect(find.text('Community Health Worker'), findsOneWidget);
    expect(find.text('Doctor'), findsOneWidget);
  });

  testWidgets('Continue is disabled until a role is tapped', (tester) async {
    await pumpPage(tester);

    final button = tester.widget<PrimaryButton>(find.byType(PrimaryButton));
    expect(button.onPressed, isNull);

    await tester.tap(find.text('Doctor'));
    await tester.pump();

    final enabled = tester.widget<PrimaryButton>(find.byType(PrimaryButton));
    expect(enabled.onPressed, isNotNull);
  });

  testWidgets('tapping a role then Continue saves it and moves on', (
    tester,
  ) async {
    await pumpPage(tester);

    await tester.tap(find.text('Community Health Worker'));
    await tester.pump();
    await tester.tap(find.byType(PrimaryButton));
    await tester.pumpAndSettle();

    verify(() => saveSelectedRole(UserRole.communityHealthWorker)).called(1);
    expect(find.text('login-screen'), findsOneWidget);
  });
}
