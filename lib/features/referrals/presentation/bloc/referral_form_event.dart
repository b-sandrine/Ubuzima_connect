part of 'referral_form_bloc.dart';

/// The free-text fields on the referral form. Kept as an enum so one event
/// covers every text field rather than one event per field.
enum ReferralField {
  patientName,
  destinationFacility,
  specialty,
  reason,
  clinicalSummary,
  requestedTimeline,
}

@freezed
sealed class ReferralFormEvent with _$ReferralFormEvent {
  const factory ReferralFormEvent.fieldChanged(
    ReferralField field,
    String value,
  ) = ReferralFieldChanged;

  const factory ReferralFormEvent.urgencyChanged(ReferralUrgency urgency) =
      ReferralUrgencyChanged;

  const factory ReferralFormEvent.submitted() = ReferralFormSubmitted;
}
