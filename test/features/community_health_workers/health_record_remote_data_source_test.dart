import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ubuzima_connect/features/community_health_workers/data/datasources/local/health_record_local_data_source.dart';
import 'package:ubuzima_connect/features/community_health_workers/data/datasources/remote/health_record_remote_data_source.dart';

import '../../helpers/fake_clinical_ai_service.dart';

void main() {
  late FakeFirebaseFirestore firestore;
  late HealthRecordRemoteDataSourceImpl dataSource;

  setUp(() {
    firestore = FakeFirebaseFirestore();
    dataSource = HealthRecordRemoteDataSourceImpl(
      firestore,
      HealthRecordLocalDataSourceImpl(),
      const FakeClinicalAiService(),
    );
  });

  test('read seeds the record and returns the full aggregate', () async {
    final record = await dataSource.readHealthRecord();

    expect(record.patient.name, 'Marie Uwimana');
    expect(record.demographics, isNotEmpty);
    expect(record.assessment.riskScore, 62);
    expect(record.conditions.activeSymptoms, isNotEmpty);
    expect(record.nextSteps.length, 3);
  });

  test('completing a step deletes it and drops the pending count', () async {
    final before = await dataSource.readHealthRecord();

    final after = await dataSource.completeNextStep('step-bp-check');

    expect(after.nextSteps.length, before.nextSteps.length - 1);
    expect(after.nextSteps.any((s) => s.id == 'step-bp-check'), isFalse);
  });
}
