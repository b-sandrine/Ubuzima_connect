part of 'referral_form_bloc.dart';

enum ReferralFormStatus { editing, submitting, success, failure }

@freezed
abstract class ReferralFormState with _$ReferralFormState {
  const factory ReferralFormState({
    @Default(ReferralDraft()) ReferralDraft draft,
    @Default(ReferralFormStatus.editing) ReferralFormStatus status,
    String? createdReference,
    String? errorMessage,
  }) = _ReferralFormState;

  const ReferralFormState._();

  bool get canSubmit =>
      draft.isComplete && status != ReferralFormStatus.submitting;
}
