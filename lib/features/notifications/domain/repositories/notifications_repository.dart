import '../models/notification_section.dart';

/// The data contract the shared Notifications screen is built against, for
/// both the doctor and patient audiences.
///
/// The doctor audience still resolves to `MockDoctorNotificationsRepository`;
/// the patient audience resolves to [PatientNotificationsRepositoryImpl], a
/// Firestore-backed data source seeded once from
/// [PatientNotificationsLocalDataSource] on first read.
abstract class NotificationsRepository {
  Future<List<NotificationSection>> getSections();
}
