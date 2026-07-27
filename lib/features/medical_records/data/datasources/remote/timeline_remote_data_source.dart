import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';

import '../../../../../core/constants/app_constants.dart';
import '../../../../../core/constants/firestore_paths.dart';
import '../../../../../core/exceptions/app_exceptions.dart';
import '../../../domain/entities/patient_timeline.dart';
import '../../../domain/entities/timeline_event.dart';
import '../local/timeline_local_data_source.dart';

/// Firestore-backed source for DOC-04's timeline. Layout:
///
///   medical_records/{patientId}             → patient header, trend, AI note
///   medical_records/{patientId}/events/{id} → one document per timeline event
///
/// Seeded from [TimelineLocalDataSource] on first read.
abstract interface class TimelineRemoteDataSource {
  Future<PatientTimeline> readTimeline();
}

@LazySingleton(as: TimelineRemoteDataSource)
class TimelineRemoteDataSourceImpl implements TimelineRemoteDataSource {
  final FirebaseFirestore _firestore;
  final TimelineLocalDataSource _seed;

  TimelineRemoteDataSourceImpl(this._firestore, this._seed);

  DocumentReference<Map<String, dynamic>> get _doc => _firestore
      .collection(FirestorePaths.medicalRecords)
      .doc(AppConstants.demoPatientId);

  CollectionReference<Map<String, dynamic>> get _events =>
      _doc.collection('events');

  @override
  Future<PatientTimeline> readTimeline() async {
    try {
      if (!(await _doc.get()).exists) await _seedFirestore();
      return _assemble();
    } on FirebaseException catch (e) {
      throw ServerException(e.message ?? 'Could not load the timeline.');
    }
  }

  Future<PatientTimeline> _assemble() async {
    final data = (await _doc.get()).data() ?? const {};
    final eventDocs = await _events.orderBy('sortOrder').get();

    return PatientTimeline(
      patient: TimelinePatient(
        name: data['patientName'] as String? ?? '',
        summary: data['patientSummary'] as String? ?? '',
        criticality: data['criticality'] as String? ?? '',
        careHistory: data['careHistory'] as String? ?? '',
      ),
      totalEvents: (data['totalEvents'] as num?)?.toInt() ?? 0,
      earlierCount: (data['earlierCount'] as num?)?.toInt() ?? 0,
      aiViewLabel: data['aiViewLabel'] as String? ?? '',
      aiSummary: data['aiSummary'] as String? ?? '',
      trend: ((data['trend'] as List?) ?? const [])
          .cast<Map<String, dynamic>>()
          .map(
            (t) => TrendPoint(
              label: t['label'] as String? ?? '',
              systolic: (t['systolic'] as num?)?.toDouble() ?? 0,
              glucose: (t['glucose'] as num?)?.toDouble() ?? 0,
            ),
          )
          .toList(),
      events: eventDocs.docs.map((d) => _eventFromMap(d.id, d.data())).toList(),
    );
  }

  TimelineEvent _eventFromMap(String id, Map<String, dynamic> data) {
    return TimelineEvent(
      id: id,
      category: EventCategory.values.byName(
        data['category'] as String? ?? 'visit',
      ),
      title: data['title'] as String? ?? '',
      dateLabel: data['dateLabel'] as String? ?? '',
      year: (data['year'] as num?)?.toInt() ?? 0,
      detail: data['detail'] as String? ?? '',
    );
  }

  Future<void> _seedFirestore() async {
    final timeline = _seed.readTimeline();
    final batch = _firestore.batch();

    batch.set(_doc, {
      'patientName': timeline.patient.name,
      'patientSummary': timeline.patient.summary,
      'criticality': timeline.patient.criticality,
      'careHistory': timeline.patient.careHistory,
      'totalEvents': timeline.totalEvents,
      'earlierCount': timeline.earlierCount,
      'aiViewLabel': timeline.aiViewLabel,
      'aiSummary': timeline.aiSummary,
      'trend': [
        for (final point in timeline.trend)
          {
            'label': point.label,
            'systolic': point.systolic,
            'glucose': point.glucose,
          },
      ],
    });

    for (var i = 0; i < timeline.events.length; i++) {
      final event = timeline.events[i];
      batch.set(_events.doc(event.id), {
        'category': event.category.name,
        'title': event.title,
        'dateLabel': event.dateLabel,
        'year': event.year,
        'detail': event.detail,
        'sortOrder': i,
      });
    }

    await batch.commit();
  }
}
