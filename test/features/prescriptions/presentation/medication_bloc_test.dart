import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ubuzima_connect/core/errors/failure.dart';
import 'package:ubuzima_connect/features/prescriptions/domain/entities/medication_dose.dart';
import 'package:ubuzima_connect/features/prescriptions/domain/entities/medication_schedule.dart';
import 'package:ubuzima_connect/features/prescriptions/domain/usecases/get_today_schedule.dart';
import 'package:ubuzima_connect/features/prescriptions/domain/usecases/mark_dose_taken.dart';
import 'package:ubuzima_connect/features/prescriptions/domain/usecases/request_refill.dart';
import 'package:ubuzima_connect/features/prescriptions/presentation/bloc/medication_bloc.dart';

class _MockGetTodaySchedule extends Mock implements GetTodaySchedule {}

class _MockMarkDoseTaken extends Mock implements MarkDoseTaken {}

class _MockRequestRefill extends Mock implements RequestRefill {}

const _dose = MedicationDose(
  id: 'metformin-pm',
  name: 'Metformin',
  dosage: '500mg',
  amount: '1 tablet',
  dayPart: DayPart.afternoon,
  timeLabel: '1:00 PM',
  instruction: 'With lunch',
  status: DoseStatus.dueSoon,
  tags: [DoseTag.condition('Diabetes')],
);

const _schedule = MedicationSchedule(
  dateLabel: 'Mon, Jun 2, 2025',
  summary: MedicationSummary(
    patientName: 'Marie Uwase',
    conditionLine: 'HTN · T2DM · 3 Active Prescriptions',
    adherencePercent: 82,
    takenToday: 2,
    totalToday: 3,
    refillsDue: 1,
    streakDays: 30,
  ),
  refill: RefillReminder(
    medication: 'Metformin 500mg',
    detail: '5 tablets left · Runs out Jun 7',
  ),
  doses: [_dose],
  aiInsight: 'Great adherence.',
);

void main() {
  late _MockGetTodaySchedule getTodaySchedule;
  late _MockMarkDoseTaken markDoseTaken;
  late _MockRequestRefill requestRefill;

  setUp(() {
    getTodaySchedule = _MockGetTodaySchedule();
    markDoseTaken = _MockMarkDoseTaken();
    requestRefill = _MockRequestRefill();
  });

  MedicationBloc build() =>
      MedicationBloc(getTodaySchedule, markDoseTaken, requestRefill);

  blocTest<MedicationBloc, MedicationState>(
    'started loads the schedule',
    setUp: () => when(
      () => getTodaySchedule(),
    ).thenAnswer((_) async => const Right(_schedule)),
    build: build,
    act: (bloc) => bloc.add(const MedicationEvent.started()),
    expect: () => const [
      MedicationState(status: MedicationStatus.loading),
      MedicationState(status: MedicationStatus.ready, schedule: _schedule),
    ],
  );

  blocTest<MedicationBloc, MedicationState>(
    'started surfaces a failure message',
    setUp: () => when(
      () => getTodaySchedule(),
    ).thenAnswer((_) async => const Left(CacheFailure('disk full'))),
    build: build,
    act: (bloc) => bloc.add(const MedicationEvent.started()),
    expect: () => const [
      MedicationState(status: MedicationStatus.loading),
      MedicationState(
        status: MedicationStatus.failure,
        errorMessage: 'disk full',
      ),
    ],
  );

  blocTest<MedicationBloc, MedicationState>(
    'tabChanged moves the selected tab',
    build: build,
    act: (bloc) => bloc.add(const MedicationEvent.tabChanged(2)),
    expect: () => const [MedicationState(selectedTab: 2)],
  );

  blocTest<MedicationBloc, MedicationState>(
    'marking a dose taken swaps in the updated schedule',
    setUp: () {
      final taken = _schedule.copyWith(
        doses: [_dose.copyWith(status: DoseStatus.taken)],
        summary: _schedule.summary.copyWith(
          takenToday: 3,
          adherencePercent: 100,
        ),
      );
      when(
        () => markDoseTaken('metformin-pm'),
      ).thenAnswer((_) async => Right(taken));
    },
    build: build,
    seed: () => const MedicationState(
      status: MedicationStatus.ready,
      schedule: _schedule,
    ),
    act: (bloc) =>
        bloc.add(const MedicationEvent.doseMarkedTaken('metformin-pm')),
    verify: (_) => verify(() => markDoseTaken('metformin-pm')).called(1),
  );

  blocTest<MedicationBloc, MedicationState>(
    'requesting a refill flips the reminder to requested',
    setUp: () {
      final requested = _schedule.copyWith(
        refill: _schedule.refill!.copyWith(requested: true),
      );
      when(() => requestRefill()).thenAnswer((_) async => Right(requested));
    },
    build: build,
    seed: () => const MedicationState(
      status: MedicationStatus.ready,
      schedule: _schedule,
    ),
    act: (bloc) => bloc.add(const MedicationEvent.refillRequested()),
    expect: () => [
      isA<MedicationState>().having(
        (s) => s.schedule?.refill?.requested,
        'refill requested',
        isTrue,
      ),
    ],
  );
}
