import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';

import '../../../../../core/constants/app_constants.dart';
import '../../../../../core/constants/firestore_paths.dart';
import '../../../../../core/exceptions/app_exceptions.dart';
import '../../../domain/models/consultation.dart';
import '../../../domain/models/patient_record.dart';
import '../../dummy/dummy_consultation_data.dart';

/// Firestore-backed store for the Consultation screen. Operates on the
/// same fixed demo patient Patient Search/Details use. Layout, nested
/// under the patient doc those screens already create:
///
///   doctors/{doctorId}/patients/{patientId}                      → the
///     patient-record fields, merged in here too so Consultation is
///     self-sufficient even if opened before Patient Search ever has been
///   doctors/{doctorId}/patients/{patientId}/consultation/active   → the
///     session start time and recorded vitals
///
/// Unlike the mock (which always reports "started 2m46s ago" relative to
/// whenever it's read), the session start time is seeded once and stored,
/// so elapsed time grows naturally across app opens like a real visit.
abstract interface class ConsultationRemoteDataSource {
  Future<Consultation> getActiveConsultation();

  Future<void> saveVitalsDraft(VitalsReading vitals);

  Future<Consultation> completeConsultation(VitalsReading vitals);
}

@LazySingleton(as: ConsultationRemoteDataSource)
class ConsultationRemoteDataSourceImpl implements ConsultationRemoteDataSource {
  final FirebaseFirestore _firestore;

  ConsultationRemoteDataSourceImpl(this._firestore);

  static const String _doctorId = AppConstants.demoDoctorId;
  static final String _patientId = DummyConsultationData.patient.id;

  DocumentReference<Map<String, dynamic>> get _patientDoc => _firestore
      .collection(FirestorePaths.doctors)
      .doc(_doctorId)
      .collection('patients')
      .doc(_patientId);

  DocumentReference<Map<String, dynamic>> get _consultationDoc =>
      _patientDoc.collection('consultation').doc('active');

  Future<void> _ensureSeeded() async {
    if ((await _consultationDoc.get()).exists) return;
    await _seedFirestore();
  }

  @override
  Future<Consultation> getActiveConsultation() async {
    try {
      await _ensureSeeded();
      final results = await Future.wait([
        _patientDoc.get(),
        _consultationDoc.get(),
      ]);
      final patientData = results[0].data() ?? const {};
      final sessionData = results[1].data() ?? const {};

      return Consultation(
        patient: _patientFromMap(patientData),
        session: ConsultationSession(
          doctorName: sessionData['doctorName'] as String? ?? '',
          visitType: sessionData['visitType'] as String? ?? '',
          startedAt: DateTime.fromMillisecondsSinceEpoch(
            (sessionData['startedAtMillis'] as num?)?.toInt() ??
                DateTime.now().millisecondsSinceEpoch,
          ),
        ),
        vitals: _vitalsFromMap(
          (sessionData['vitals'] as Map?) ?? const {},
        ),
      );
    } on FirebaseException catch (e) {
      throw ServerException(e.message ?? 'Could not load the consultation.');
    }
  }

  @override
  Future<void> saveVitalsDraft(VitalsReading vitals) async {
    try {
      await _ensureSeeded();
      await _consultationDoc.set({
        'vitals': _vitalsToMap(vitals),
      }, SetOptions(merge: true));
    } on FirebaseException catch (e) {
      throw ServerException(e.message ?? 'Could not save vitals.');
    }
  }

  @override
  Future<Consultation> completeConsultation(VitalsReading vitals) async {
    await saveVitalsDraft(vitals);
    return getActiveConsultation();
  }

  PatientRecord _patientFromMap(Map<String, dynamic> data) {
    return PatientRecord(
      id: _patientId,
      name: data['name'] as String? ?? '',
      patientCode: data['patientCode'] as String? ?? '',
      gender: data['gender'] as String? ?? '',
      age: (data['age'] as num?)?.toInt() ?? 0,
      location: data['location'] as String? ?? '',
      status: PatientRecordStatus.values.byName(
        data['status'] as String? ?? 'routine',
      ),
      tags: ((data['tags'] as List?) ?? const []).cast<String>(),
      lastActivityLabel: data['lastActivityLabel'] as String? ?? '',
      photoUrl: data['photoUrl'] as String?,
    );
  }

  Map<String, dynamic> _vitalsToMap(VitalsReading vitals) => {
    'systolicBp': vitals.systolicBp,
    'diastolicBp': vitals.diastolicBp,
    'bloodGlucose': vitals.bloodGlucose,
    'pulseRate': vitals.pulseRate,
    'weightKg': vitals.weightKg,
    'temperatureC': vitals.temperatureC,
    'spo2': vitals.spo2,
  };

  VitalsReading _vitalsFromMap(Map<dynamic, dynamic> data) => VitalsReading(
    systolicBp: (data['systolicBp'] as num?)?.toInt(),
    diastolicBp: (data['diastolicBp'] as num?)?.toInt(),
    bloodGlucose: (data['bloodGlucose'] as num?)?.toDouble(),
    pulseRate: (data['pulseRate'] as num?)?.toInt(),
    weightKg: (data['weightKg'] as num?)?.toDouble(),
    temperatureC: (data['temperatureC'] as num?)?.toDouble(),
    spo2: (data['spo2'] as num?)?.toInt(),
  );

  Future<void> _seedFirestore() async {
    final patient = DummyConsultationData.patient;
    final session = DummyConsultationData.session(DateTime.now());
    final batch = _firestore.batch();

    batch.set(_patientDoc, {
      'name': patient.name,
      'patientCode': patient.patientCode,
      'gender': patient.gender,
      'age': patient.age,
      'location': patient.location,
      'status': patient.status.name,
      'tags': patient.tags,
      'lastActivityLabel': patient.lastActivityLabel,
      'photoUrl': patient.photoUrl,
    }, SetOptions(merge: true));

    batch.set(_consultationDoc, {
      'doctorName': session.doctorName,
      'visitType': session.visitType,
      'startedAtMillis': session.startedAt.millisecondsSinceEpoch,
      'vitals': _vitalsToMap(DummyConsultationData.vitals),
    });

    await batch.commit();
  }
}
