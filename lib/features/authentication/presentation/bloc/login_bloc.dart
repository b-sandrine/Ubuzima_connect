import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/validators/email_validator.dart';
import '../../domain/usecases/sign_in_with_email.dart';
import '../../domain/usecases/sign_in_with_google.dart';

part 'login_bloc.freezed.dart';
part 'login_event.dart';
part 'login_state.dart';

@injectable
class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final SignInWithEmail _signInWithEmail;
  final SignInWithGoogle _signInWithGoogle;

  LoginBloc(this._signInWithEmail, this._signInWithGoogle)
    : super(const LoginState()) {
    on<EmailChanged>(_onEmailChanged);
    on<PasswordChanged>(_onPasswordChanged);
    on<PasswordVisibilityToggled>(_onPasswordVisibilityToggled);
    on<Submitted>(_onSubmitted);
    on<GoogleSignInRequested>(_onGoogleSignInRequested);
  }

  void _onEmailChanged(EmailChanged event, Emitter<LoginState> emit) {
    emit(
      state.copyWith(
        email: event.value,
        status: LoginStatus.editing,
        errorMessage: null,
      ),
    );
  }

  void _onPasswordChanged(PasswordChanged event, Emitter<LoginState> emit) {
    emit(
      state.copyWith(
        password: event.value,
        status: LoginStatus.editing,
        errorMessage: null,
      ),
    );
  }

  void _onPasswordVisibilityToggled(
    PasswordVisibilityToggled event,
    Emitter<LoginState> emit,
  ) {
    emit(state.copyWith(obscurePassword: !state.obscurePassword));
  }

  Future<void> _onSubmitted(
    Submitted event,
    Emitter<LoginState> emit,
  ) async {
    if (!state.canSubmit) return;

    final emailError = EmailValidator.validate(state.email);
    if (emailError != null) {
      emit(
        state.copyWith(
          status: LoginStatus.failure,
          errorMessage: emailError,
        ),
      );
      return;
    }

    if (state.password.isEmpty) {
      emit(
        state.copyWith(
          status: LoginStatus.failure,
          errorMessage: 'Password is required',
        ),
      );
      return;
    }

    emit(state.copyWith(status: LoginStatus.submitting, errorMessage: null));

    final result = await _signInWithEmail(
      email: state.email,
      password: state.password,
    );

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: LoginStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (_) => emit(state.copyWith(status: LoginStatus.success)),
    );
  }

  Future<void> _onGoogleSignInRequested(
    GoogleSignInRequested event,
    Emitter<LoginState> emit,
  ) async {
    emit(state.copyWith(status: LoginStatus.submitting, errorMessage: null));

    final result = await _signInWithGoogle();

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: LoginStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (_) => emit(state.copyWith(status: LoginStatus.success)),
    );
  }
}
