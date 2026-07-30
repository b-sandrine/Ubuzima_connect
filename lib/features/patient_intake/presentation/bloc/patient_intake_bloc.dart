import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../domain/entities/patient_intake_draft.dart';
import '../../domain/usecases/submit_patient_intake.dart';

part 'patient_intake_bloc.freezed.dart';
part 'patient_intake_event.dart';
part 'patient_intake_state.dart';

/// Drives the whole three-step New Patient Registration flow — Identity &
/// Household, Demographics & Contact, and Confirm & Submit. Kept as one
/// bloc/one draft for the entire flow so nothing entered on an earlier step
/// is lost moving to the next.
@injectable
class PatientIntakeBloc extends Bloc<PatientIntakeEvent, PatientIntakeState> {
  final SubmitPatientIntake _submitPatientIntake;

  PatientIntakeBloc(this._submitPatientIntake)
    : super(const PatientIntakeState()) {
    on<PatientIntakeDraftUpdated>(
      (event, emit) => emit(state.copyWith(draft: event.draft)),
    );
    on<PatientIntakeStepChanged>(
      (event, emit) => emit(state.copyWith(step: event.step)),
    );
    on<PatientIntakeSubmitted>(_onSubmitted);
  }

  Future<void> _onSubmitted(
    PatientIntakeSubmitted event,
    Emitter<PatientIntakeState> emit,
  ) async {
    if (!state.canSubmit) return;

    emit(state.copyWith(status: PatientIntakeStatus.submitting));
    final result = await _submitPatientIntake(state.draft);
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: PatientIntakeStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (patientId) => emit(
        state.copyWith(
          status: PatientIntakeStatus.success,
          createdPatientId: patientId,
          errorMessage: null,
        ),
      ),
    );
  }
}
