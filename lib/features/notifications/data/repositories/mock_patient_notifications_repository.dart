import '../../domain/models/notification_section.dart';
import '../../domain/repositories/notifications_repository.dart';
import '../dummy/dummy_patient_notifications_data.dart';

/// Mock implementation of [NotificationsRepository] for the patient
/// audience, used until the Firestore-backed notifications feed is wired
/// up. Goes through `Future.delayed` to mimic a real network round trip.
class MockPatientNotificationsRepository implements NotificationsRepository {
  const MockPatientNotificationsRepository();

  static const _simulatedLatency = Duration(milliseconds: 400);

  @override
  Future<List<NotificationSection>> getSections() {
    return Future.delayed(
      _simulatedLatency,
      () => DummyPatientNotificationsData.sections,
    );
  }
}
