import '../../domain/models/consultation.dart';
import '../../domain/repositories/consultation_repository.dart';
import '../dummy/dummy_consultation_data.dart';

/// Mock implementation of [ConsultationRepository] used as a widget-test
/// fixture — the real app now runs on [FirestoreConsultationRepository].
/// Every call goes through `Future.delayed` to mimic a real network round
/// trip.
class MockConsultationRepository implements ConsultationRepository {
  const MockConsultationRepository();

  static const _simulatedLatency = Duration(milliseconds: 400);
  static const _autosaveLatency = Duration(milliseconds: 150);

  @override
  Future<Consultation> getActiveConsultation() {
    return Future.delayed(
      _simulatedLatency,
      () => DummyConsultationData.consultation(DateTime.now()),
    );
  }

  @override
  Future<void> saveVitalsDraft(VitalsReading vitals) {
    return Future.delayed(_autosaveLatency);
  }

  @override
  Future<Consultation> completeConsultation(VitalsReading vitals) {
    return Future.delayed(
      _simulatedLatency,
      () => DummyConsultationData.consultation(
        DateTime.now(),
      ).copyWith(vitals: vitals),
    );
  }
}
