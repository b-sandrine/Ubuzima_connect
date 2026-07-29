part of 'login_bloc.dart';

enum LoginStatus { editing, submitting, success, failure }

enum LoginMethod { phone, email }

@freezed
abstract class LoginState with _$LoginState {
  const factory LoginState({
    @Default(LoginStatus.editing) LoginStatus status,
    @Default(LoginMethod.phone) LoginMethod loginMethod,
    @Default('') String email,
    @Default('') String phone,
    @Default('') String password,
    @Default(true) bool obscurePassword,
    @Default(false) bool rememberMe,
    String? errorMessage,
  }) = _LoginState;

  const LoginState._();

  bool get canSubmit =>
      identifier.trim().isNotEmpty &&
      password.isNotEmpty &&
      status != LoginStatus.submitting;

  String get identifier =>
      loginMethod == LoginMethod.phone ? phone : email;
}
