import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ubuzima_connect/core/di/injection.dart';
import 'package:ubuzima_connect/core/errors/failure.dart';
import 'package:ubuzima_connect/features/community_health_workers/domain/entities/health_record.dart';
import 'package:ubuzima_connect/features/community_health_workers/domain/usecases/get_health_record.dart';
import 'package:ubuzima_connect/features/community_health_workers/presentation/bloc/health_record_bloc.dart';
import 'package:ubuzima_connect/features/community_health_workers/presentation/pages/chw_health_record_page.dart';
import 'package:ubuzima_connect/features/community_health_workers/presentation/widgets/next_steps_section.dart';

class _MockGetHealthRecord extends Mock implements GetHealthRecord {}

const _record = HealthRecord(
  sector: 'CHW · Kigali Sector',
  dateLabel: 'Sunday, 01 Jun 2025',
  patient: HealthRecordPatient(
    name: 'Marie Uwimana',
    demographics: 'Female · 28 years · Blood: O+',
    riskLevel: RiskLevel.moderate,
    recordId: 'RW-KGL-2025-04822',
    pregnancy: 'Pregnant · 24w',
    location: 'Gasabo, Kigali',
    insurance: 'Mutuelle',
  ),
  demographics: [
    DemographicRow('Date of Birth', '15 Mar 1997'),
    DemographicRow('Phone', '+250 781 234 567'),
  ],
  assessment: HealthAssessment(
    riskScore: 62,
    riskLevel: RiskLevel.moderate,
    updatedLabel: 'Updated today',
    summary: 'Fatigue and nausea in a 24-week pregnancy.',
    keyRiskFactor: 'Pregnancy + Swelling',
    recommendation: 'ANC Visit in 3d',
  ),
  conditions: ConditionsSummary(
    activeSymptoms: [
      Symptom('Fatigue', SymptomTone.caution),
      Symptom('Swelling', SymptomTone.watch),
    ],
    chronicConditions: [],
    specialStatus: ['Pregnant · 24w', 'COVID Vaccinated'],
  ),
  nextSteps: [
    NextStep(
      kind: NextStepKind.visit,
      title: 'ANC Follow-up Visit',
      detail: 'Due: 04 Jun 2025 · Gasabo Health Center',
      badge: '3d',
    ),
    NextStep(
      kind: NextStepKind.referral,
      title: 'Referral to Gynecologist',
      detail: 'CHUK Hospital · Pending approval',
      badge: 'Pending',
    ),
  ],
);

void main() {
  late _MockGetHealthRecord getHealthRecord;

  setUp(() {
    getHealthRecord = _MockGetHealthRecord();
    when(
      () => getHealthRecord(),
    ).thenAnswer((_) async => const Right<Failure, HealthRecord>(_record));
    getIt.registerFactory<HealthRecordBloc>(
      () => HealthRecordBloc(getHealthRecord),
    );
  });

  tearDown(() => getIt.reset());

  Future<void> pumpPage(WidgetTester tester) async {
    tester.view.physicalSize = const Size(1170, 8000);
    tester.view.devicePixelRatio = 3.0;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(const MaterialApp(home: ChwHealthRecordPage()));
    await tester.pumpAndSettle();
  }

  testWidgets('renders the patient header, demographics and sections', (
    tester,
  ) async {
    await pumpPage(tester);

    expect(find.text('Health Record'), findsOneWidget);
    expect(find.text('Marie Uwimana'), findsOneWidget);
    expect(find.text('Moderate'), findsOneWidget);
    expect(find.text('Demographics'), findsOneWidget);
    expect(find.text('15 Mar 1997'), findsOneWidget);
    expect(find.text('AI Health Assessment'), findsOneWidget);
    expect(find.text('62'), findsOneWidget);
    expect(find.text('Conditions & Symptoms'), findsOneWidget);
    expect(find.text('Next Steps'), findsOneWidget);
    expect(find.byType(NextStepsSection), findsOneWidget);
  });

  testWidgets('shows the pending count and next-step items', (tester) async {
    await pumpPage(tester);

    expect(find.text('2 Pending'), findsOneWidget);
    expect(find.text('ANC Follow-up Visit'), findsOneWidget);
    expect(find.text('Referral to Gynecologist'), findsOneWidget);
  });
}
