part of 'patient_intake_bloc.dart';

enum PatientIntakeStatus { editing, submitting, success, failure }

@freezed
abstract class PatientIntakeState with _$PatientIntakeState {
  const factory PatientIntakeState({
    @Default(0) int step,
    @Default(PatientIntakeDraft()) PatientIntakeDraft draft,
    @Default(PatientIntakeStatus.editing) PatientIntakeStatus status,
    String? errorMessage,
    String? createdPatientId,
  }) = _PatientIntakeState;

  const PatientIntakeState._();

  bool get canContinueIdentityStep => draft.isIdentityStepComplete;

  bool get canContinueContactStep => draft.isContactStepComplete;

  bool get canSubmit =>
      draft.isSymptomsStepComplete && status != PatientIntakeStatus.submitting;

  RiskAssessment get riskAssessment => PatientRiskCalculator.calculate(draft);

  int get activeEmergencyFlagCount => draft.emergencyFlags.length;
}
