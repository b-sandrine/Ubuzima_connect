import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/validators/email_validator.dart';
import '../../../../core/validators/phone_validator.dart';
import '../../domain/usecases/sign_in_with_email.dart';
import '../../domain/usecases/sign_in_with_google.dart';
import '../utils/phone_auth_email.dart';

part 'login_bloc.freezed.dart';
part 'login_event.dart';
part 'login_state.dart';

@injectable
class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final SignInWithEmail _signInWithEmail;
  final SignInWithGoogle _signInWithGoogle;

  LoginBloc(this._signInWithEmail, this._signInWithGoogle)
    : super(const LoginState()) {
    on<LoginMethodChanged>(_onLoginMethodChanged);
    on<PhoneChanged>(_onPhoneChanged);
    on<EmailChanged>(_onEmailChanged);
    on<PasswordChanged>(_onPasswordChanged);
    on<PasswordVisibilityToggled>(_onPasswordVisibilityToggled);
    on<RememberMeToggled>(_onRememberMeToggled);
    on<Submitted>(_onSubmitted);
    on<GoogleSignInRequested>(_onGoogleSignInRequested);
  }

  void _onLoginMethodChanged(
    LoginMethodChanged event,
    Emitter<LoginState> emit,
  ) {
    emit(
      state.copyWith(
        loginMethod: event.method,
        status: LoginStatus.editing,
        errorMessage: null,
      ),
    );
  }

  void _onPhoneChanged(PhoneChanged event, Emitter<LoginState> emit) {
    emit(
      state.copyWith(
        phone: event.value,
        status: LoginStatus.editing,
        errorMessage: null,
      ),
    );
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

  void _onRememberMeToggled(
    RememberMeToggled event,
    Emitter<LoginState> emit,
  ) {
    emit(state.copyWith(rememberMe: event.value));
  }

  Future<void> _onSubmitted(
    Submitted event,
    Emitter<LoginState> emit,
  ) async {
    if (!state.canSubmit) return;

    final (error, email) = switch (state.loginMethod) {
      LoginMethod.email => _validateEmail(state.email),
      LoginMethod.phone => _validatePhone(state.phone),
    };

    if (error != null || email == null) {
      emit(
        state.copyWith(
          status: LoginStatus.failure,
          errorMessage: error ?? 'Authentication failed.',
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
      email: email,
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

  (String? error, String? email) _validateEmail(String value) {
    final emailError = EmailValidator.validate(value);
    if (emailError != null) {
      return (emailError, null);
    }
    return (null, value.trim());
  }

  (String? error, String? email) _validatePhone(String value) {
    final phoneError = PhoneValidator.validate(value);
    if (phoneError != null) {
      return (phoneError, null);
    }

    final syntheticEmail = PhoneAuthEmail.fromPhone(value);
    if (syntheticEmail == null) {
      return ('Enter a valid Rwandan phone number', null);
    }
    return (null, syntheticEmail);
  }
}
