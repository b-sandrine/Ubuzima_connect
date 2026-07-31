import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ubuzima_connect/core/routing/app_routes.dart';
import 'package:ubuzima_connect/core/routing/auth_session.dart';
import 'package:ubuzima_connect/core/routing/onboarding_status.dart';
import 'package:ubuzima_connect/core/routing/role_home.dart';
import 'package:ubuzima_connect/core/routing/route_guards.dart';

class _MockAuthSession extends Mock implements AuthSessionProvider {}

class _MockOnboardingStatus extends Mock implements OnboardingStatusProvider {}

class _FakeGoRouterState extends Mock implements GoRouterState {}

GoRouterState _stateAt(String location) {
  final state = _FakeGoRouterState();
  when(() => state.matchedLocation).thenReturn(location);
  return state;
}

void main() {
  late _MockAuthSession auth;
  late _MockOnboardingStatus onboarding;

  setUp(() {
    auth = _MockAuthSession();
    onboarding = _MockOnboardingStatus();
    // The guard reads the role on every redirect; default it here so tests
    // that don't care about the role still stub it. Individual tests override.
    when(() => auth.currentRole).thenReturn(UserRole.unknown);
    // Most tests aren't exercising the onboarding gate, so default it to
    // already-complete; the dedicated tests below override this.
    when(() => onboarding.isComplete).thenReturn(true);
  });

  String? redirect(String location) =>
      RouteGuards.redirect(auth, onboarding, _stateAt(location));

  test('unauthenticated users are bounced to welcome', () {
    when(() => auth.currentStatus)
        .thenReturn(AuthSessionStatus.unauthenticated);

    expect(redirect(AppRoutes.home), AppRoutes.splash);
  });

  test('welcome and role selection are reachable without a session', () {
    when(() => auth.currentStatus)
        .thenReturn(AuthSessionStatus.unauthenticated);

    expect(redirect(AppRoutes.splash), isNull);
    expect(redirect(AppRoutes.roleSelection), isNull);
  });

  test('demo-reachable screens are allowed without a session', () {
    when(() => auth.currentStatus)
        .thenReturn(AuthSessionStatus.unauthenticated);

    for (final route in AppRoutes.demoReachable) {
      expect(
        redirect(route),
        isNull,
        reason: '$route should be reachable from the demo hub',
      );
    }
  });

  test('authenticated users on login are sent to their role home', () {
    when(() => auth.currentStatus).thenReturn(AuthSessionStatus.authenticated);
    when(() => auth.currentRole).thenReturn(UserRole.doctor);

    expect(redirect(AppRoutes.login), RoleHome.forRole(UserRole.doctor));
  });

  test(
    'unauthenticated users are bounced to onboarding when it is not complete',
    () {
      when(() => auth.currentStatus)
          .thenReturn(AuthSessionStatus.unauthenticated);
      when(() => onboarding.isComplete).thenReturn(false);

      expect(redirect(AppRoutes.roleSelection), AppRoutes.onboarding);
      expect(redirect(AppRoutes.login), AppRoutes.onboarding);
    },
  );

  test(
    'splash, onboarding itself, and demo-reachable screens stay open even '
    'when onboarding is not complete',
    () {
      when(() => auth.currentStatus)
          .thenReturn(AuthSessionStatus.unauthenticated);
      when(() => onboarding.isComplete).thenReturn(false);

      expect(redirect(AppRoutes.splash), isNull);
      expect(redirect(AppRoutes.onboarding), isNull);
      for (final route in AppRoutes.demoReachable) {
        expect(redirect(route), isNull, reason: '$route should stay open');
      }
    },
  );
}
