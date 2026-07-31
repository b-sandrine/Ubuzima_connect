import '../models/emergency_contact.dart';
import '../models/user_profile_summary.dart';

/// The data contract the shared Settings screen is built against, for the
/// doctor, patient, and CHW audiences.
///
/// Fulfilled by `FirestoreDoctorSettingsRepository` for doctors in
/// production; patient/CHW still run on their Mock fixtures.
abstract class SettingsRepository {
  Future<UserProfileSummary> getProfile();

  Future<List<EmergencyContact>> getEmergencyContacts();
}
