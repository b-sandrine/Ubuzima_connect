part of 'login_bloc.dart';

@freezed
sealed class LoginEvent with _$LoginEvent {
  const factory LoginEvent.emailChanged(String value) = EmailChanged;
  const factory LoginEvent.passwordChanged(String value) = PasswordChanged;
  const factory LoginEvent.passwordVisibilityToggled() =
      PasswordVisibilityToggled;
  const factory LoginEvent.submitted() = Submitted;
  const factory LoginEvent.googleSignInRequested() = GoogleSignInRequested;
}
