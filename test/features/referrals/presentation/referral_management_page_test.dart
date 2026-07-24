import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ubuzima_connect/core/di/injection.dart';
import 'package:ubuzima_connect/features/referrals/domain/entities/referral.dart';
import 'package:ubuzima_connect/features/referrals/domain/entities/referral_board.dart';
import 'package:ubuzima_connect/features/referrals/domain/usecases/accept_referral.dart';
import 'package:ubuzima_connect/features/referrals/domain/usecases/decline_referral.dart';
import 'package:ubuzima_connect/features/referrals/domain/usecases/get_referral_board.dart';
import 'package:ubuzima_connect/features/referrals/presentation/bloc/referral_board_bloc.dart';
import 'package:ubuzima_connect/features/referrals/presentation/pages/referral_management_page.dart';

class _MockGetBoard extends Mock implements GetReferralBoard {}

class _MockAccept extends Mock implements AcceptReferral {}

class _MockDecline extends Mock implements DeclineReferral {}

const _patient = ReferralPatient(
  name: 'Marie Uwase',
  id: 'RW-2847',
  summary: '52F · HTN + T2DM + CKD',
  criticality: 'Critical',
);

Referral _referral({ReferralStatus status = ReferralStatus.pending}) =>
    Referral(
      reference: 'RW-REF-0041',
      specialty: 'Cardiology',
      urgency: ReferralUrgency.urgent,
      direction: ReferralDirection.incoming,
      status: status,
      facility: 'CHC Kigali',
      receivedLabel: 'Received 08:22',
      referringPhysician: 'Dr. Nkurunziza Emmanuel',
      referringFacility: 'CHC Kigali',
      reason: 'Suspected early HF.',
      clinicalSummary: 'BP 158/96 mmHg · HR 88 bpm',
      requestedTimeline: 'Within 48 hours',
      timelineIsUrgent: true,
      routeOptions: const ['Cardiology', 'Nephrology'],
    );

void main() {
  late _MockGetBoard getBoard;
  late _MockAccept accept;
  late _MockDecline decline;

  setUp(() {
    getBoard = _MockGetBoard();
    accept = _MockAccept();
    decline = _MockDecline();

    when(() => getBoard()).thenAnswer(
      (_) async =>
          Right(ReferralBoard(patient: _patient, referrals: [_referral()])),
    );

    getIt.registerFactory<ReferralBoardBloc>(
      () => ReferralBoardBloc(getBoard, accept, decline),
    );
  });

  tearDown(() => getIt.reset());

  Future<void> pump(WidgetTester tester) async {
    tester.view.physicalSize = const Size(1170, 5200);
    tester.view.devicePixelRatio = 3.0;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      const MaterialApp(home: ReferralManagementPage()),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('renders the patient chip and referral card', (tester) async {
    await pump(tester);

    expect(find.text('Referral Management'), findsOneWidget);
    expect(find.text('Marie Uwase'), findsOneWidget);
    expect(find.text('Cardiology'), findsWidgets);
    expect(find.text('Ref #RW-REF-0041 · Received 08:22'), findsOneWidget);
    expect(find.text('Accept'), findsOneWidget);
    expect(find.text('Decline'), findsOneWidget);
  });

  testWidgets('accepting a referral calls the use case and resolves the card',
      (tester) async {
    when(
      () => accept('RW-REF-0041',
          routedSpecialty: any(named: 'routedSpecialty')),
    ).thenAnswer(
      (_) async => Right(
        ReferralBoard(
          patient: _patient,
          referrals: [_referral(status: ReferralStatus.accepted)],
        ),
      ),
    );

    await pump(tester);
    await tester.tap(find.text('Accept'));
    await tester.pumpAndSettle();

    verify(
      () => accept('RW-REF-0041',
          routedSpecialty: any(named: 'routedSpecialty')),
    ).called(1);
    expect(find.text('Accepted'), findsOneWidget);
  });

  testWidgets('the pending banner reflects the urgent count', (tester) async {
    await pump(tester);

    expect(find.text('1 Pending Referral'), findsOneWidget);
    expect(find.textContaining('1 urgent'), findsOneWidget);
  });
}
