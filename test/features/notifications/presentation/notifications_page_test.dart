import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ubuzima_connect/features/notifications/data/datasources/local/patient_notifications_local_data_source.dart';
import 'package:ubuzima_connect/features/notifications/data/datasources/remote/patient_notifications_remote_data_source.dart';
import 'package:ubuzima_connect/features/notifications/data/repositories/patient_notifications_repository_impl.dart';
import 'package:ubuzima_connect/features/notifications/domain/repositories/notifications_repository.dart';
import 'package:ubuzima_connect/features/notifications/presentation/pages/notifications_page.dart';

void main() {
  NotificationsRepository? repositoryFor(NotificationsAudience audience) {
    if (audience != NotificationsAudience.patient) return null;
    return PatientNotificationsRepositoryImpl(
      PatientNotificationsRemoteDataSourceImpl(
        FakeFirebaseFirestore(),
        PatientNotificationsLocalDataSourceImpl(),
      ),
    );
  }

  for (final audience in NotificationsAudience.values) {
    testWidgets('renders the ${audience.name} notifications page', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: NotificationsPage(
            audience: audience,
            repository: repositoryFor(audience),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(NotificationsPage), findsOneWidget);

      final scrollable = find.byType(Scrollable);
      if (scrollable.evaluate().isNotEmpty) {
        await tester.drag(scrollable.first, const Offset(0, -400));
        await tester.pumpAndSettle();
      }

      expect(find.byType(NotificationsPage), findsOneWidget);
    });
  }
}
