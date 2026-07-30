import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ubuzima_connect/features/community_health_workers/presentation/pages/chw_dashboard_page.dart';

void main() {
  testWidgets('renders the CHW dashboard', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: ChwDashboardPage()));
    await tester.pumpAndSettle();

    expect(find.byType(ChwDashboardPage), findsOneWidget);

    final scrollable = find.byType(Scrollable);
    if (scrollable.evaluate().isNotEmpty) {
      for (var i = 0; i < 3; i++) {
        await tester.drag(scrollable.first, const Offset(0, -400));
        await tester.pumpAndSettle();
      }
    }

    expect(find.byType(ChwDashboardPage), findsOneWidget);
  });
}
