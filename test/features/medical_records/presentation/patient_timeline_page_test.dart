import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ubuzima_connect/core/di/injection.dart';
import 'package:ubuzima_connect/features/medical_records/domain/entities/patient_timeline.dart';
import 'package:ubuzima_connect/features/medical_records/domain/entities/timeline_event.dart';
import 'package:ubuzima_connect/features/medical_records/domain/usecases/get_patient_timeline.dart';
import 'package:ubuzima_connect/features/medical_records/presentation/bloc/timeline_bloc.dart';
import 'package:ubuzima_connect/features/medical_records/presentation/pages/patient_timeline_page.dart';
import 'package:ubuzima_connect/features/medical_records/presentation/widgets/timeline_event_card.dart';

class _MockGetTimeline extends Mock implements GetPatientTimeline {}

const _timeline = PatientTimeline(
  patient: TimelinePatient(
    name: 'Marie Uwase',
    summary: '52F · HTN + T2DM + CKD · RW-2847',
    criticality: 'Critical',
  ),
  trend: [
    TrendPoint(label: 'Apr', systolic: 158, glucose: 10.9),
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
      detail: 'BP 182/110 · IV labetalol',
    ),
    TimelineEvent(
      id: 'e2',
      category: EventCategory.visit,
      title: 'Routine CHW Review',
      dateLabel: '12 May 2025',
      year: 2025,
      detail: 'BP 158/96 · Glucose 12.4',
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
  aiSummary: 'Escalating dual-condition history over years.',
);

void main() {
  late _MockGetTimeline getTimeline;

  setUp(() {
    getTimeline = _MockGetTimeline();
    when(
      () => getTimeline(),
    ).thenAnswer((_) async => const Right(_timeline));

    getIt.registerFactory<TimelineBloc>(() => TimelineBloc(getTimeline));
  });

  tearDown(() => getIt.reset());

  Future<void> pump(WidgetTester tester) async {
    tester.view.physicalSize = const Size(1170, 6400);
    tester.view.devicePixelRatio = 3.0;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(const MaterialApp(home: PatientTimelinePage()));
    await tester.pumpAndSettle();
  }

  testWidgets('renders the header, trend, events and analysis', (tester) async {
    await pump(tester);

    expect(find.text('Patient Timeline'), findsOneWidget);
    expect(find.text('3 Events'), findsOneWidget);
    expect(find.text('BP & Glucose Trend'), findsOneWidget);
    expect(find.text('Hypertensive Crisis'), findsOneWidget);
    expect(find.text('Type 2 Diabetes Mellitus'), findsOneWidget);
    expect(find.text('AI Timeline Analysis'), findsOneWidget);
    expect(find.byType(TimelineEventCard), findsNWidgets(3));
    // Year pills for the two distinct years present.
    expect(find.text('2025'), findsOneWidget);
    expect(find.text('2023'), findsOneWidget);
  });

  testWidgets('the Visits filter narrows the timeline', (tester) async {
    await pump(tester);

    await tester.tap(find.text('Visits'));
    await tester.pumpAndSettle();

    expect(find.byType(TimelineEventCard), findsOneWidget);
    expect(find.text('Routine CHW Review'), findsOneWidget);
    expect(find.text('Hypertensive Crisis'), findsNothing);
  });

  testWidgets('searching filters events by text', (tester) async {
    await pump(tester);

    await tester.enterText(find.byType(TextField), 'diabetes');
    await tester.pumpAndSettle();

    expect(find.text('Type 2 Diabetes Mellitus'), findsOneWidget);
    expect(find.text('Hypertensive Crisis'), findsNothing);
  });
}
