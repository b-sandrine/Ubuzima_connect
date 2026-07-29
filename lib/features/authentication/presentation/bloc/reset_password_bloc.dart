import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/validators/email_validator.dart';
import '../../domain/usecases/send_password_reset.dart';

part 'reset_password_bloc.freezed.dart';
part 'reset_password_event.dart';
part 'reset_password_state.dart';

@injectable
class ResetPasswordBloc extends Bloc<ResetPasswordEvent, ResetPasswordState> {
  final SendPasswordReset _sendPasswordReset;

  ResetPasswordBloc(this._sendPasswordReset)
      : super(const ResetPasswordState()) {
    on<ResetEmailChanged>(_onEmailChanged);
    on<ResetSubmitted>(_onSubmitted);
  }

  void _onEmailChanged(
    ResetEmailChanged event,
    Emitter<ResetPasswordState> emit,
  ) {
    emit(state.copyWith(
      email: event.value,
      status: ResetPasswordStatus.editing,
      errorMessage: null,
    ));
  }

  Future<void> _onSubmitted(
    ResetSubmitted event,
    Emitter<ResetPasswordState> emit,
  ) async {
    if (!state.canSubmit) return;

    final emailError = EmailValidator.validate(state.email);
    if (emailError != null) {
      emit(state.copyWith(
        status: ResetPasswordStatus.failure,
        errorMessage: emailError,
      ));
      return;
    }

    emit(state.copyWith(
      status: ResetPasswordStatus.submitting,
      errorMessage: null,
    ));

    final result = await _sendPasswordReset(email: state.email);

    result.fold(
      (failure) => emit(state.copyWith(
        status: ResetPasswordStatus.failure,
        errorMessage: failure.message,
      )),
      (_) => emit(state.copyWith(status: ResetPasswordStatus.sent)),
    );
  }
}
