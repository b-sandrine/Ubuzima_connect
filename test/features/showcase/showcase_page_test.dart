import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:ubuzima_connect/core/routing/app_routes.dart';
import 'package:ubuzima_connect/features/showcase/presentation/pages/showcase_page.dart';

void main() {
  Future<GoRouter> pump(WidgetTester tester) async {
<<<<<<< HEAD
    tester.view.physicalSize = const Size(1170, 5200);
=======
    tester.view.physicalSize = const Size(1170, 9200);
>>>>>>> 7160e82a73a43d4127d4e76ecb2d6d0b5dd7aee7
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
<<<<<<< HEAD
    expect(find.text('10 screens'), findsOneWidget);
=======
    expect(find.text('21 screens'), findsOneWidget);
>>>>>>> 7160e82a73a43d4127d4e76ecb2d6d0b5dd7aee7
    expect(find.text('Role Selection'), findsOneWidget);
    expect(find.text('Current Medications'), findsOneWidget);
    expect(find.text('Patient Timeline'), findsOneWidget);
    expect(find.text('Doctor Dashboard'), findsOneWidget);
    expect(find.text('Patient Search'), findsOneWidget);
    expect(find.text('Patient Details'), findsOneWidget);
    expect(find.text('Referral Management'), findsOneWidget);
    expect(find.text('Refer to Hospital'), findsOneWidget);
<<<<<<< HEAD
    expect(find.text('New Patient Registration'), findsOneWidget);
    expect(find.text('Consultation · Vitals'), findsOneWidget);
=======
    expect(find.text('Health Record'), findsOneWidget);
    expect(find.text('Patient Dashboard'), findsOneWidget);
    expect(find.text('Medical Records'), findsOneWidget);
    expect(find.text('Doctor Alerts'), findsOneWidget);
    expect(find.text('Patient Alerts'), findsOneWidget);
    expect(find.text('Doctor Settings'), findsOneWidget);
    expect(find.text('Patient Settings'), findsOneWidget);
>>>>>>> 7160e82a73a43d4127d4e76ecb2d6d0b5dd7aee7
  });

  testWidgets('tapping a card opens that screen', (tester) async {
    await pump(tester);

    await tester.tap(find.text('Patient Timeline'));
    await tester.pumpAndSettle();

    expect(find.text('timeline-screen'), findsOneWidget);
  });
}
