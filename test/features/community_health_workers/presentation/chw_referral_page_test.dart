import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ubuzima_connect/core/di/injection.dart';
import 'package:ubuzima_connect/features/community_health_workers/presentation/pages/chw_referral_page.dart';
import 'package:ubuzima_connect/features/referrals/domain/entities/referral_draft.dart';
import 'package:ubuzima_connect/features/referrals/domain/usecases/create_referral.dart';
import 'package:ubuzima_connect/features/referrals/presentation/bloc/referral_form_bloc.dart';

class _MockCreateReferral extends Mock implements CreateReferral {}

class _FakeDraft extends Fake implements ReferralDraft {}

void main() {
  late _MockCreateReferral createReferral;

  setUpAll(() => registerFallbackValue(_FakeDraft()));

  setUp(() {
    createReferral = _MockCreateReferral();
    getIt.registerFactory<ReferralFormBloc>(
      () => ReferralFormBloc(createReferral),
    );
  });

  tearDown(() => getIt.reset());

  Future<void> pump(WidgetTester tester) async {
    tester.view.physicalSize = const Size(1170, 5600);
    tester.view.devicePixelRatio = 3.0;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(const MaterialApp(home: ChwReferralPage()));
    await tester.pumpAndSettle();
  }

  testWidgets('renders the CHW referral form with hospital destinations', (
    tester,
  ) async {
    await pump(tester);

    expect(find.text('Refer to Hospital'), findsOneWidget);
    expect(find.text('CHW · Kigali Sector'), findsOneWidget);
    expect(find.text('Muhima District Hospital'), findsOneWidget);
    expect(find.text('Emergency'), findsOneWidget);
    expect(find.text('Send to Hospital'), findsOneWidget);
  });

  testWidgets('completing the form submits and confirms the reference', (
    tester,
  ) async {
    when(
      () => createReferral(any()),
    ).thenAnswer((_) async => const Right('RW-REF-0042'));

    await pump(tester);

    await tester.enterText(find.byType(TextFormField).first, 'Jean Uwera');
    await tester.tap(find.text('Muhima District Hospital'));
    await tester.pump();
    await tester.tap(find.text('Emergency'));
    await tester.pump();
    await tester.enterText(
      find.byType(TextFormField).at(1),
      'Severe pre-eclampsia, BP 170/110',
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Send to Hospital'));
    await tester.pumpAndSettle();

    verify(() => createReferral(any())).called(1);
    expect(find.text('Referral submitted'), findsOneWidget);
    expect(find.textContaining('RW-REF-0042'), findsOneWidget);
  });
}
