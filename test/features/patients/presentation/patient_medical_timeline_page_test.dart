import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ubuzima_connect/core/di/injection.dart';
import 'package:ubuzima_connect/features/medical_records/domain/entities/patient_timeline.dart';
import 'package:ubuzima_connect/features/medical_records/domain/entities/timeline_event.dart';
import 'package:ubuzima_connect/features/medical_records/domain/usecases/get_patient_timeline.dart';
import 'package:ubuzima_connect/features/medical_records/presentation/bloc/timeline_bloc.dart';
import 'package:ubuzima_connect/features/medical_records/presentation/widgets/timeline_event_card.dart';
import 'package:ubuzima_connect/features/patients/presentation/pages/patient_medical_timeline_page.dart';

class _MockGetTimeline extends Mock implements GetPatientTimeline {}

const _timeline = PatientTimeline(
  totalEvents: 24,
  earlierCount: 6,
  aiViewLabel: '7-year view',
  patient: TimelinePatient(
    name: 'Marie Uwase',
    summary: '52F · HTN + T2DM + CKD · RW-2847',
    criticality: 'Critical',
    careHistory: '7 yrs',
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
  ],
  aiSummary: 'Escalating dual-condition history over years.',
);

void main() {
  late _MockGetTimeline getTimeline;

  setUp(() {
    getTimeline = _MockGetTimeline();
    when(() => getTimeline()).thenAnswer((_) async => const Right(_timeline));
    getIt.registerFactory<TimelineBloc>(() => TimelineBloc(getTimeline));
  });

  tearDown(() => getIt.reset());

  testWidgets('renders the patient medical timeline from the bloc', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1170, 6400);
    tester.view.devicePixelRatio = 3.0;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      const MaterialApp(home: PatientMedicalTimelinePage()),
    );
    await tester.pumpAndSettle();

    expect(find.byType(PatientMedicalTimelinePage), findsOneWidget);
    expect(find.byType(TimelineEventCard), findsWidgets);
    expect(find.text('Hypertensive Crisis'), findsOneWidget);
  });
}
