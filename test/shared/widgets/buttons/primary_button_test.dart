import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ubuzima_connect/shared/widgets/buttons/primary_button.dart';

void main() {
  group('PrimaryButton', () {
    testWidgets('renders label and responds to tap', (tester) async {
      var tapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PrimaryButton(
              label: 'Submit',
              onPressed: () => tapped = true,
            ),
          ),
        ),
      );

      expect(find.text('Submit'), findsOneWidget);

      await tester.tap(find.byType(PrimaryButton));
      await tester.pump();

      expect(tapped, isTrue);
    });

    testWidgets('shows a spinner and disables tap while loading', (
      tester,
    ) async {
      var tapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PrimaryButton(
              label: 'Submit',
              isLoading: true,
              onPressed: () => tapped = true,
            ),
          ),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      await tester.tap(find.byType(PrimaryButton));
      await tester.pump();

      expect(tapped, isFalse);
    });
  });
}
