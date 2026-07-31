import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ubuzima_connect/core/di/injection.dart';
import 'package:ubuzima_connect/features/doctors/domain/repositories/doctor_dashboard_repository.dart';
import 'package:ubuzima_connect/features/doctors/presentation/pages/doctor_dashboard_screen.dart';

import '../../../helpers/fake_doctor_dashboard_repository.dart';

void main() {
  setUp(() async {
    await getIt.reset();
    getIt.registerSingleton<DoctorDashboardRepository>(
      const FakeDoctorDashboardRepository(),
    );
  });

  tearDown(() async {
    await getIt.reset();
  });

  testWidgets('renders the doctor dashboard from the mock repository', (
    tester,
  ) async {
    await tester.pumpWidget(MaterialApp(home: DoctorDashboardScreen()));

    // Loading state first.
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    await tester.pumpAndSettle();

    expect(find.text('Dr. Jean-Pierre Habimana'), findsOneWidget);
    expect(find.text('Emergency Alerts'), findsOneWidget);
    expect(find.text('2 Active'), findsOneWidget);
    expect(find.text('Critical: Marie Uwase — Ward 3B'), findsOneWidget);
    expect(find.text('Patients Today'), findsOneWidget);
    expect(find.text('14'), findsOneWidget);
    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Settings'), findsOneWidget);

    // The rest of the sections live further down the scrollable dashboard.
    final listFinder = find.byType(Scrollable).first;
    await tester.scrollUntilVisible(
      find.text("Today's Schedule"),
      300,
      scrollable: listFinder,
    );
    expect(find.text("Today's Schedule"), findsOneWidget);
    expect(find.text('Amina Kalisa'), findsOneWidget);

    await tester.scrollUntilVisible(
      find.text('Patient Queue'),
      300,
      scrollable: listFinder,
    );
    expect(find.text('Patient Queue'), findsOneWidget);

    await tester.scrollUntilVisible(
      find.text('Referral Status'),
      300,
      scrollable: listFinder,
    );
    expect(find.text('Referral Status'), findsOneWidget);

    await tester.scrollUntilVisible(
      find.text('AI Clinical Insight'),
      300,
      scrollable: listFinder,
    );
    expect(find.text('AI Clinical Insight'), findsOneWidget);
  });
}
