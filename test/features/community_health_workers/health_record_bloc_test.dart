import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ubuzima_connect/core/errors/failure.dart';
import 'package:ubuzima_connect/features/community_health_workers/domain/entities/health_record.dart';
import 'package:ubuzima_connect/features/community_health_workers/domain/usecases/get_health_record.dart';
import 'package:ubuzima_connect/features/community_health_workers/presentation/bloc/health_record_bloc.dart';

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
      kind: NextStepKind.visit,
      title: 'ANC Follow-up Visit',
      detail: 'Due: 04 Jun 2025',
      badge: '3d',
    ),
  ],
);

void main() {
  late _MockGetHealthRecord getHealthRecord;

  setUp(() => getHealthRecord = _MockGetHealthRecord());

  HealthRecordBloc build() => HealthRecordBloc(getHealthRecord);

  blocTest<HealthRecordBloc, HealthRecordState>(
    'started loads the record and reaches ready',
    setUp: () => when(
      () => getHealthRecord(),
    ).thenAnswer((_) async => const Right(_record)),
    build: build,
    act: (bloc) => bloc.add(const HealthRecordEvent.started()),
    expect: () => const [
      HealthRecordState(status: HealthRecordStatus.loading),
      HealthRecordState(status: HealthRecordStatus.ready, record: _record),
    ],
  );

  blocTest<HealthRecordBloc, HealthRecordState>(
    'started surfaces the failure message when the read fails',
    setUp: () => when(
      () => getHealthRecord(),
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
}
