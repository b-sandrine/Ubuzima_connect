import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ubuzima_connect/core/ai/clinical_ai_service.dart';
import 'package:ubuzima_connect/core/di/injection.dart';
import 'package:ubuzima_connect/features/doctors/data/repositories/mock_patient_search_repository.dart';
import 'package:ubuzima_connect/features/doctors/domain/repositories/patient_search_repository.dart';
import 'package:ubuzima_connect/features/doctors/presentation/pages/patient_search_screen.dart';
import 'package:ubuzima_connect/features/doctors/presentation/widgets/patient_filter_chip.dart';

import '../../../helpers/fake_clinical_ai_service.dart';

void main() {
  setUp(() async {
    await getIt.reset();
    getIt.registerSingleton<ClinicalAiService>(const FakeClinicalAiService());
    getIt.registerSingleton<PatientSearchRepository>(
      MockPatientSearchRepository(getIt()),
    );
  });

  tearDown(() async {
    await getIt.reset();
  });

  testWidgets('renders patient search from the mock repository', (
    tester,
  ) async {
    await tester.pumpWidget(MaterialApp(home: PatientSearchScreen()));

    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    await tester.pumpAndSettle();

    expect(find.text('Patient Search'), findsOneWidget);
    expect(find.text('Total Patients'), findsOneWidget);
    expect(find.text('247'), findsOneWidget);
    expect(find.text('Critical'), findsWidgets);
    expect(find.textContaining('Test follow-up reminder'), findsOneWidget);
    expect(find.text('RECENT PATIENTS'), findsOneWidget);
    expect(find.text('Marie Uwase'), findsOneWidget);
    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Records'), findsOneWidget);
  });

  testWidgets('filtering by Critical narrows the patient list', (tester) async {
    await tester.pumpWidget(MaterialApp(home: PatientSearchScreen()));
    await tester.pumpAndSettle();

    await tester.tap(find.widgetWithText(PatientFilterChip, 'Critical'));
    await tester.pumpAndSettle();

    expect(find.text('Marie Uwase'), findsOneWidget);
    expect(find.text('Jean Mugisha'), findsNothing);
  });

  testWidgets('searching narrows the patient list by name', (tester) async {
    await tester.pumpWidget(MaterialApp(home: PatientSearchScreen()));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField), 'Kalisa');
    await tester.pumpAndSettle();

    expect(find.text('Amina Kalisa'), findsOneWidget);
    expect(find.text('Marie Uwase'), findsNothing);
  });
}
