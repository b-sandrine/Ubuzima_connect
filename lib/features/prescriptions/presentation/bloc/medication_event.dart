part of 'medication_bloc.dart';

@freezed
sealed class MedicationEvent with _$MedicationEvent {
  /// Loads today's schedule when the screen opens.
  const factory MedicationEvent.started() = MedicationStarted;

  /// Switches between Today / Prescriptions / Adherence / History.
  const factory MedicationEvent.tabChanged(int index) = MedicationTabChanged;

  /// The patient tapped "Take" on a due dose.
  const factory MedicationEvent.doseMarkedTaken(String doseId) =
      DoseMarkedTaken;

  /// The patient tapped "Request" on the refill banner.
  const factory MedicationEvent.refillRequested() = RefillRequested;
}
