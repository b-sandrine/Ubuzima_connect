part of 'chw_patient_list_bloc.dart';

enum ChwPatientListStatus { initial, loading, ready, failure }

@freezed
abstract class ChwPatientListState with _$ChwPatientListState {
  const factory ChwPatientListState({
    @Default(ChwPatientListStatus.initial) ChwPatientListStatus status,
    @Default(<RegisteredPatient>[]) List<RegisteredPatient> patients,
    @Default('') String query,
    String? errorMessage,
  }) = _ChwPatientListState;

  const ChwPatientListState._();

  List<RegisteredPatient> get filteredPatients {
    final q = query.trim().toLowerCase();
    if (q.isEmpty) return patients;
    return patients.where((p) {
      return p.fullName.toLowerCase().contains(q) ||
          (p.phone?.toLowerCase().contains(q) ?? false) ||
          p.locationLabel.toLowerCase().contains(q) ||
          p.riskLevel.name.toLowerCase().contains(q);
    }).toList();
  }
}
