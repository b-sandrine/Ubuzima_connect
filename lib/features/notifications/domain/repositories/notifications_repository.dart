import '../models/notification_section.dart';

/// The data contract the shared Notifications screen is built against, for
/// the doctor, patient, and CHW audiences.
///
/// Fulfilled by `FirestoreDoctorNotificationsRepository` for doctors in
/// production; patient still runs on its Mock fixture, and CHW is backed
/// by `ChwCaseloadRepository`.
abstract class NotificationsRepository {
  Future<List<NotificationSection>> getSections();
}
