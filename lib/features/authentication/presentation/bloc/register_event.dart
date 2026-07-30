part of 'register_bloc.dart';

@freezed
sealed class RegisterEvent with _$RegisterEvent {
  const factory RegisterEvent.nameChanged(String value) = NameChanged;
  const factory RegisterEvent.emailChanged(String value) = EmailChanged;
  const factory RegisterEvent.passwordChanged(String value) = PasswordChanged;
  const factory RegisterEvent.confirmPasswordChanged(String value) =
      ConfirmPasswordChanged;
  const factory RegisterEvent.passwordVisibilityToggled() =
      PasswordVisibilityToggled;
  const factory RegisterEvent.submitted() = RegisterSubmitted;
}
