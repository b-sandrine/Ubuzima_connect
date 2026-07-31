import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ubuzima_connect/core/ai/clinical_ai_service.dart';
import 'package:ubuzima_connect/core/di/injection.dart';
import 'package:ubuzima_connect/features/patients/data/repositories/mock_patient_dashboard_repository.dart';
import 'package:ubuzima_connect/features/patients/domain/repositories/patient_dashboard_repository.dart';
import 'package:ubuzima_connect/features/patients/presentation/pages/patient_dashboard_screen.dart';

import '../../../helpers/fake_clinical_ai_service.dart';

void main() {
  setUp(() async {
    await getIt.reset();
    getIt.registerSingleton<ClinicalAiService>(const FakeClinicalAiService());
    getIt.registerSingleton<PatientDashboardRepository>(
      MockPatientDashboardRepository(getIt()),
    );
  });

  tearDown(() async {
    await getIt.reset();
  });

  testWidgets('renders the patient dashboard from the mock repository', (
    tester,
  ) async {
    await tester.pumpWidget(MaterialApp(home: PatientDashboardScreen()));

    // The mock repository delays 400ms, so the loading state shows first.
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    await tester.pumpAndSettle();

    expect(find.byType(PatientDashboardScreen), findsOneWidget);
    expect(find.text('Marie Uwase'), findsWidgets);

    // Scroll through the dashboard so the lower cards build and render.
    final scrollable = find.byType(Scrollable).first;
    for (var i = 0; i < 4; i++) {
      await tester.drag(scrollable, const Offset(0, -400));
      await tester.pumpAndSettle();
    }

    expect(find.byType(PatientDashboardScreen), findsOneWidget);
  });
}
