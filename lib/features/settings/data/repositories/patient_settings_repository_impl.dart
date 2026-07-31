import 'package:injectable/injectable.dart';

import '../../domain/models/emergency_contact.dart';
import '../../domain/models/user_profile_summary.dart';
import '../../domain/repositories/settings_repository.dart';
import '../datasources/remote/patient_settings_remote_data_source.dart';

/// Firestore-backed [SettingsRepository] for the patient audience.
/// Registered as its own concrete type (not bound to [SettingsRepository])
/// since the doctor audience still resolves to
/// `MockDoctorSettingsRepository` — `SettingsPage` picks between the two by
/// audience rather than through a single DI-resolved interface.
@lazySingleton
class PatientSettingsRepositoryImpl implements SettingsRepository {
  final PatientSettingsRemoteDataSource _remoteDataSource;

  const PatientSettingsRepositoryImpl(this._remoteDataSource);

  @override
  Future<UserProfileSummary> getProfile() => _remoteDataSource.readProfile();

  @override
  Future<List<EmergencyContact>> getEmergencyContacts() =>
      _remoteDataSource.readEmergencyContacts();
}
