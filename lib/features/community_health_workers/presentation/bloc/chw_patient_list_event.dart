part of 'chw_patient_list_bloc.dart';

@freezed
sealed class ChwPatientListEvent with _$ChwPatientListEvent {
  const factory ChwPatientListEvent.started() = ChwPatientListStarted;

  const factory ChwPatientListEvent.refreshed() = ChwPatientListRefreshed;

  const factory ChwPatientListEvent.queryChanged(String query) =
      ChwPatientListQueryChanged;
}
