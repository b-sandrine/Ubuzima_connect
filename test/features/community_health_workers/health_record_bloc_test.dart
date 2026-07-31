import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ubuzima_connect/core/errors/failure.dart';
import 'package:ubuzima_connect/features/community_health_workers/domain/entities/health_record.dart';
import 'package:ubuzima_connect/features/community_health_workers/domain/usecases/complete_next_step.dart';
import 'package:ubuzima_connect/features/community_health_workers/domain/usecases/get_health_record.dart';
import 'package:ubuzima_connect/features/community_health_workers/domain/usecases/regenerate_ai_assessment.dart';
import 'package:ubuzima_connect/features/community_health_workers/presentation/bloc/health_record_bloc.dart';

class _MockGetHealthRecord extends Mock implements GetHealthRecord {}

class _MockCompleteNextStep extends Mock implements CompleteNextStep {}

class _MockRegenerateAiAssessment extends Mock
    implements RegenerateAiAssessment {}

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
  demographics: [DemographicRow('Phone', '+250 781 234 567')],
  assessment: HealthAssessment(
    riskScore: 62,
    riskLevel: RiskLevel.moderate,
    updatedLabel: 'Updated today',
    summary: 'Fatigue and nausea in a 24-week pregnancy.',
    keyRiskFactor: 'Pregnancy + Swelling',
    recommendation: 'ANC Visit in 3d',
  ),
  conditions: ConditionsSummary(
    activeSymptoms: [Symptom('Fatigue', SymptomTone.caution)],
    chronicConditions: [],
    specialStatus: ['Pregnant · 24w'],
  ),
  nextSteps: [
    NextStep(
      id: 'step-anc-visit',
      kind: NextStepKind.visit,
      title: 'ANC Follow-up Visit',
      detail: 'Due: 04 Jun 2025',
      badge: '3d',
    ),
  ],
);

void main() {
  late _MockGetHealthRecord getHealthRecord;
  late _MockCompleteNextStep completeNextStep;
  late _MockRegenerateAiAssessment regenerateAiAssessment;

  setUp(() {
    getHealthRecord = _MockGetHealthRecord();
    completeNextStep = _MockCompleteNextStep();
    regenerateAiAssessment = _MockRegenerateAiAssessment();
  });

  HealthRecordBloc build() => HealthRecordBloc(
    getHealthRecord,
    completeNextStep,
    regenerateAiAssessment,
  );

  blocTest<HealthRecordBloc, HealthRecordState>(
    'started loads the record and reaches ready',
    setUp: () => when(
      () => getHealthRecord(patientId: any(named: 'patientId')),
    ).thenAnswer((_) async => const Right(_record)),
    build: build,
    act: (bloc) =>
        bloc.add(const HealthRecordEvent.started(patientId: 'p1')),
    expect: () => const [
      HealthRecordState(
        status: HealthRecordStatus.loading,
        patientId: 'p1',
      ),
      HealthRecordState(
        status: HealthRecordStatus.ready,
        record: _record,
        patientId: 'p1',
      ),
    ],
  );

  blocTest<HealthRecordBloc, HealthRecordState>(
    'started surfaces the failure message when the read fails',
    setUp: () => when(
      () => getHealthRecord(patientId: any(named: 'patientId')),
    ).thenAnswer((_) async => const Left(CacheFailure('no record'))),
    build: build,
    act: (bloc) => bloc.add(const HealthRecordEvent.started()),
    expect: () => const [
      HealthRecordState(status: HealthRecordStatus.loading),
      HealthRecordState(
        status: HealthRecordStatus.failure,
        errorMessage: 'no record',
      ),
    ],
  );

  blocTest<HealthRecordBloc, HealthRecordState>(
    'tabChanged updates the selected tab',
    build: build,
    seed: () => const HealthRecordState(
      status: HealthRecordStatus.ready,
      record: _record,
    ),
    act: (bloc) => bloc.add(const HealthRecordEvent.tabChanged(2)),
    expect: () => const [
      HealthRecordState(
        status: HealthRecordStatus.ready,
        record: _record,
        selectedTab: 2,
      ),
    ],
  );

  final afterRecord = HealthRecord(
    sector: _record.sector,
    dateLabel: _record.dateLabel,
    patient: _record.patient,
    demographics: _record.demographics,
    assessment: _record.assessment,
    conditions: _record.conditions,
    nextSteps: const [],
  );

  blocTest<HealthRecordBloc, HealthRecordState>(
    'completing a step replaces the record with the returned one',
    setUp: () => when(
      () => completeNextStep(
        'step-anc-visit',
        patientId: any(named: 'patientId'),
      ),
    ).thenAnswer((_) async => Right(afterRecord)),
    build: build,
    seed: () => const HealthRecordState(
      status: HealthRecordStatus.ready,
      record: _record,
      patientId: 'p1',
    ),
    act: (bloc) =>
        bloc.add(const HealthRecordEvent.stepCompleted('step-anc-visit')),
    verify: (bloc) {
      expect(bloc.state.record?.nextSteps, isEmpty);
      verify(
        () => completeNextStep('step-anc-visit', patientId: 'p1'),
      ).called(1);
    },
  );

  final refreshed = HealthRecord(
    sector: _record.sector,
    dateLabel: _record.dateLabel,
    patient: _record.patient,
    demographics: _record.demographics,
    assessment: const HealthAssessment(
      riskScore: 71,
      riskLevel: RiskLevel.high,
      updatedLabel: 'Updated just now',
      summary: 'Refreshed AI assessment.',
      keyRiskFactor: 'Swelling',
      recommendation: 'Refer today',
    ),
    conditions: _record.conditions,
    nextSteps: _record.nextSteps,
  );

  blocTest<HealthRecordBloc, HealthRecordState>(
    'aiAssessmentRequested regenerates and updates the assessment',
    setUp: () => when(
      () => regenerateAiAssessment(patientId: any(named: 'patientId')),
    ).thenAnswer((_) async => Right(refreshed)),
    build: build,
    seed: () => const HealthRecordState(
      status: HealthRecordStatus.ready,
      record: _record,
      patientId: 'p1',
    ),
    act: (bloc) =>
        bloc.add(const HealthRecordEvent.aiAssessmentRequested()),
    expect: () => [
      const HealthRecordState(
        status: HealthRecordStatus.ready,
        record: _record,
        patientId: 'p1',
        isRefreshingAssessment: true,
      ),
      HealthRecordState(
        status: HealthRecordStatus.ready,
        record: refreshed,
        patientId: 'p1',
      ),
    ],
  );
}
