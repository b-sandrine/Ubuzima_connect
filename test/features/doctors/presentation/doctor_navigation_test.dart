import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:ubuzima_connect/core/di/injection.dart';
import 'package:ubuzima_connect/core/routing/app_routes.dart';
import 'package:ubuzima_connect/features/doctors/domain/repositories/doctor_dashboard_repository.dart';
import 'package:ubuzima_connect/features/doctors/domain/repositories/patient_detail_repository.dart';
import 'package:ubuzima_connect/features/doctors/domain/repositories/patient_search_repository.dart';
import 'package:ubuzima_connect/features/doctors/presentation/pages/doctor_dashboard_screen.dart';
import 'package:ubuzima_connect/features/doctors/presentation/pages/patient_detail_screen.dart';
import 'package:ubuzima_connect/features/doctors/presentation/pages/patient_search_screen.dart';

import '../../../helpers/fake_doctor_dashboard_repository.dart';
import '../../../helpers/fake_patient_detail_repository.dart';
import '../../../helpers/fake_patient_search_repository.dart';

void main() {
  setUp(() async {
    await getIt.reset();
    getIt.registerSingleton<DoctorDashboardRepository>(
      const FakeDoctorDashboardRepository(),
    );
    getIt.registerSingleton<PatientSearchRepository>(
      const FakePatientSearchRepository(),
    );
    getIt.registerSingleton<PatientDetailRepository>(
      const FakePatientDetailRepository(),
    );
  });

  tearDown(() async {
    await getIt.reset();
  });

  Future<GoRouter> pump(WidgetTester tester) async {
    final router = GoRouter(
      initialLocation: AppRoutes.doctorDashboard,
      routes: [
        GoRoute(
          path: AppRoutes.doctorDashboard,
          builder: (_, _) => DoctorDashboardScreen(),
        ),
        GoRoute(
          path: AppRoutes.patientSearch,
          builder: (_, _) => PatientSearchScreen(),
        ),
        GoRoute(
          path: AppRoutes.patientDetail,
          builder: (_, _) => PatientDetailScreen(),
        ),
        GoRoute(
          path: AppRoutes.referralManagement,
          builder: (_, _) =>
              const Scaffold(body: Text('referral-management-screen')),
        ),
        GoRoute(
          path: AppRoutes.newReferral,
          builder: (_, _) => const Scaffold(body: Text('new-referral-screen')),
        ),
        GoRoute(
          path: AppRoutes.patientTimeline,
          builder: (_, _) =>
              const Scaffold(body: Text('patient-timeline-screen')),
        ),
      ],
    );

    await tester.pumpWidget(MaterialApp.router(routerConfig: router));
    await tester.pumpAndSettle();
    return router;
  }

  testWidgets('tapping Records in the bottom nav opens Patient Search', (
    tester,
  ) async {
    await pump(tester);
    expect(find.text('Dr. Jean-Pierre Habimana'), findsOneWidget);

    await tester.tap(find.text('Records'));
    await tester.pumpAndSettle();

    expect(find.text('Patient Search'), findsOneWidget);
  });

  testWidgets('tapping Home from Patient Search returns to the dashboard', (
    tester,
  ) async {
    final router = await pump(tester);
    router.go(AppRoutes.patientSearch);
    await tester.pumpAndSettle();
    expect(find.text('Patient Search'), findsOneWidget);

    await tester.tap(find.text('Home'));
    await tester.pumpAndSettle();

    expect(find.text('Dr. Jean-Pierre Habimana'), findsOneWidget);
  });

  testWidgets('Quick Access Search opens Patient Search', (tester) async {
    await pump(tester);

    await tester.scrollUntilVisible(
      find.text('Search'),
      300,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(find.text('Search'));
    await tester.pumpAndSettle();

    expect(find.text('Patient Search'), findsOneWidget);
  });

  testWidgets('Referral Status View All opens referral management', (
    tester,
  ) async {
    await pump(tester);

    await tester.scrollUntilVisible(
      find.text('View All'),
      300,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(find.text('View All'));
    await tester.pumpAndSettle();

    expect(find.text('referral-management-screen'), findsOneWidget);
  });

  testWidgets('tapping a patient card opens Patient Details', (tester) async {
    final router = await pump(tester);
    router.go(AppRoutes.patientSearch);
    await tester.pumpAndSettle();

    await tester.tap(find.text('Marie Uwase'));
    await tester.pumpAndSettle();

    expect(find.text('RISK INDICATORS'), findsOneWidget);

    await tester.scrollUntilVisible(
      find.text('AI Clinical Summary'),
      300,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.text('AI Clinical Summary'), findsOneWidget);
  });

  testWidgets('the back button on Patient Details returns to Patient Search', (
    tester,
  ) async {
    final router = await pump(tester);
    router.go(AppRoutes.patientSearch);
    await tester.pumpAndSettle();
    router.push(AppRoutes.patientDetail);
    await tester.pumpAndSettle();
    expect(find.text('RISK INDICATORS'), findsOneWidget);

    final backButton = find.byWidgetPredicate(
      (widget) => widget is Icon && widget.icon == LucideIcons.arrowLeft,
    );
    await tester.tap(backButton);
    await tester.pumpAndSettle();

    expect(find.text('Patient Search'), findsOneWidget);
  });

  testWidgets('History on Patient Details opens the patient timeline', (
    tester,
  ) async {
    final router = await pump(tester);
    router.go(AppRoutes.patientDetail);
    await tester.pumpAndSettle();

    await tester.tap(find.text('History'));
    await tester.pumpAndSettle();

    expect(find.text('patient-timeline-screen'), findsOneWidget);
  });

  testWidgets('Refer on Patient Details opens the new referral form', (
    tester,
  ) async {
    final router = await pump(tester);
    router.go(AppRoutes.patientDetail);
    await tester.pumpAndSettle();

    await tester.tap(find.text('Refer'));
    await tester.pumpAndSettle();

    expect(find.text('new-referral-screen'), findsOneWidget);
  });
}
