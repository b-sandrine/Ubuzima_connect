import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ubuzima_connect/core/constants/app_constants.dart';
import 'package:ubuzima_connect/core/constants/firestore_paths.dart';
import 'package:ubuzima_connect/features/medical_records/data/datasources/local/timeline_local_data_source.dart';
import 'package:ubuzima_connect/features/medical_records/data/datasources/remote/timeline_remote_data_source.dart';

void main() {
  late FakeFirebaseFirestore firestore;
  late TimelineRemoteDataSourceImpl dataSource;

  setUp(() {
    firestore = FakeFirebaseFirestore();
    dataSource = TimelineRemoteDataSourceImpl(
      firestore,
      TimelineLocalDataSourceImpl(),
    );
  });

  test('read seeds the timeline and returns the patient, trend and events',
      () async {
    final timeline = await dataSource.readTimeline();

    expect(timeline.patient.name, 'Marie Uwase');
    expect(timeline.patient.careHistory, isNotEmpty);
    expect(timeline.trend, isNotEmpty);
    expect(timeline.events, isNotEmpty);
    expect(timeline.totalEvents, greaterThan(0));
  });

  test('events come back in chronological (seed) order', () async {
    final timeline = await dataSource.readTimeline();

    expect(timeline.events.first.title, 'Hypertensive Crisis');
    expect(timeline.events.last.year, lessThan(timeline.events.first.year));
  });

  test('the seed is persisted to the medical_records collection', () async {
    await dataSource.readTimeline();

    final doc = await firestore
        .collection(FirestorePaths.medicalRecords)
        .doc(AppConstants.demoPatientId)
        .get();
    final events = await doc.reference.collection('events').get();

    expect(doc.exists, isTrue);
    expect(events.docs, isNotEmpty);
  });
}
