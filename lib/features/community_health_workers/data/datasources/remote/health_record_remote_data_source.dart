import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';

import '../../../../../core/constants/app_constants.dart';
import '../../../../../core/constants/firestore_paths.dart';
import '../../../../../core/exceptions/app_exceptions.dart';
import '../../../domain/entities/health_record.dart';
import '../local/health_record_local_data_source.dart';

/// Firestore-backed source for the CHW health record. Layout:
///
///   patients/{chwPatientId}                 → identity, demographics,
///                                             AI assessment, conditions
///   patients/{chwPatientId}/next_steps/{id} → one document per pending step
///
/// Seeded from [HealthRecordLocalDataSource] on first read. Completing a
/// next step deletes its document, which drops the pending count.
abstract interface class HealthRecordRemoteDataSource {
  Future<HealthRecord> readHealthRecord();

  Future<HealthRecord> completeNextStep(String stepId);
}

@LazySingleton(as: HealthRecordRemoteDataSource)
class HealthRecordRemoteDataSourceImpl implements HealthRecordRemoteDataSource {
  final FirebaseFirestore _firestore;
  final HealthRecordLocalDataSource _seed;

  HealthRecordRemoteDataSourceImpl(this._firestore, this._seed);

  DocumentReference<Map<String, dynamic>> get _doc =>
      _firestore.collection(FirestorePaths.patients).doc(
        AppConstants.demoChwPatientId,
      );

  CollectionReference<Map<String, dynamic>> get _steps =>
      _doc.collection('next_steps');

  @override
  Future<HealthRecord> readHealthRecord() async {
    try {
      if (!(await _doc.get()).exists) await _seedFirestore();
      return _assemble();
    } on FirebaseException catch (e) {
      throw ServerException(e.message ?? 'Could not load the health record.');
    }
  }

  @override
  Future<HealthRecord> completeNextStep(String stepId) async {
    try {
      await _steps.doc(stepId).delete();
      return _assemble();
    } on FirebaseException catch (e) {
      throw ServerException(e.message ?? 'Could not complete the step.');
    }
  }

  Future<HealthRecord> _assemble() async {
    final data = (await _doc.get()).data() ?? const {};
    final stepDocs = await _steps.orderBy('sortOrder').get();

    final assessment = (data['assessment'] as Map?)?.cast<String, dynamic>() ??
        const {};
    final conditions = (data['conditions'] as Map?)?.cast<String, dynamic>() ??
        const {};

    return HealthRecord(
      sector: data['sector'] as String? ?? '',
      dateLabel: data['dateLabel'] as String? ?? '',
      patient: HealthRecordPatient(
        name: data['patientName'] as String? ?? '',
        demographics: data['patientDemographics'] as String? ?? '',
        riskLevel: _risk(data['riskLevel'] as String?),
        recordId: data['recordId'] as String? ?? '',
        pregnancy: data['pregnancy'] as String? ?? '',
        location: data['location'] as String? ?? '',
        insurance: data['insurance'] as String? ?? '',
      ),
      demographics: ((data['demographics'] as List?) ?? const [])
          .cast<Map<String, dynamic>>()
          .map(
            (d) => DemographicRow(
              d['label'] as String? ?? '',
              d['value'] as String? ?? '',
            ),
          )
          .toList(),
      assessment: HealthAssessment(
        riskScore: (assessment['riskScore'] as num?)?.toInt() ?? 0,
        riskLevel: _risk(assessment['riskLevel'] as String?),
        updatedLabel: assessment['updatedLabel'] as String? ?? '',
        summary: assessment['summary'] as String? ?? '',
        keyRiskFactor: assessment['keyRiskFactor'] as String? ?? '',
        recommendation: assessment['recommendation'] as String? ?? '',
      ),
      conditions: ConditionsSummary(
        activeSymptoms: ((conditions['activeSymptoms'] as List?) ?? const [])
            .cast<Map<String, dynamic>>()
            .map(
              (s) => Symptom(
                s['label'] as String? ?? '',
                SymptomTone.values.byName(s['tone'] as String? ?? 'caution'),
              ),
            )
            .toList(),
        chronicConditions:
            ((conditions['chronicConditions'] as List?) ?? const [])
                .cast<String>(),
        specialStatus: ((conditions['specialStatus'] as List?) ?? const [])
            .cast<String>(),
      ),
      nextSteps: stepDocs.docs.map((d) => _stepFromMap(d.id, d.data())).toList(),
    );
  }

  NextStep _stepFromMap(String id, Map<String, dynamic> data) {
    return NextStep(
      id: id,
      kind: NextStepKind.values.byName(data['kind'] as String? ?? 'visit'),
      title: data['title'] as String? ?? '',
      detail: data['detail'] as String? ?? '',
      badge: data['badge'] as String? ?? '',
    );
  }

  RiskLevel _risk(String? value) =>
      RiskLevel.values.byName(value ?? 'moderate');

  Future<void> _seedFirestore() async {
    final record = _seed.readHealthRecord();
    final batch = _firestore.batch();

    batch.set(_doc, {
      'sector': record.sector,
      'dateLabel': record.dateLabel,
      'patientName': record.patient.name,
      'patientDemographics': record.patient.demographics,
      'riskLevel': record.patient.riskLevel.name,
      'recordId': record.patient.recordId,
      'pregnancy': record.patient.pregnancy,
      'location': record.patient.location,
      'insurance': record.patient.insurance,
      'demographics': [
        for (final row in record.demographics)
          {'label': row.label, 'value': row.value},
      ],
      'assessment': {
        'riskScore': record.assessment.riskScore,
        'riskLevel': record.assessment.riskLevel.name,
        'updatedLabel': record.assessment.updatedLabel,
        'summary': record.assessment.summary,
        'keyRiskFactor': record.assessment.keyRiskFactor,
        'recommendation': record.assessment.recommendation,
      },
      'conditions': {
        'activeSymptoms': [
          for (final s in record.conditions.activeSymptoms)
            {'label': s.label, 'tone': s.tone.name},
        ],
        'chronicConditions': record.conditions.chronicConditions,
        'specialStatus': record.conditions.specialStatus,
      },
    });

    for (var i = 0; i < record.nextSteps.length; i++) {
      final step = record.nextSteps[i];
      batch.set(_steps.doc(step.id), {
        'kind': step.kind.name,
        'title': step.title,
        'detail': step.detail,
        'badge': step.badge,
        'sortOrder': i,
      });
    }

    await batch.commit();
  }
}
