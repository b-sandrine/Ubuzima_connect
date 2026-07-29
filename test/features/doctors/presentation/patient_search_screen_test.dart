import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ubuzima_connect/features/doctors/presentation/pages/patient_search_screen.dart';
import 'package:ubuzima_connect/features/doctors/presentation/widgets/patient_filter_chip.dart';

void main() {
  testWidgets('renders patient search from the mock repository', (
    tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: PatientSearchScreen()));

    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    await tester.pumpAndSettle();

    expect(find.text('Patient Search'), findsOneWidget);
    expect(find.text('Total Patients'), findsOneWidget);
    expect(find.text('247'), findsOneWidget);
    expect(find.text('Critical'), findsWidgets);
    expect(find.textContaining('5 patients overdue'), findsOneWidget);
    expect(find.text('RECENT PATIENTS'), findsOneWidget);
    expect(find.text('Marie Uwase'), findsOneWidget);
    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Records'), findsOneWidget);
  });

  testWidgets('filtering by Critical narrows the patient list', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: PatientSearchScreen()));
    await tester.pumpAndSettle();

    await tester.tap(find.widgetWithText(PatientFilterChip, 'Critical'));
    await tester.pumpAndSettle();

    expect(find.text('Marie Uwase'), findsOneWidget);
    expect(find.text('Jean Mugisha'), findsNothing);
  });

  testWidgets('searching narrows the patient list by name', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: PatientSearchScreen()));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField), 'Kalisa');
    await tester.pumpAndSettle();

    expect(find.text('Amina Kalisa'), findsOneWidget);
    expect(find.text('Marie Uwase'), findsNothing);
  });
}
