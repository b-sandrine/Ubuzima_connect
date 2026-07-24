import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ubuzima_connect/core/di/injection.dart';
import 'package:ubuzima_connect/features/prescriptions/domain/entities/medication_dose.dart';
import 'package:ubuzima_connect/features/prescriptions/domain/entities/medication_schedule.dart';
import 'package:ubuzima_connect/features/prescriptions/domain/usecases/get_today_schedule.dart';
import 'package:ubuzima_connect/features/prescriptions/domain/usecases/mark_dose_taken.dart';
import 'package:ubuzima_connect/features/prescriptions/domain/usecases/request_refill.dart';
import 'package:ubuzima_connect/features/prescriptions/presentation/bloc/medication_bloc.dart';
import 'package:ubuzima_connect/features/prescriptions/presentation/pages/patient_medications_page.dart';

class _MockGetTodaySchedule extends Mock implements GetTodaySchedule {}

class _MockMarkDoseTaken extends Mock implements MarkDoseTaken {}

class _MockRequestRefill extends Mock implements RequestRefill {}

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
  doses: [
    MedicationDose(
      id: 'amlodipine-am',
      name: 'Amlodipine',
      dosage: '5mg',
      amount: '1 tablet',
      dayPart: DayPart.morning,
      timeLabel: '7:00 AM',
      instruction: 'Taken at 7:03 AM',
      status: DoseStatus.taken,
      tags: [DoseTag.condition('Hypertension')],
    ),
    MedicationDose(
      id: 'metformin-pm',
      name: 'Metformin',
      dosage: '500mg',
      amount: '1 tablet',
      dayPart: DayPart.afternoon,
      timeLabel: '1:00 PM',
      instruction: 'With lunch',
      status: DoseStatus.dueSoon,
      tags: [DoseTag.condition('Diabetes')],
    ),
  ],
  aiInsight: 'Great adherence this month.',
);

void main() {
  late _MockGetTodaySchedule getTodaySchedule;
  late _MockMarkDoseTaken markDoseTaken;
  late _MockRequestRefill requestRefill;

  setUp(() {
    getTodaySchedule = _MockGetTodaySchedule();
    markDoseTaken = _MockMarkDoseTaken();
    requestRefill = _MockRequestRefill();

    when(
      () => getTodaySchedule(),
    ).thenAnswer((_) async => const Right(_schedule));
    when(
      () => requestRefill(),
    ).thenAnswer((_) async => Right(
          _schedule.copyWith(refill: _schedule.refill!.copyWith(requested: true)),
        ));

    getIt.registerFactory<MedicationBloc>(
      () => MedicationBloc(getTodaySchedule, markDoseTaken, requestRefill),
    );
  });

  tearDown(() => getIt.reset());

  Future<void> pump(WidgetTester tester) async {
    tester.view.physicalSize = const Size(1170, 4200);
    tester.view.devicePixelRatio = 3.0;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      const MaterialApp(home: PatientMedicationsPage()),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('renders the summary, schedule and insight', (tester) async {
    await pump(tester);

    expect(find.text('Marie Uwase'), findsOneWidget);
    expect(find.text('82%'), findsOneWidget);
    expect(find.text('Amlodipine'), findsOneWidget);
    expect(find.text('Metformin'), findsOneWidget);
    expect(find.text('AI Medication Insight'), findsOneWidget);
  });

  testWidgets('tapping Take logs the due dose', (tester) async {
    when(() => markDoseTaken('metformin-pm')).thenAnswer(
      (_) async => Right(
        _schedule.copyWith(
          doses: [
            _schedule.doses[0],
            _schedule.doses[1].copyWith(status: DoseStatus.taken),
          ],
        ),
      ),
    );

    await pump(tester);
    await tester.tap(find.text('Take'));
    await tester.pumpAndSettle();

    verify(() => markDoseTaken('metformin-pm')).called(1);
  });

  testWidgets('tapping Request refill confirms in place', (tester) async {
    await pump(tester);

    expect(find.text('Request'), findsOneWidget);
    await tester.tap(find.text('Request'));
    await tester.pumpAndSettle();

    verify(() => requestRefill()).called(1);
    expect(find.text('Requested'), findsOneWidget);
  });

  testWidgets('switching tabs shows the coming-soon placeholder', (
    tester,
  ) async {
    await pump(tester);

    await tester.tap(find.text('Prescriptions'));
    await tester.pumpAndSettle();

    expect(find.textContaining('coming soon'), findsOneWidget);
  });
}
