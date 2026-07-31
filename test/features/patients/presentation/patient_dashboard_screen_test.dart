import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ubuzima_connect/features/patients/data/datasources/local/patient_dashboard_local_data_source.dart';
import 'package:ubuzima_connect/features/patients/data/datasources/remote/patient_dashboard_remote_data_source.dart';
import 'package:ubuzima_connect/features/patients/data/repositories/patient_dashboard_repository_impl.dart';
import 'package:ubuzima_connect/features/patients/presentation/pages/patient_dashboard_screen.dart';

void main() {
  testWidgets('renders the patient dashboard from Firestore', (tester) async {
    final repository = PatientDashboardRepositoryImpl(
      PatientDashboardRemoteDataSourceImpl(
        FakeFirebaseFirestore(),
        PatientDashboardLocalDataSourceImpl(),
      ),
    );

    await tester.pumpWidget(
      MaterialApp(home: PatientDashboardScreen(repository: repository)),
    );

    // The Firestore seed round-trip resolves asynchronously, so the loading
    // state shows first.
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
