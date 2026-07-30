import '../models/emergency_contact.dart';
import '../models/user_profile_summary.dart';

/// The data contract the shared Settings screen is built against, for both
/// the doctor and patient audiences.
///
/// [MockDoctorSettingsRepository] / [MockPatientSettingsRepository] fulfill
/// it today with seeded, `Future.delayed` data; a later Firestore-backed
/// implementation can implement the same interface, and `SettingsPage`
/// won't need to change at all.
abstract class SettingsRepository {
  Future<UserProfileSummary> getProfile();

  Future<List<EmergencyContact>> getEmergencyContacts();
}
