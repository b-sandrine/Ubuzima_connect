import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ubuzima_connect/features/community_health_workers/data/datasources/local/health_record_local_data_source.dart';
import 'package:ubuzima_connect/features/community_health_workers/data/datasources/remote/health_record_remote_data_source.dart';
import 'package:ubuzima_connect/features/community_health_workers/data/repositories/health_record_repository_impl.dart';

import '../../helpers/fake_clinical_ai_service.dart';

void main() {
  late HealthRecordRepositoryImpl repository;

  setUp(() {
    final remote = HealthRecordRemoteDataSourceImpl(
      FakeFirebaseFirestore(),
      HealthRecordLocalDataSourceImpl(),
      const FakeClinicalAiService(),
    );
    repository = HealthRecordRepositoryImpl(remote);
  });

  test('getHealthRecord returns the seeded record on the right', () async {
    final result = await repository.getHealthRecord();

    expect(result.isRight(), isTrue);
    result.fold(
      (_) => fail('expected a record'),
      (record) {
        expect(record.patient.name, 'Marie Uwimana');
        expect(record.nextSteps, isNotEmpty);
      },
    );
  });

  test('completeNextStep removes the step and returns the record', () async {
    await repository.getHealthRecord(); // seed
    final result = await repository.completeNextStep('step-anc-visit');

    result.fold(
      (_) => fail('expected a record'),
      (record) => expect(
        record.nextSteps.any((s) => s.id == 'step-anc-visit'),
        isFalse,
      ),
    );
  });
}
