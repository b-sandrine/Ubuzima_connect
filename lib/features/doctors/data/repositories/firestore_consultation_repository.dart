import 'package:injectable/injectable.dart';

import '../../domain/models/consultation.dart';
import '../../domain/repositories/consultation_repository.dart';
import '../datasources/remote/consultation_remote_data_source.dart';

/// Firestore-backed [ConsultationRepository], delegating straight to
/// [ConsultationRemoteDataSource] — this screen has no AI-generated copy
/// to layer on top.
@LazySingleton(as: ConsultationRepository)
class FirestoreConsultationRepository implements ConsultationRepository {
  const FirestoreConsultationRepository(this._remote);

  final ConsultationRemoteDataSource _remote;

  @override
  Future<Consultation> getActiveConsultation() =>
      _remote.getActiveConsultation();

  @override
  Future<void> saveVitalsDraft(VitalsReading vitals) =>
      _remote.saveVitalsDraft(vitals);

  @override
  Future<Consultation> completeConsultation(VitalsReading vitals) =>
      _remote.completeConsultation(vitals);
}
