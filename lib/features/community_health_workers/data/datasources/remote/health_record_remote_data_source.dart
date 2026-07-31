import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';
import 'package:intl/intl.dart';

import '../../../../../core/ai/clinical_ai_service.dart';
import '../../../../../core/constants/app_constants.dart';
import '../../../../../core/constants/firestore_paths.dart';
import '../../../../../core/exceptions/app_exceptions.dart';
import '../../../domain/entities/health_record.dart';
import '../local/health_record_local_data_source.dart';

/// Firestore-backed source for the CHW health record. Layout:
///
///   patients/{patientId}                 → identity / demographics / assessment
///   patients/{patientId}/next_steps/{id} → one document per pending step
///
/// Supports both intake registrations (nested `identity` schema) and the
/// flat demo health-record docs. Demo seeding only runs for the demo patient
/// id when that document is missing.
abstract interface class HealthRecordRemoteDataSource {
  Future<HealthRecord> readHealthRecord({String? patientId});

  Future<HealthRecord> completeNextStep(String stepId, {String? patientId});

  /// Forces a fresh Gemini assessment for the patient, even if one exists.
  Future<HealthRecord> regenerateAiAssessment({String? patientId});
}

@LazySingleton(as: HealthRecordRemoteDataSource)
class HealthRecordRemoteDataSourceImpl implements HealthRecordRemoteDataSource {
  final FirebaseFirestore _firestore;
  final HealthRecordLocalDataSource _seed;
  final ClinicalAiService _ai;

  HealthRecordRemoteDataSourceImpl(this._firestore, this._seed, this._ai);

  String _resolveId(String? patientId) {
    final id = patientId?.trim();
    if (id == null || id.isEmpty) return AppConstants.demoChwPatientId;
    return id;
  }

  DocumentReference<Map<String, dynamic>> _doc(String patientId) =>
      _firestore.collection(FirestorePaths.patients).doc(patientId);

  CollectionReference<Map<String, dynamic>> _steps(String patientId) =>
      _doc(patientId).collection('next_steps');

  @override
  Future<HealthRecord> readHealthRecord({String? patientId}) async {
    final id = _resolveId(patientId);
    try {
      final snap = await _doc(id).get();
      if (!snap.exists) {
        if (id == AppConstants.demoChwPatientId) {
          await _seedFirestore(id);
        } else {
          throw const ServerException('Patient record not found.');
        }
      }
      final record = await _assemble(id);
      return _ensureAiAssessment(id, record);
    } on ServerException {
      rethrow;
    } on FirebaseException catch (e) {
      throw ServerException(e.message ?? 'Could not load the health record.');
    }
  }

  @override
  Future<HealthRecord> completeNextStep(
    String stepId, {
    String? patientId,
  }) async {
    final id = _resolveId(patientId);
    try {
      await _steps(id).doc(stepId).delete();
      return _assemble(id);
    } on FirebaseException catch (e) {
      throw ServerException(e.message ?? 'Could not complete the step.');
    }
  }

  @override
  Future<HealthRecord> regenerateAiAssessment({String? patientId}) async {
    final id = _resolveId(patientId);
    try {
      final snap = await _doc(id).get();
      if (!snap.exists) {
        throw const ServerException('Patient record not found.');
      }
      final record = await _assemble(id);
      return _applyAiAssessment(id, record);
    } on ServerException {
      rethrow;
    } on FirebaseException catch (e) {
      throw ServerException(
        e.message ?? 'Could not refresh the AI assessment.',
      );
    }
  }

  Future<HealthRecord> _assemble(String patientId) async {
    final data = (await _doc(patientId).get()).data() ?? const {};
    final stepDocs = await _steps(patientId).orderBy('sortOrder').get();
    final nextSteps =
        stepDocs.docs.map((d) => _stepFromMap(d.id, d.data())).toList();

    if (data.containsKey('identity')) {
      return _fromIntakeDoc(patientId, data, nextSteps);
    }
    return _fromFlatDoc(data, nextSteps);
  }

  HealthRecord _fromFlatDoc(
    Map<String, dynamic> data,
    List<NextStep> nextSteps,
  ) {
    final assessment =
        (data['assessment'] as Map?)?.cast<String, dynamic>() ?? const {};
    final conditions =
        (data['conditions'] as Map?)?.cast<String, dynamic>() ?? const {};

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
      nextSteps: nextSteps,
    );
  }

  HealthRecord _fromIntakeDoc(
    String patientId,
    Map<String, dynamic> data,
    List<NextStep> nextSteps,
  ) {
    final identity =
        (data['identity'] as Map?)?.cast<String, dynamic>() ?? const {};
    final household =
        (data['household'] as Map?)?.cast<String, dynamic>() ?? const {};
    final contact =
        (data['contact'] as Map?)?.cast<String, dynamic>() ?? const {};
    final demographics =
        (data['demographics'] as Map?)?.cast<String, dynamic>() ?? const {};
    final location =
        (data['location'] as Map?)?.cast<String, dynamic>() ?? const {};
    final symptoms =
        (data['symptoms'] as Map?)?.cast<String, dynamic>() ?? const {};
    final screening =
        (data['riskScreening'] as Map?)?.cast<String, dynamic>() ?? const {};
    final risk =
        (data['riskAssessment'] as Map?)?.cast<String, dynamic>() ?? const {};
    final assessmentMap =
        (data['assessment'] as Map?)?.cast<String, dynamic>() ?? const {};

    final name = identity['fullName'] as String? ?? '';
    final gender = _titleCase(identity['gender'] as String?);
    final dobRaw = identity['dateOfBirth'] as String?;
    final dob = dobRaw != null ? DateTime.tryParse(dobRaw) : null;
    final age = _ageYears(dob);
    final phone = _firstNonEmpty([
      contact['primaryPhone'] as String?,
      identity['phone'] as String?,
    ]);
    final district = household['district'] as String? ?? '';
    final province = household['province'] as String? ?? '';
    final sector = household['sector'] as String? ?? '';
    final insurance = _titleCase(demographics['insurance'] as String?);
    final pregnancyStatus = screening['pregnancyStatus'] as String?;
    final vaccination = screening['vaccinationStatus'] as String?;
    final chronic =
        ((screening['chronicConditions'] as List?) ?? const []).cast<String>();
    final reported =
        ((symptoms['reported'] as List?) ?? const []).cast<String>();
    final riskLevel = _risk(
      assessmentMap['riskLevel'] as String? ?? risk['level'] as String?,
    );
    final riskScore =
        (assessmentMap['riskScore'] as num?)?.toInt() ??
        (risk['score'] as num?)?.toInt() ??
        0;

    final demogLine = [
      if (gender.isNotEmpty) gender,
      if (age != null) '$age years',
    ].join(' · ');

    final locationLabel = [
      if (district.isNotEmpty) district,
      if (province.isNotEmpty) province,
    ].join(', ');

    final pregnancyLabel = _pregnancyLabel(pregnancyStatus);
    final specialStatus = <String>[
      if (pregnancyLabel.isNotEmpty) pregnancyLabel,
      if (vaccination != null && vaccination.isNotEmpty)
        _titleCase(vaccination.replaceAll('_', ' ')),
    ];

    final registered = data['registeredAt'];
    final dateLabel = registered is Timestamp
        ? DateFormat('EEEE, dd MMM yyyy').format(registered.toDate())
        : DateFormat('EEEE, dd MMM yyyy').format(DateTime.now());

    final sectorLabel = sector.isNotEmpty
        ? 'CHW · $sector Sector'
        : (province.isNotEmpty ? 'CHW · $province' : 'CHW');

    final demographicRows = <DemographicRow>[
      if (dob != null)
        DemographicRow('Date of Birth', DateFormat('dd MMM yyyy').format(dob)),
      if (phone != null) DemographicRow('Phone', phone),
      if ((identity['nationalId'] as String?)?.isNotEmpty == true)
        DemographicRow('National ID', identity['nationalId'] as String),
      if ((contact['emergencyContactName'] as String?)?.isNotEmpty == true)
        DemographicRow(
          'Emergency contact',
          contact['emergencyContactName'] as String,
        ),
      if ((contact['emergencyContactPhone'] as String?)?.isNotEmpty == true)
        DemographicRow(
          'Emergency phone',
          contact['emergencyContactPhone'] as String,
        ),
      if ((demographics['maritalStatus'] as String?)?.isNotEmpty == true)
        DemographicRow(
          'Marital status',
          _titleCase(demographics['maritalStatus'] as String),
        ),
      if ((demographics['occupation'] as String?)?.isNotEmpty == true)
        DemographicRow('Occupation', demographics['occupation'] as String),
      if ((household['village'] as String?)?.isNotEmpty == true)
        DemographicRow('Village', household['village'] as String),
      if ((household['cell'] as String?)?.isNotEmpty == true)
        DemographicRow('Cell', household['cell'] as String),
      if ((location['streetAddress'] as String?)?.isNotEmpty == true)
        DemographicRow('Address', location['streetAddress'] as String),
      if ((location['nearestLandmark'] as String?)?.isNotEmpty == true)
        DemographicRow('Landmark', location['nearestLandmark'] as String),
      if ((symptoms['additionalNotes'] as String?)?.isNotEmpty == true)
        DemographicRow('Notes', symptoms['additionalNotes'] as String),
    ];

    return HealthRecord(
      sector: sectorLabel,
      dateLabel: dateLabel,
      patient: HealthRecordPatient(
        name: name,
        demographics: demogLine,
        riskLevel: riskLevel,
        recordId: patientId,
        pregnancy: pregnancyLabel,
        location: locationLabel,
        insurance: insurance,
      ),
      demographics: demographicRows,
      assessment: HealthAssessment(
        riskScore: riskScore,
        riskLevel: riskLevel,
        updatedLabel: assessmentMap['updatedLabel'] as String? ?? '',
        summary: assessmentMap['summary'] as String? ?? '',
        keyRiskFactor: assessmentMap['keyRiskFactor'] as String? ?? '',
        recommendation: assessmentMap['recommendation'] as String? ?? '',
      ),
      conditions: ConditionsSummary(
        activeSymptoms: [
          for (final s in reported)
            if (s.trim().isNotEmpty)
              Symptom(_titleCase(s.replaceAll('_', ' ')), SymptomTone.caution),
        ],
        chronicConditions: [
          for (final c in chronic)
            if (c.trim().isNotEmpty) _titleCase(c.replaceAll('_', ' ')),
        ],
        specialStatus: specialStatus,
      ),
      nextSteps: nextSteps,
    );
  }

  Future<HealthRecord> _ensureAiAssessment(
    String patientId,
    HealthRecord record,
  ) async {
    final data = (await _doc(patientId).get()).data() ?? const {};
    final alreadyGenerated = data['aiGenerated'] == true;
    final hasSummary = record.assessment.summary.trim().isNotEmpty;
    if (alreadyGenerated && hasSummary) return record;
    return _applyAiAssessment(patientId, record);
  }

  Future<HealthRecord> _applyAiAssessment(
    String patientId,
    HealthRecord record,
  ) async {
    final doc = _doc(patientId);
    final raw = (await doc.get()).data() ?? const {};
    final clinicalContext = _buildClinicalContext(patientId, record, raw);

    final generated = await _ai.generateChwAssessment(
      clinicalContext: clinicalContext,
    );
    final assessment = HealthAssessment(
      riskScore: generated.riskScore,
      riskLevel: _risk(generated.riskLevel),
      updatedLabel: 'Updated just now',
      summary: generated.summary,
      keyRiskFactor: generated.keyRiskFactor,
      recommendation: generated.recommendation,
    );

    await doc.set({
      'riskLevel': assessment.riskLevel.name,
      'assessment': {
        'riskScore': assessment.riskScore,
        'riskLevel': assessment.riskLevel.name,
        'updatedLabel': assessment.updatedLabel,
        'summary': assessment.summary,
        'keyRiskFactor': assessment.keyRiskFactor,
        'recommendation': assessment.recommendation,
      },
      'aiGenerated': true,
      'aiGeneratedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));

    await _upsertRecommendationStep(
      patientId: patientId,
      assessment: assessment,
    );

    return _assemble(patientId);
  }

  String _buildClinicalContext(
    String patientId,
    HealthRecord record,
    Map<String, dynamic> raw,
  ) {
    final risk =
        (raw['riskAssessment'] as Map?)?.cast<String, dynamic>() ?? const {};
    final screening =
        (raw['riskScreening'] as Map?)?.cast<String, dynamic>() ?? const {};
    final symptoms =
        (raw['symptoms'] as Map?)?.cast<String, dynamic>() ?? const {};
    final flags = ((raw['emergencyFlags'] as List?) ?? const []).cast<String>();

    final buffer = StringBuffer()
      ..writeln('Patient ID: $patientId')
      ..writeln('Patient: ${record.patient.name}')
      ..writeln('Demographics: ${record.patient.demographics}')
      ..writeln('Pregnancy: ${record.patient.pregnancy}')
      ..writeln('Location: ${record.patient.location}')
      ..writeln('Insurance: ${record.patient.insurance}')
      ..writeln(
        'Intake risk score: ${(risk['score'] as num?)?.toInt() ?? record.assessment.riskScore}',
      )
      ..writeln(
        'Intake risk level: ${risk['level'] ?? record.patient.riskLevel.name}',
      );

    if (flags.isNotEmpty) {
      buffer.writeln('Emergency flags: ${flags.join(', ')}');
    } else {
      buffer.writeln('Emergency flags: none');
    }

    final pregnancyStatus = screening['pregnancyStatus'] as String?;
    if (pregnancyStatus != null && pregnancyStatus.isNotEmpty) {
      buffer.writeln('Pregnancy status: $pregnancyStatus');
    }
    final vaccination = screening['vaccinationStatus'] as String?;
    if (vaccination != null && vaccination.isNotEmpty) {
      buffer.writeln('Vaccination status: $vaccination');
    }

    buffer.writeln('Symptoms:');
    final reported = ((symptoms['reported'] as List?) ?? const []).cast<String>();
    if (reported.isEmpty) {
      for (final s in record.conditions.activeSymptoms) {
        buffer.writeln('- ${s.label} (${s.tone.name})');
      }
      if (record.conditions.activeSymptoms.isEmpty) {
        buffer.writeln('- none recorded');
      }
    } else {
      for (final s in reported) {
        buffer.writeln('- $s');
      }
    }
    final duration = symptoms['duration'] as String?;
    if (duration != null && duration.isNotEmpty) {
      buffer.writeln('Symptom duration: $duration');
    }
    final notes = symptoms['additionalNotes'] as String?;
    if (notes != null && notes.trim().isNotEmpty) {
      buffer.writeln('Notes: $notes');
    }

    buffer
      ..writeln(
        'Chronic: ${record.conditions.chronicConditions.isEmpty ? 'none' : record.conditions.chronicConditions.join(', ')}',
      )
      ..writeln(
        'Special status: ${record.conditions.specialStatus.isEmpty ? 'none' : record.conditions.specialStatus.join(', ')}',
      )
      ..writeln('Demographics detail:');
    for (final row in record.demographics) {
      buffer.writeln('- ${row.label}: ${row.value}');
    }
    buffer.writeln('Pending next steps:');
    if (record.nextSteps.isEmpty) {
      buffer.writeln('- none');
    } else {
      for (final step in record.nextSteps) {
        buffer.writeln('- ${step.title}: ${step.detail} [${step.badge}]');
      }
    }
    return buffer.toString();
  }

  Future<void> _upsertRecommendationStep({
    required String patientId,
    required HealthAssessment assessment,
  }) async {
    final kind = switch (assessment.riskLevel) {
      RiskLevel.critical || RiskLevel.high => NextStepKind.referral,
      RiskLevel.moderate => NextStepKind.visit,
      RiskLevel.low => NextStepKind.check,
    };
    final badge = switch (assessment.riskLevel) {
      RiskLevel.critical => 'Today',
      RiskLevel.high => '24h',
      RiskLevel.moderate => '3d',
      RiskLevel.low => '7d',
    };

    await _steps(patientId).doc('ai-recommendation').set({
      'kind': kind.name,
      'title': assessment.recommendation,
      'detail': assessment.summary,
      'badge': badge,
      'sortOrder': 0,
      'source': 'ai',
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
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

  String _titleCase(String? value) {
    if (value == null || value.isEmpty) return '';
    return '${value[0].toUpperCase()}${value.substring(1)}';
  }

  String? _firstNonEmpty(List<String?> values) {
    for (final v in values) {
      if (v != null && v.trim().isNotEmpty) return v.trim();
    }
    return null;
  }

  int? _ageYears(DateTime? dob) {
    if (dob == null) return null;
    final now = DateTime.now();
    var age = now.year - dob.year;
    if (now.month < dob.month ||
        (now.month == dob.month && now.day < dob.day)) {
      age--;
    }
    return age < 0 ? null : age;
  }

  String _pregnancyLabel(String? status) {
    if (status == null || status.isEmpty || status == 'notPregnant') {
      return '';
    }
    if (status == 'pregnant') return 'Pregnant';
    return _titleCase(status.replaceAll('_', ' '));
  }

  Future<void> _seedFirestore(String patientId) async {
    final record = _seed.readHealthRecord();
    final batch = _firestore.batch();
    final doc = _doc(patientId);
    final steps = _steps(patientId);

    batch.set(doc, {
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
        'riskScore': 0,
        'riskLevel': record.patient.riskLevel.name,
        'updatedLabel': '',
        'summary': '',
        'keyRiskFactor': '',
        'recommendation': '',
      },
      'aiGenerated': false,
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
      batch.set(steps.doc(step.id), {
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
