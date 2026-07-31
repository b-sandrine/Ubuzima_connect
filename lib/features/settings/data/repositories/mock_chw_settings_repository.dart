import '../../domain/models/emergency_contact.dart';
import '../../domain/models/user_profile_summary.dart';
import '../../domain/repositories/settings_repository.dart';
import '../dummy/dummy_chw_settings_data.dart';

class MockChwSettingsRepository implements SettingsRepository {
  const MockChwSettingsRepository();

  static const _simulatedLatency = Duration(milliseconds: 300);

  @override
  Future<UserProfileSummary> getProfile() {
    return Future.delayed(
      _simulatedLatency,
      () => DummyChwSettingsData.profile,
    );
  }

  @override
  Future<List<EmergencyContact>> getEmergencyContacts() {
    return Future.delayed(
      _simulatedLatency,
      () => DummyChwSettingsData.emergencyContacts,
    );
  }
}
