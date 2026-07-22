part of 'role_selection_bloc.dart';

@freezed
sealed class RoleSelectionEvent with _$RoleSelectionEvent {
  /// Re-reads any previously saved choice so returning to AUTH-05 shows the
  /// card the user picked last time already highlighted.
  const factory RoleSelectionEvent.started() = RoleSelectionStarted;

  const factory RoleSelectionEvent.roleHighlighted(UserRole role) =
      RoleHighlighted;

  const factory RoleSelectionEvent.confirmed() = RoleSelectionConfirmed;
}
