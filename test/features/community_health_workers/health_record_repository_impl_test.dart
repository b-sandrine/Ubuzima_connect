import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ubuzima_connect/core/errors/failure.dart';
import 'package:ubuzima_connect/core/exceptions/app_exceptions.dart';
import 'package:ubuzima_connect/features/community_health_workers/data/datasources/local/health_record_local_data_source.dart';
import 'package:ubuzima_connect/features/community_health_workers/data/repositories/health_record_repository_impl.dart';
import 'package:ubuzima_connect/features/community_health_workers/domain/entities/health_record.dart';

class _MockLocalDataSource extends Mock implements HealthRecordLocalDataSource {}

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
  late _MockLocalDataSource dataSource;
  late HealthRecordRepositoryImpl repository;

  setUp(() {
    dataSource = _MockLocalDataSource();
    repository = HealthRecordRepositoryImpl(dataSource);
  });

  test('returns the record from the data source', () async {
    when(() => dataSource.readHealthRecord()).thenReturn(_record);

    final result = await repository.getHealthRecord();

    expect(result, const Right<Failure, HealthRecord>(_record));
    verify(() => dataSource.readHealthRecord()).called(1);
  });

  test('maps a CacheException to a CacheFailure', () async {
    when(
      () => dataSource.readHealthRecord(),
    ).thenThrow(const CacheException('disk full'));

    final result = await repository.getHealthRecord();

    expect(result, const Left<Failure, HealthRecord>(CacheFailure('disk full')));
  });

  test('maps any other error to an UnexpectedFailure', () async {
    when(() => dataSource.readHealthRecord()).thenThrow(Exception('boom'));

    final result = await repository.getHealthRecord();

    expect(result.isLeft(), isTrue);
    result.fold(
      (failure) => expect(failure, isA<UnexpectedFailure>()),
      (_) => fail('expected a failure'),
    );
  });
}
