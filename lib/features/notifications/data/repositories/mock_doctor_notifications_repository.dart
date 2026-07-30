import '../../domain/models/notification_section.dart';
import '../../domain/repositories/notifications_repository.dart';
import '../dummy/dummy_doctor_notifications_data.dart';

/// Mock implementation of [NotificationsRepository] for the doctor
/// audience, used until the Firestore-backed notifications feed is wired
/// up. Goes through `Future.delayed` to mimic a real network round trip.
class MockDoctorNotificationsRepository implements NotificationsRepository {
  const MockDoctorNotificationsRepository();

  static const _simulatedLatency = Duration(milliseconds: 400);

  @override
  Future<List<NotificationSection>> getSections() {
    return Future.delayed(
      _simulatedLatency,
      () => DummyDoctorNotificationsData.sections,
    );
  }
}
