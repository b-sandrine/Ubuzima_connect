import '../../domain/models/records_patient_profile.dart';
import '../../domain/models/visit_summary.dart';
import '../../domain/repositories/patient_records_repository.dart';
import '../dummy/dummy_patient_records_data.dart';

/// Mock implementation of [PatientRecordsRepository] used until the
/// Firestore-backed medical records screen is wired up. Every call goes
/// through `Future.delayed` to mimic a real network round trip, so the
/// presentation layer's loading states are exercised even against fake data.
class MockPatientRecordsRepository implements PatientRecordsRepository {
  const MockPatientRecordsRepository();

  static const _simulatedLatency = Duration(milliseconds: 400);

  @override
  Future<RecordsPatientProfile> getPatientProfile() {
    return Future.delayed(
      _simulatedLatency,
      () => DummyPatientRecordsData.profile,
    );
  }

  @override
  Future<List<VisitSummary>> getVisitSummaries() {
    return Future.delayed(
      _simulatedLatency,
      () => DummyPatientRecordsData.visitSummaries,
    );
  }

  @override
  Future<int> getTotalVisitCount() {
    return Future.delayed(
      _simulatedLatency,
      () => DummyPatientRecordsData.totalVisitCount,
    );
  }
}
