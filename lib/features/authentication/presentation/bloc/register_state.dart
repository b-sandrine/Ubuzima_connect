part of 'register_bloc.dart';

enum RegisterStatus { editing, submitting, success, failure }

@freezed
abstract class RegisterState with _$RegisterState {
  const factory RegisterState({
    @Default(RegisterStatus.editing) RegisterStatus status,
    @Default('') String name,
    @Default('') String email,
    @Default('') String password,
    @Default('') String confirmPassword,
    @Default(true) bool obscurePassword,
    String? errorMessage,
  }) = _RegisterState;

  const RegisterState._();

  bool get canSubmit =>
      name.trim().isNotEmpty &&
      email.trim().isNotEmpty &&
      password.isNotEmpty &&
      confirmPassword.isNotEmpty &&
      status != RegisterStatus.submitting;

  String? get passwordMismatch =>
      password.isNotEmpty &&
              confirmPassword.isNotEmpty &&
              password != confirmPassword
          ? 'Passwords do not match'
          : null;
}
