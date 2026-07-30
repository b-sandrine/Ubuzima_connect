part of 'reset_password_bloc.dart';

@freezed
sealed class ResetPasswordEvent with _$ResetPasswordEvent {
  const factory ResetPasswordEvent.emailChanged(String value) = ResetEmailChanged;
  const factory ResetPasswordEvent.submitted() = ResetSubmitted;
}
