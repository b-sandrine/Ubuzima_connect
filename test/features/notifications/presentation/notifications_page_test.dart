import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ubuzima_connect/features/notifications/domain/models/notification_section.dart';
import 'package:ubuzima_connect/features/notifications/domain/repositories/notifications_repository.dart';
import 'package:ubuzima_connect/features/notifications/presentation/pages/notifications_page.dart';

class _FakeNotificationsRepository implements NotificationsRepository {
  const _FakeNotificationsRepository();

  @override
  Future<List<NotificationSection>> getSections() async => const [];
}

void main() {
  for (final audience in NotificationsAudience.values) {
    testWidgets('renders the ${audience.name} notifications page', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: NotificationsPage(
            audience: audience,
            repository: const _FakeNotificationsRepository(),
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
