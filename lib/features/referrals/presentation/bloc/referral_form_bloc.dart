import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../domain/entities/referral.dart';
import '../../domain/entities/referral_draft.dart';
import '../../domain/usecases/create_referral.dart';

part 'referral_form_bloc.freezed.dart';
part 'referral_form_event.dart';
part 'referral_form_state.dart';

/// Drives both referral-creation forms — the doctor's "+ New" flow (DOC-06)
/// and the CHW referral-to-hospital flow (CHW-06b). It holds a
/// [ReferralDraft], validates it live so the submit button enables only when
/// complete, and reports the assigned reference on success.
@injectable
class ReferralFormBloc extends Bloc<ReferralFormEvent, ReferralFormState> {
  final CreateReferral _createReferral;

  ReferralFormBloc(this._createReferral) : super(const ReferralFormState()) {
    on<ReferralFieldChanged>(_onFieldChanged);
    on<ReferralUrgencyChanged>(_onUrgencyChanged);
    on<ReferralFormSubmitted>(_onSubmitted);
  }

  void _onFieldChanged(
    ReferralFieldChanged event,
    Emitter<ReferralFormState> emit,
  ) {
    final draft = switch (event.field) {
      ReferralField.patientName => state.draft.copyWith(
        patientName: event.value,
      ),
      ReferralField.destinationFacility => state.draft.copyWith(
        destinationFacility: event.value,
      ),
      ReferralField.specialty => state.draft.copyWith(specialty: event.value),
      ReferralField.reason => state.draft.copyWith(reason: event.value),
      ReferralField.clinicalSummary => state.draft.copyWith(
        clinicalSummary: event.value,
      ),
      ReferralField.requestedTimeline => state.draft.copyWith(
        requestedTimeline: event.value,
      ),
    };
    emit(state.copyWith(draft: draft, status: ReferralFormStatus.editing));
  }

  void _onUrgencyChanged(
    ReferralUrgencyChanged event,
    Emitter<ReferralFormState> emit,
  ) {
    emit(state.copyWith(draft: state.draft.copyWith(urgency: event.urgency)));
  }

  Future<void> _onSubmitted(
    ReferralFormSubmitted event,
    Emitter<ReferralFormState> emit,
  ) async {
    if (!state.draft.isComplete) return;

    emit(state.copyWith(status: ReferralFormStatus.submitting));
    final result = await _createReferral(state.draft);
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: ReferralFormStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (reference) => emit(
        state.copyWith(
          status: ReferralFormStatus.success,
          createdReference: reference,
          errorMessage: null,
        ),
      ),
    );
  }
}
