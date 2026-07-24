import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:ubuzima_connect/core/routing/app_routes.dart';
import 'package:ubuzima_connect/features/showcase/presentation/pages/showcase_page.dart';

void main() {
  Future<GoRouter> pump(WidgetTester tester) async {
    tester.view.physicalSize = const Size(1170, 4200);
    tester.view.devicePixelRatio = 3.0;
    addTearDown(tester.view.reset);

    final router = GoRouter(
      initialLocation: AppRoutes.showcase,
      routes: [
        GoRoute(
          path: AppRoutes.showcase,
          builder: (_, _) => const ShowcasePage(),
        ),
        GoRoute(
          path: AppRoutes.patientTimeline,
          builder: (_, _) => const Scaffold(body: Text('timeline-screen')),
        ),
      ],
    );

    await tester.pumpWidget(MaterialApp.router(routerConfig: router));
    await tester.pumpAndSettle();
    return router;
  }

  testWidgets('lists every delivered screen', (tester) async {
    await pump(tester);

    expect(find.text('Screen Showcase'), findsOneWidget);
    expect(find.text('5 screens'), findsOneWidget);
    expect(find.text('Role Selection'), findsOneWidget);
    expect(find.text('Current Medications'), findsOneWidget);
    expect(find.text('Patient Timeline'), findsOneWidget);
    expect(find.text('Referral Management'), findsOneWidget);
    expect(find.text('Refer to Hospital'), findsOneWidget);
  });

  testWidgets('tapping a card opens that screen', (tester) async {
    await pump(tester);

    await tester.tap(find.text('Patient Timeline'));
    await tester.pumpAndSettle();

    expect(find.text('timeline-screen'), findsOneWidget);
  });
}
