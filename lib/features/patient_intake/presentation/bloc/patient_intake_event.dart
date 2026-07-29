part of 'patient_intake_bloc.dart';

@freezed
sealed class PatientIntakeEvent with _$PatientIntakeEvent {
  /// Replaces the whole draft — the view computes the new value via
  /// `state.draft.copyWith(...)` and dispatches it, rather than one event
  /// variant per field across ~35 fields.
  const factory PatientIntakeEvent.draftUpdated(PatientIntakeDraft draft) =
      PatientIntakeDraftUpdated;

  const factory PatientIntakeEvent.stepChanged(int step) =
      PatientIntakeStepChanged;

  const factory PatientIntakeEvent.submitted() = PatientIntakeSubmitted;
}
