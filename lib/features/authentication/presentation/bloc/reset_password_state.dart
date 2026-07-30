part of 'reset_password_bloc.dart';

enum ResetPasswordStatus { editing, submitting, sent, failure }

@freezed
abstract class ResetPasswordState with _$ResetPasswordState {
  const factory ResetPasswordState({
    @Default(ResetPasswordStatus.editing) ResetPasswordStatus status,
    @Default('') String email,
    String? errorMessage,
  }) = _ResetPasswordState;

  const ResetPasswordState._();

  bool get canSubmit =>
      email.trim().isNotEmpty && status != ResetPasswordStatus.submitting;
}
