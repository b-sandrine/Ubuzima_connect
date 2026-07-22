part of 'role_selection_bloc.dart';

enum RoleSelectionStatus { editing, saving, saved, failure }

@freezed
abstract class RoleSelectionState with _$RoleSelectionState {
  const factory RoleSelectionState({
    @Default(RoleSelectionStatus.editing) RoleSelectionStatus status,
    UserRole? highlightedRole,
    String? errorMessage,
  }) = _RoleSelectionState;

  const RoleSelectionState._();

  /// Continue stays disabled until something is actually picked — the page
  /// never has to reimplement this rule.
  bool get canConfirm =>
      highlightedRole != null && status != RoleSelectionStatus.saving;
}
