import 'package:injectable/injectable.dart';

import '../../domain/models/records_patient_profile.dart';
import '../../domain/models/visit_summary.dart';
import '../../domain/repositories/patient_records_repository.dart';
import '../datasources/remote/patient_records_remote_data_source.dart';

@LazySingleton(as: PatientRecordsRepository)
class PatientRecordsRepositoryImpl implements PatientRecordsRepository {
  final PatientRecordsRemoteDataSource _remoteDataSource;

  const PatientRecordsRepositoryImpl(this._remoteDataSource);

  @override
  Future<RecordsPatientProfile> getPatientProfile() =>
      _remoteDataSource.readProfile();

  @override
  Future<List<VisitSummary>> getVisitSummaries() =>
      _remoteDataSource.readVisitSummaries();

  @override
  Future<int> getTotalVisitCount() => _remoteDataSource.readTotalVisitCount();
}
