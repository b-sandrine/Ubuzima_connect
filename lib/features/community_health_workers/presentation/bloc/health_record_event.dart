part of 'health_record_bloc.dart';

@freezed
sealed class HealthRecordEvent with _$HealthRecordEvent {
  const factory HealthRecordEvent.started() = HealthRecordStarted;

  const factory HealthRecordEvent.tabChanged(int index) =
      HealthRecordTabChanged;

  /// Mark a next step complete, removing it from the pending list.
  const factory HealthRecordEvent.stepCompleted(String stepId) =
      HealthRecordStepCompleted;
}
