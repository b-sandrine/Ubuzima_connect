import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ubuzima_connect/core/errors/failure.dart';
import 'package:ubuzima_connect/features/referrals/domain/entities/referral.dart';
import 'package:ubuzima_connect/features/referrals/domain/entities/referral_board.dart';
import 'package:ubuzima_connect/features/referrals/domain/usecases/accept_referral.dart';
import 'package:ubuzima_connect/features/referrals/domain/usecases/decline_referral.dart';
import 'package:ubuzima_connect/features/referrals/domain/usecases/get_referral_board.dart';
import 'package:ubuzima_connect/features/referrals/presentation/bloc/referral_board_bloc.dart';

class _MockGetBoard extends Mock implements GetReferralBoard {}

class _MockAccept extends Mock implements AcceptReferral {}

class _MockDecline extends Mock implements DeclineReferral {}

Referral _referral({
  String reference = 'RW-REF-0041',
  ReferralStatus status = ReferralStatus.pending,
}) => Referral(
  reference: reference,
  specialty: 'Cardiology',
  urgency: ReferralUrgency.urgent,
  direction: ReferralDirection.incoming,
  status: status,
  facility: 'CHC Kigali',
  receivedLabel: 'Received 08:22',
  referringPhysician: 'Dr. Nkurunziza Emmanuel',
  referringFacility: 'CHC Kigali',
  reason: 'Suspected early HF.',
  requestedTimeline: 'Within 48 hours',
  timelineIsUrgent: true,
  routeOptions: const ['Cardiology', 'Nephrology'],
);

const _patient = ReferralPatient(
  name: 'Marie Uwase',
  id: 'RW-2847',
  summary: '52F · HTN + T2DM + CKD',
  criticality: 'Critical',
);

void main() {
  late _MockGetBoard getBoard;
  late _MockAccept accept;
  late _MockDecline decline;

  setUp(() {
    getBoard = _MockGetBoard();
    accept = _MockAccept();
    decline = _MockDecline();
  });

  ReferralBoardBloc build() => ReferralBoardBloc(getBoard, accept, decline);

  final board = ReferralBoard(patient: _patient, referrals: [_referral()]);

  blocTest<ReferralBoardBloc, ReferralBoardState>(
    'started loads the board',
    setUp: () =>
        when(() => getBoard()).thenAnswer((_) async => Right(board)),
    build: build,
    act: (bloc) => bloc.add(const ReferralBoardEvent.started()),
    expect: () => [
      const ReferralBoardState(status: ReferralBoardStatus.loading),
      ReferralBoardState(status: ReferralBoardStatus.ready, board: board),
    ],
  );

  blocTest<ReferralBoardBloc, ReferralBoardState>(
    'started surfaces a failure',
    setUp: () => when(
      () => getBoard(),
    ).thenAnswer((_) async => const Left(ServerFailure('boom'))),
    build: build,
    act: (bloc) => bloc.add(const ReferralBoardEvent.started()),
    expect: () => const [
      ReferralBoardState(status: ReferralBoardStatus.loading),
      ReferralBoardState(
        status: ReferralBoardStatus.failure,
        errorMessage: 'boom',
      ),
    ],
  );

  blocTest<ReferralBoardBloc, ReferralBoardState>(
    'tabChanged flips the direction',
    build: build,
    act: (bloc) => bloc.add(const ReferralBoardEvent.tabChanged(1)),
    verify: (bloc) =>
        expect(bloc.state.direction, ReferralDirection.outgoing),
  );

  blocTest<ReferralBoardBloc, ReferralBoardState>(
    'accepting a referral marks it accepted and clears the busy flag',
    setUp: () {
      final accepted = ReferralBoard(
        patient: _patient,
        referrals: [_referral(status: ReferralStatus.accepted)],
      );
      when(
        () => accept('RW-REF-0041', routedSpecialty: any(named: 'routedSpecialty')),
      ).thenAnswer((_) async => Right(accepted));
    },
    build: build,
    seed: () =>
        ReferralBoardState(status: ReferralBoardStatus.ready, board: board),
    act: (bloc) =>
        bloc.add(const ReferralBoardEvent.accepted('RW-REF-0041')),
    expect: () => [
      isA<ReferralBoardState>().having(
        (s) => s.actioningReference,
        'busy',
        'RW-REF-0041',
      ),
      isA<ReferralBoardState>()
          .having((s) => s.actioningReference, 'busy cleared', isNull)
          .having(
            (s) => s.board!.referrals.first.status,
            'status',
            ReferralStatus.accepted,
          ),
    ],
  );

  blocTest<ReferralBoardBloc, ReferralBoardState>(
    'declining a referral marks it declined',
    setUp: () {
      final declined = ReferralBoard(
        patient: _patient,
        referrals: [_referral(status: ReferralStatus.declined)],
      );
      when(
        () => decline('RW-REF-0041'),
      ).thenAnswer((_) async => Right(declined));
    },
    build: build,
    seed: () =>
        ReferralBoardState(status: ReferralBoardStatus.ready, board: board),
    act: (bloc) =>
        bloc.add(const ReferralBoardEvent.declined('RW-REF-0041')),
    verify: (bloc) => expect(
      bloc.state.board!.referrals.first.status,
      ReferralStatus.declined,
    ),
  );
}
