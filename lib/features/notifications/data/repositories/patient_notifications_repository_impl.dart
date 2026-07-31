import 'package:injectable/injectable.dart';

import '../../domain/models/notification_section.dart';
import '../../domain/repositories/notifications_repository.dart';
import '../datasources/remote/patient_notifications_remote_data_source.dart';

/// Firestore-backed [NotificationsRepository] for the patient audience.
/// Registered as its own concrete type (not bound to
/// [NotificationsRepository]) since the doctor audience still resolves to
/// `MockDoctorNotificationsRepository` — `NotificationsPage` picks between
/// the two by audience rather than through a single DI-resolved interface.
@lazySingleton
class PatientNotificationsRepositoryImpl implements NotificationsRepository {
  final PatientNotificationsRemoteDataSource _remoteDataSource;

  const PatientNotificationsRepositoryImpl(this._remoteDataSource);

  @override
  Future<List<NotificationSection>> getSections() =>
      _remoteDataSource.readSections();
}
