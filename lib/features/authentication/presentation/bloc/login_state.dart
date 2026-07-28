part of 'login_bloc.dart';

enum LoginStatus { editing, submitting, success, failure }

@freezed
abstract class LoginState with _$LoginState {
  const factory LoginState({
    @Default(LoginStatus.editing) LoginStatus status,
    @Default('') String email,
    @Default('') String password,
    @Default(true) bool obscurePassword,
    String? errorMessage,
  }) = _LoginState;

  const LoginState._();

  bool get canSubmit =>
      email.trim().isNotEmpty &&
      password.isNotEmpty &&
      status != LoginStatus.submitting;
}
