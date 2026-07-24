part of 'health_record_bloc.dart';

@freezed
sealed class HealthRecordEvent with _$HealthRecordEvent {
  const factory HealthRecordEvent.started() = HealthRecordStarted;

  const factory HealthRecordEvent.tabChanged(int index) =
      HealthRecordTabChanged;
}
