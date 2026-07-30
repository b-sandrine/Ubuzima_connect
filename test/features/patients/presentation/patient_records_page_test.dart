import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ubuzima_connect/features/patients/presentation/pages/patient_records_page.dart';

void main() {
  testWidgets('renders the patient records page from the mock repository', (
    tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: PatientRecordsPage()));
    await tester.pumpAndSettle();

    expect(find.byType(PatientRecordsPage), findsOneWidget);
    expect(find.text('Marie Uwase'), findsWidgets);

    final scrollable = find.byType(Scrollable).first;
    for (var i = 0; i < 3; i++) {
      await tester.drag(scrollable, const Offset(0, -400));
      await tester.pumpAndSettle();
    }

    expect(find.byType(PatientRecordsPage), findsOneWidget);
  });
}
