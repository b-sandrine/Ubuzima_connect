import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ubuzima_connect/features/community_health_workers/data/repositories/chw_caseload_repository.dart';
import 'package:ubuzima_connect/features/notifications/presentation/pages/notifications_page.dart';

import '../../../helpers/fake_clinical_ai_service.dart';

void main() {
  for (final audience in NotificationsAudience.values) {
    testWidgets('renders the ${audience.name} notifications page', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: NotificationsPage(
            audience: audience,
            // The chw audience resolves its repository via GetIt in the
            // widget, which this test never configures — override it
            // directly, same as how the doctor/patient cases bypass DI too.
            repository: audience == NotificationsAudience.chw
                ? ChwCaseloadRepository(
                    FakeFirebaseFirestore(),
                    const FakeClinicalAiService(),
                  )
                : null,
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
