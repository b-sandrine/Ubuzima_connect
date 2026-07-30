import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/validators/email_validator.dart';
import '../../domain/repositories/role_selection_repository.dart';
import '../../domain/usecases/register_with_email.dart';

part 'register_bloc.freezed.dart';
part 'register_event.dart';
part 'register_state.dart';

@injectable
class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final RegisterWithEmail _registerWithEmail;
  final RoleSelectionRepository _roleSelectionRepository;

  RegisterBloc(this._registerWithEmail, this._roleSelectionRepository)
      : super(const RegisterState()) {
    on<NameChanged>(_onNameChanged);
    on<EmailChanged>(_onEmailChanged);
    on<PasswordChanged>(_onPasswordChanged);
    on<ConfirmPasswordChanged>(_onConfirmPasswordChanged);
    on<PasswordVisibilityToggled>(_onPasswordVisibilityToggled);
    on<RegisterSubmitted>(_onSubmitted);
  }

  void _onNameChanged(NameChanged event, Emitter<RegisterState> emit) {
    emit(state.copyWith(
      name: event.value,
      status: RegisterStatus.editing,
      errorMessage: null,
    ));
  }

  void _onEmailChanged(EmailChanged event, Emitter<RegisterState> emit) {
    emit(state.copyWith(
      email: event.value,
      status: RegisterStatus.editing,
      errorMessage: null,
    ));
  }

  void _onPasswordChanged(PasswordChanged event, Emitter<RegisterState> emit) {
    emit(state.copyWith(
      password: event.value,
      status: RegisterStatus.editing,
      errorMessage: null,
    ));
  }

  void _onConfirmPasswordChanged(
    ConfirmPasswordChanged event,
    Emitter<RegisterState> emit,
  ) {
    emit(state.copyWith(
      confirmPassword: event.value,
      status: RegisterStatus.editing,
      errorMessage: null,
    ));
  }

  void _onPasswordVisibilityToggled(
    PasswordVisibilityToggled event,
    Emitter<RegisterState> emit,
  ) {
    emit(state.copyWith(obscurePassword: !state.obscurePassword));
  }

  Future<void> _onSubmitted(
    RegisterSubmitted event,
    Emitter<RegisterState> emit,
  ) async {
    if (!state.canSubmit) return;

    final emailError = EmailValidator.validate(state.email);
    if (emailError != null) {
      emit(state.copyWith(
        status: RegisterStatus.failure,
        errorMessage: emailError,
      ));
      return;
    }

    if (state.password.length < 6) {
      emit(state.copyWith(
        status: RegisterStatus.failure,
        errorMessage: 'Password must be at least 6 characters',
      ));
      return;
    }

    if (state.passwordMismatch != null) {
      emit(state.copyWith(
        status: RegisterStatus.failure,
        errorMessage: state.passwordMismatch,
      ));
      return;
    }

    emit(state.copyWith(status: RegisterStatus.submitting, errorMessage: null));

    // Read the role the user chose on AUTH-05 so it can be stored in Firestore.
    String role = 'unknown';
    final roleResult = await _roleSelectionRepository.getSelectedRole();
    roleResult.fold(
      (_) => null,
      (r) => role = r?.storageValue ?? 'unknown',
    );

    final result = await _registerWithEmail(
      email: state.email,
      password: state.password,
      displayName: state.name,
      role: role,
    );

    result.fold(
      (failure) => emit(state.copyWith(
        status: RegisterStatus.failure,
        errorMessage: failure.message,
      )),
      (_) => emit(state.copyWith(status: RegisterStatus.success)),
    );
  }
}
