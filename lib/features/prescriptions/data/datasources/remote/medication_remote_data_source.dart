import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';

import '../../../../../core/constants/app_constants.dart';
import '../../../../../core/constants/firestore_paths.dart';
import '../../../../../core/exceptions/app_exceptions.dart';
import '../../../domain/entities/medication_dose.dart';
import '../../../domain/entities/medication_schedule.dart';
import '../local/medication_local_data_source.dart';

/// Firestore-backed source for PAT-03's schedule. The document layout is:
///
///   prescriptions/{patientId}            → summary, refill, AI insight
///   prescriptions/{patientId}/doses/{id} → one document per scheduled dose
///
/// On first read the demo patient's record is seeded from
/// [MedicationLocalDataSource] so the screen always has live data to work
/// against; "Take" and "Request refill" then write straight to Firestore.
abstract interface class MedicationRemoteDataSource {
  Future<MedicationSchedule> readTodaySchedule();

  Future<MedicationSchedule> markDoseTaken(String doseId);

  Future<MedicationSchedule> requestRefill();
}

@LazySingleton(as: MedicationRemoteDataSource)
class MedicationRemoteDataSourceImpl implements MedicationRemoteDataSource {
  final FirebaseFirestore _firestore;
  final MedicationLocalDataSource _seed;

  MedicationRemoteDataSourceImpl(this._firestore, this._seed);

  DocumentReference<Map<String, dynamic>> get _doc =>
      _firestore.collection(FirestorePaths.prescriptions).doc(
        AppConstants.demoPatientId,
      );

  CollectionReference<Map<String, dynamic>> get _doses =>
      _doc.collection('doses');

  @override
  Future<MedicationSchedule> readTodaySchedule() async {
    try {
      final snapshot = await _doc.get();
      if (!snapshot.exists) await _seedFirestore();
      return _assemble();
    } on FirebaseException catch (e) {
      throw ServerException(e.message ?? 'Could not load the schedule.');
    }
  }

  @override
  Future<MedicationSchedule> markDoseTaken(String doseId) async {
    try {
      final doseRef = _doses.doc(doseId);
      final dose = await doseRef.get();
      if (!dose.exists) return _assemble();
      if (dose.data()!['status'] == DoseStatus.taken.name) return _assemble();

      final timeLabel = dose.data()!['timeLabel'] as String? ?? '';
      await doseRef.update({
        'status': DoseStatus.taken.name,
        'instruction': 'Taken · $timeLabel',
      });

      final summary = (await _doc.get()).data()!;
      final total = (summary['totalToday'] as num?)?.toInt() ?? 0;
      final taken = ((summary['takenToday'] as num?)?.toInt() ?? 0) + 1;
      final adherence = total == 0
          ? 0
          : ((taken / total) * 100).round().clamp(0, 100);
      await _doc.update({'takenToday': taken, 'adherencePercent': adherence});

      return _assemble();
    } on FirebaseException catch (e) {
      throw ServerException(e.message ?? 'Could not update the dose.');
    }
  }

  @override
  Future<MedicationSchedule> requestRefill() async {
    try {
      await _doc.update({'refillRequested': true});
      return _assemble();
    } on FirebaseException catch (e) {
      throw ServerException(e.message ?? 'Could not request the refill.');
    }
  }

  /// Reads the summary document and its dose subcollection and rebuilds the
  /// [MedicationSchedule] the domain works with.
  Future<MedicationSchedule> _assemble() async {
    final summary = (await _doc.get()).data()!;
    final doseDocs = await _doses.orderBy('sortOrder').get();

    RefillReminder? refill;
    final refillMedication = summary['refillMedication'] as String?;
    if (refillMedication != null && refillMedication.isNotEmpty) {
      refill = RefillReminder(
        medication: refillMedication,
        detail: summary['refillDetail'] as String? ?? '',
        requested: summary['refillRequested'] as bool? ?? false,
      );
    }

    return MedicationSchedule(
      dateLabel: summary['dateLabel'] as String? ?? '',
      aiInsight: summary['aiInsight'] as String? ?? '',
      refill: refill,
      summary: MedicationSummary(
        patientName: summary['patientName'] as String? ?? '',
        conditionLine: summary['conditionLine'] as String? ?? '',
        adherencePercent: (summary['adherencePercent'] as num?)?.toInt() ?? 0,
        takenToday: (summary['takenToday'] as num?)?.toInt() ?? 0,
        totalToday: (summary['totalToday'] as num?)?.toInt() ?? 0,
        refillsDue: (summary['refillsDue'] as num?)?.toInt() ?? 0,
        streakDays: (summary['streakDays'] as num?)?.toInt() ?? 0,
      ),
      doses: doseDocs.docs.map((d) => _doseFromMap(d.id, d.data())).toList(),
    );
  }

  MedicationDose _doseFromMap(String id, Map<String, dynamic> data) {
    return MedicationDose(
      id: id,
      name: data['name'] as String? ?? '',
      dosage: data['dosage'] as String? ?? '',
      amount: data['amount'] as String? ?? '',
      dayPart: DayPart.values.byName(data['dayPart'] as String? ?? 'morning'),
      timeLabel: data['timeLabel'] as String? ?? '',
      instruction: data['instruction'] as String? ?? '',
      status: DoseStatus.values.byName(data['status'] as String? ?? 'pending'),
      tags: ((data['tags'] as List?) ?? const [])
          .cast<Map<String, dynamic>>()
          .map(
            (t) => DoseTag(
              t['label'] as String? ?? '',
              DoseTagKind.values.byName(
                t['kind'] as String? ?? 'instruction',
              ),
            ),
          )
          .toList(),
    );
  }

  /// Writes the canonical demo schedule into Firestore once, so the demo
  /// patient exists on a fresh project.
  Future<void> _seedFirestore() async {
    final schedule = _seed.readTodaySchedule();
    final batch = _firestore.batch();

    batch.set(_doc, {
      'patientName': schedule.summary.patientName,
      'conditionLine': schedule.summary.conditionLine,
      'adherencePercent': schedule.summary.adherencePercent,
      'takenToday': schedule.summary.takenToday,
      'totalToday': schedule.summary.totalToday,
      'refillsDue': schedule.summary.refillsDue,
      'streakDays': schedule.summary.streakDays,
      'dateLabel': schedule.dateLabel,
      'aiInsight': schedule.aiInsight,
      'refillMedication': schedule.refill?.medication ?? '',
      'refillDetail': schedule.refill?.detail ?? '',
      'refillRequested': schedule.refill?.requested ?? false,
    });

    for (var i = 0; i < schedule.doses.length; i++) {
      final dose = schedule.doses[i];
      batch.set(_doses.doc(dose.id), {
        'name': dose.name,
        'dosage': dose.dosage,
        'amount': dose.amount,
        'dayPart': dose.dayPart.name,
        'timeLabel': dose.timeLabel,
        'instruction': dose.instruction,
        'status': dose.status.name,
        'sortOrder': i,
        'tags': [
          for (final tag in dose.tags)
            {'label': tag.label, 'kind': tag.kind.name},
        ],
      });
    }

    await batch.commit();
  }
}
