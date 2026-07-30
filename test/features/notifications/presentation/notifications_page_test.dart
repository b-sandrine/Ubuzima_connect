import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ubuzima_connect/features/notifications/presentation/pages/notifications_page.dart';

void main() {
  for (final audience in NotificationsAudience.values) {
    testWidgets('renders the ${audience.name} notifications page', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(home: NotificationsPage(audience: audience)),
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
