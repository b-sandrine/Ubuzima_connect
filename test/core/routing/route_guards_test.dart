import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ubuzima_connect/core/routing/app_routes.dart';
import 'package:ubuzima_connect/core/routing/auth_session.dart';
import 'package:ubuzima_connect/core/routing/route_guards.dart';

class _MockAuthSession extends Mock implements AuthSessionProvider {}

class _FakeGoRouterState extends Mock implements GoRouterState {}

GoRouterState _stateAt(String location) {
  final state = _FakeGoRouterState();
  when(() => state.matchedLocation).thenReturn(location);
  return state;
}

void main() {
  late _MockAuthSession auth;

  setUp(() => auth = _MockAuthSession());

  test('unauthenticated users are bounced to role selection', () {
    when(() => auth.currentStatus)
        .thenReturn(AuthSessionStatus.unauthenticated);

    expect(
      RouteGuards.redirect(auth, _stateAt(AppRoutes.home)),
      AppRoutes.roleSelection,
    );
  });

  test('demo-reachable screens are allowed without a session', () {
    when(() => auth.currentStatus)
        .thenReturn(AuthSessionStatus.unauthenticated);

    for (final route in AppRoutes.demoReachable) {
      expect(
        RouteGuards.redirect(auth, _stateAt(route)),
        isNull,
        reason: '$route should be reachable from the demo hub',
      );
    }
  });

  test('authenticated users on login are sent home', () {
    when(() => auth.currentStatus).thenReturn(AuthSessionStatus.authenticated);

    expect(
      RouteGuards.redirect(auth, _stateAt(AppRoutes.login)),
      AppRoutes.home,
    );
  });
}
