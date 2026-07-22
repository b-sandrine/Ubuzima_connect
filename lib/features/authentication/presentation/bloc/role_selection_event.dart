part of 'role_selection_bloc.dart';

@freezed
sealed class RoleSelectionEvent with _$RoleSelectionEvent {
  /// Re-reads any previously saved choice so returning to AUTH-05 shows the
  /// card the user picked last time already highlighted.
  const factory RoleSelectionEvent.started() = RoleSelectionStarted;

  const factory RoleSelectionEvent.roleHighlighted(UserRole role) =
      RoleHighlighted;

  /// Saves the highlighted role and then hands off to whichever auth screen
  /// the user asked for — the design offers Sign In and Create Account as
  /// two peer actions rather than a single Continue.
  const factory RoleSelectionEvent.confirmed(AuthDestination destination) =
      RoleSelectionConfirmed;
}
