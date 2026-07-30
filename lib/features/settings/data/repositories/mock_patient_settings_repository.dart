import '../../domain/models/emergency_contact.dart';
import '../../domain/models/user_profile_summary.dart';
import '../../domain/repositories/settings_repository.dart';
import '../dummy/dummy_patient_settings_data.dart';

/// Mock implementation of [SettingsRepository] for the patient audience,
/// used until the Firestore-backed settings screen is wired up. Goes
/// through `Future.delayed` to mimic a real network round trip.
class MockPatientSettingsRepository implements SettingsRepository {
  const MockPatientSettingsRepository();

  static const _simulatedLatency = Duration(milliseconds: 400);

  @override
  Future<UserProfileSummary> getProfile() {
    return Future.delayed(
      _simulatedLatency,
      () => DummyPatientSettingsData.profile,
    );
  }

  @override
  Future<List<EmergencyContact>> getEmergencyContacts() {
    return Future.delayed(
      _simulatedLatency,
      () => DummyPatientSettingsData.emergencyContacts,
    );
  }
}
