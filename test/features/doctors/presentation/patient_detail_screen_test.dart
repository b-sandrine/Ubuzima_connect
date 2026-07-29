import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:ubuzima_connect/core/routing/app_routes.dart';
import 'package:ubuzima_connect/features/doctors/presentation/pages/patient_detail_screen.dart';

void main() {
  Future<void> pump(WidgetTester tester) async {
    tester.view.physicalSize = const Size(1170, 12000);
    tester.view.devicePixelRatio = 3.0;
    addTearDown(tester.view.reset);

    final router = GoRouter(
      initialLocation: AppRoutes.patientDetail,
      routes: [
        GoRoute(
          path: AppRoutes.patientDetail,
          builder: (_, _) => const PatientDetailScreen(),
        ),
      ],
    );

    await tester.pumpWidget(MaterialApp.router(routerConfig: router));
    await tester.pumpAndSettle();
  }

  testWidgets('renders the patient detail record from the mock repository', (
    tester,
  ) async {
    await pump(tester);

    expect(find.text('Marie Uwase'), findsOneWidget);
    expect(find.text('Critical'), findsOneWidget);
    expect(find.text('RISK INDICATORS'), findsOneWidget);
    expect(find.text('Cardiovascular'), findsOneWidget);
    expect(find.text('78%'), findsOneWidget);
    expect(find.text('LATEST VITALS'), findsOneWidget);
    expect(find.text('158/96'), findsOneWidget);
    expect(find.text('ALLERGIES & ALERTS'), findsOneWidget);
    expect(find.textContaining('Penicillin'), findsOneWidget);
    expect(find.text('RECENT CLINICAL NOTES'), findsOneWidget);
    expect(find.text('Dr. Habimana Eric'), findsWidgets);
    expect(find.text('CLINICAL SUMMARY CARDS'), findsOneWidget);
    expect(find.text('Current Medications'), findsOneWidget);
    expect(find.text('AI Clinical Summary'), findsOneWidget);
    expect(find.text('Full AI Panel'), findsOneWidget);
  });
}
