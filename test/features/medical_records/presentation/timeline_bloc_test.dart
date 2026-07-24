import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ubuzima_connect/core/errors/failure.dart';
import 'package:ubuzima_connect/features/medical_records/domain/entities/patient_timeline.dart';
import 'package:ubuzima_connect/features/medical_records/domain/entities/timeline_event.dart';
import 'package:ubuzima_connect/features/medical_records/domain/usecases/get_patient_timeline.dart';
import 'package:ubuzima_connect/features/medical_records/presentation/bloc/timeline_bloc.dart';

class _MockGetTimeline extends Mock implements GetPatientTimeline {}

const _timeline = PatientTimeline(
  patient: TimelinePatient(
    name: 'Marie Uwase',
    summary: '52F · HTN + T2DM + CKD',
    criticality: 'Critical',
  ),
  trend: [
    TrendPoint(label: 'May', systolic: 168, glucose: 12.4),
    TrendPoint(label: 'Jun', systolic: 182, glucose: 13.1),
  ],
  events: [
    TimelineEvent(
      id: 'e1',
      category: EventCategory.emergency,
      title: 'Hypertensive Crisis',
      dateLabel: '1 Jun 2025',
      year: 2025,
      detail: 'BP 182/110',
    ),
    TimelineEvent(
      id: 'e2',
      category: EventCategory.diagnosis,
      title: 'CKD Stage 2 Confirmed',
      dateLabel: 'Nov 2024',
      year: 2024,
      detail: 'eGFR 44',
    ),
    TimelineEvent(
      id: 'e3',
      category: EventCategory.diagnosis,
      title: 'Type 2 Diabetes Mellitus',
      dateLabel: 'Mar 2023',
      year: 2023,
      detail: 'HbA1c 7.9%',
    ),
  ],
  aiSummary: 'Escalating dual-condition history.',
);

void main() {
  late _MockGetTimeline getTimeline;

  setUp(() => getTimeline = _MockGetTimeline());

  TimelineBloc build() => TimelineBloc(getTimeline);

  blocTest<TimelineBloc, TimelineState>(
    'started loads the timeline',
    setUp: () =>
        when(() => getTimeline()).thenAnswer((_) async => const Right(_timeline)),
    build: build,
    act: (bloc) => bloc.add(const TimelineViewEvent.started()),
    expect: () => const [
      TimelineState(status: TimelineStatus.loading),
      TimelineState(status: TimelineStatus.ready, timeline: _timeline),
    ],
  );

  blocTest<TimelineBloc, TimelineState>(
    'started surfaces a failure',
    setUp: () => when(
      () => getTimeline(),
    ).thenAnswer((_) async => const Left(ServerFailure('nope'))),
    build: build,
    act: (bloc) => bloc.add(const TimelineViewEvent.started()),
    expect: () => const [
      TimelineState(status: TimelineStatus.loading),
      TimelineState(status: TimelineStatus.failure, errorMessage: 'nope'),
    ],
  );

  blocTest<TimelineBloc, TimelineState>(
    'the Diagnoses filter keeps only diagnosis events',
    build: build,
    seed: () => const TimelineState(
      status: TimelineStatus.ready,
      timeline: _timeline,
    ),
    act: (bloc) =>
        bloc.add(const TimelineViewEvent.filterChanged(TimelineFilter.diagnoses)),
    verify: (bloc) {
      final visible = bloc.state.visibleEvents;
      expect(visible.length, 2);
      expect(
        visible.every((e) => e.category == EventCategory.diagnosis),
        isTrue,
      );
    },
  );

  blocTest<TimelineBloc, TimelineState>(
    'search narrows events across title and detail',
    build: build,
    seed: () => const TimelineState(
      status: TimelineStatus.ready,
      timeline: _timeline,
    ),
    act: (bloc) =>
        bloc.add(const TimelineViewEvent.searchChanged('diabetes')),
    verify: (bloc) {
      expect(bloc.state.visibleEvents.length, 1);
      expect(bloc.state.visibleEvents.single.id, 'e3');
    },
  );

  blocTest<TimelineBloc, TimelineState>(
    'events group by year preserving order',
    build: build,
    seed: () => const TimelineState(
      status: TimelineStatus.ready,
      timeline: _timeline,
    ),
    act: (bloc) => bloc.add(const TimelineViewEvent.searchChanged('')),
    verify: (bloc) {
      final years = bloc.state.groupedByYear.map((g) => g.year).toList();
      expect(years, [2025, 2024, 2023]);
    },
  );
}
