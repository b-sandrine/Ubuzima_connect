import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ubuzima_connect/features/patients/data/datasources/local/patient_records_local_data_source.dart';
import 'package:ubuzima_connect/features/patients/data/datasources/remote/patient_records_remote_data_source.dart';
import 'package:ubuzima_connect/features/patients/data/repositories/patient_records_repository_impl.dart';
import 'package:ubuzima_connect/features/patients/presentation/pages/patient_records_page.dart';

void main() {
  testWidgets('renders the patient records page from Firestore', (
    tester,
  ) async {
    final repository = PatientRecordsRepositoryImpl(
      PatientRecordsRemoteDataSourceImpl(
        FakeFirebaseFirestore(),
        PatientRecordsLocalDataSourceImpl(),
      ),
    );

    await tester.pumpWidget(
      MaterialApp(home: PatientRecordsPage(repository: repository)),
    );
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
