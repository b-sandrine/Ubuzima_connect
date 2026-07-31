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
    expect(record.nextSteps.length, greaterThanOrEqualTo(3));
    expect(
      record.nextSteps.any((s) => s.id == 'ai-recommendation'),
      isTrue,
    );
    expect(record.assessment.recommendation, isNotEmpty);
  });

  test('completing a step deletes it and drops the pending count', () async {
    final before = await dataSource.readHealthRecord();

    final after = await dataSource.completeNextStep('step-bp-check');

    expect(after.nextSteps.length, before.nextSteps.length - 1);
    expect(after.nextSteps.any((s) => s.id == 'step-bp-check'), isFalse);
  });

  test('read maps a registered intake patient by id', () async {
    await firestore.collection('patients').doc('intake-1').set({
      'registeredAt': DateTime(2025, 6, 1),
      'identity': {
        'fullName': 'Amina Uwase',
        'nationalId': '1199780012345678',
        'dateOfBirth': '1997-03-15T00:00:00.000',
        'gender': 'female',
        'phone': '+250781111111',
      },
      'household': {
        'province': 'Kigali',
        'district': 'Gasabo',
        'sector': 'Remera',
        'cell': 'Rukiri',
        'village': 'Gisimenti',
      },
      'contact': {'primaryPhone': '+250781111111'},
      'demographics': {'insurance': 'mutuelle', 'occupation': 'Teacher'},
      'location': {},
      'symptoms': {
        'reported': ['fatigue', 'nausea'],
        'additionalNotes': '',
      },
      'riskScreening': {
        'chronicConditions': [],
        'pregnancyStatus': 'pregnant',
        'vaccinationStatus': 'fullyVaccinated',
      },
      'riskAssessment': {'score': 55, 'level': 'moderate'},
    });

    final record = await dataSource.readHealthRecord(patientId: 'intake-1');

    expect(record.patient.name, 'Amina Uwase');
    expect(record.patient.recordId, 'intake-1');
    expect(record.patient.location, 'Gasabo, Kigali');
    expect(record.patient.pregnancy, 'Pregnant');
    expect(record.assessment.riskScore, 62); // AI fills when empty summary
    expect(record.conditions.activeSymptoms.map((s) => s.label), [
      'Fatigue',
      'Nausea',
    ]);
    expect(
      record.demographics.any((r) => r.label == 'Phone'),
      isTrue,
    );
  });

  test('read throws when a non-demo patient id is missing', () async {
    expect(
      () => dataSource.readHealthRecord(patientId: 'missing-id'),
      throwsA(isA<Exception>()),
    );
  });

  test('regenerateAiAssessment forces a fresh assessment', () async {
    final first = await dataSource.readHealthRecord();
    expect(first.assessment.summary, isNotEmpty);

    final refreshed = await dataSource.regenerateAiAssessment();

    expect(refreshed.assessment.summary, isNotEmpty);
    expect(refreshed.assessment.updatedLabel, 'Updated just now');
    expect(refreshed.assessment.riskScore, 62);
  });
}
