part of 'login_bloc.dart';

@freezed
sealed class LoginEvent with _$LoginEvent {
  const factory LoginEvent.loginMethodChanged(LoginMethod method) =
      LoginMethodChanged;
  const factory LoginEvent.phoneChanged(String value) = PhoneChanged;
  const factory LoginEvent.emailChanged(String value) = EmailChanged;
  const factory LoginEvent.passwordChanged(String value) = PasswordChanged;
  const factory LoginEvent.passwordVisibilityToggled() =
      PasswordVisibilityToggled;
  const factory LoginEvent.rememberMeToggled(bool value) = RememberMeToggled;
  const factory LoginEvent.submitted() = Submitted;
  const factory LoginEvent.googleSignInRequested() = GoogleSignInRequested;
}
