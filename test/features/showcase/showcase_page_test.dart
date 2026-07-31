import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:ubuzima_connect/core/routing/app_routes.dart';
import 'package:ubuzima_connect/features/showcase/presentation/pages/showcase_page.dart';

void main() {
  Future<GoRouter> pump(WidgetTester tester) async {
<<<<<<< HEAD
    tester.view.physicalSize = const Size(1170, 10400);
=======
    tester.view.physicalSize = const Size(1170, 9800);
>>>>>>> 2742935 (integrated patient list)
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

<<<<<<< HEAD
    expect(find.text('Screen Showcase'), findsOneWidget);
    expect(find.text('24 screens'), findsOneWidget);
    expect(find.text('Role Selection'), findsOneWidget);
    expect(find.text('Current Medications'), findsOneWidget);
    expect(find.text('Patient Timeline'), findsOneWidget);
    expect(find.text('Doctor Dashboard'), findsOneWidget);
    expect(find.text('Patient Search'), findsOneWidget);
    expect(find.text('Patient Details'), findsOneWidget);
    expect(find.text('Referral Management'), findsOneWidget);
    expect(find.text('Refer to Hospital'), findsOneWidget);
    expect(find.text('New Patient Registration'), findsOneWidget);
    expect(find.text('Consultation · Vitals'), findsOneWidget);
    expect(find.text('Health Record'), findsOneWidget);
    expect(find.text('Patient Dashboard'), findsOneWidget);
    expect(find.text('AI Insights'), findsOneWidget);
    expect(find.text('Medical Records'), findsOneWidget);
    expect(find.text('Doctor Alerts'), findsOneWidget);
    expect(find.text('Patient Alerts'), findsOneWidget);
    expect(find.text('Doctor Settings'), findsOneWidget);
    expect(find.text('Patient Settings'), findsOneWidget);
=======
    Finder text(String value) => find.text(value, skipOffstage: false);

    expect(text('Screen Showcase'), findsOneWidget);
    expect(text('24 screens'), findsOneWidget);
    expect(text('Role Selection'), findsOneWidget);
    expect(text('Current Medications'), findsOneWidget);
    expect(text('Patient Timeline'), findsOneWidget);
    expect(text('Doctor Dashboard'), findsOneWidget);
    expect(text('Patient Search'), findsOneWidget);
    expect(text('Patient Details'), findsOneWidget);
    expect(text('Referral Management'), findsOneWidget);
    expect(text('Refer to Hospital'), findsOneWidget);
    expect(text('New Patient Registration'), findsOneWidget);
    expect(text('Consultation · Vitals'), findsOneWidget);
    expect(text('Health Record'), findsOneWidget);
    expect(text('CHW Patient List'), findsOneWidget);
    expect(text('Patient Dashboard'), findsOneWidget);
    expect(text('Medical Records'), findsOneWidget);
    expect(text('Doctor Alerts'), findsOneWidget);
    expect(text('Patient Alerts'), findsOneWidget);
    expect(text('Doctor Settings'), findsOneWidget);
    expect(text('Patient Settings'), findsOneWidget);
>>>>>>> 2742935 (integrated patient list)
  });

  testWidgets('tapping a card opens that screen', (tester) async {
    await pump(tester);

    await tester.tap(find.text('Patient Timeline'));
    await tester.pumpAndSettle();

    expect(find.text('timeline-screen'), findsOneWidget);
  });
}
