import '../models/emergency_contact.dart';
import '../models/user_profile_summary.dart';

/// The data contract the shared Settings screen is built against, for both
/// the doctor and patient audiences.
///
/// The doctor audience still resolves to `MockDoctorSettingsRepository`; the
/// patient audience resolves to [PatientSettingsRepositoryImpl], a
/// Firestore-backed data source seeded once from
/// [PatientSettingsLocalDataSource] on first read.
abstract class SettingsRepository {
  Future<UserProfileSummary> getProfile();

  Future<List<EmergencyContact>> getEmergencyContacts();
}
