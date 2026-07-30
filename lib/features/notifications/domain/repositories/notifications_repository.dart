import '../models/notification_section.dart';

/// The data contract the shared Notifications screen is built against, for
/// both the doctor and patient audiences.
///
/// [MockDoctorNotificationsRepository] / [MockPatientNotificationsRepository]
/// fulfill it today with seeded, `Future.delayed` data; a later
/// Firestore-backed implementation can implement the same interface, and
/// `NotificationsPage` won't need to change at all.
abstract class NotificationsRepository {
  Future<List<NotificationSection>> getSections();
}
