/// The three roles a person can sign up as. Deliberately has no `unknown`
/// member — a role only exists here once someone has actually chosen one,
/// so "not chosen yet" is represented by a null [UserRole], not a member.
///
/// `core/routing/auth_session.dart` keeps its own routing-facing enum with
/// an `unknown` member for the pre-session state; the authentication
/// feature maps between the two once real sessions land.
enum UserRole {
  patient,
  communityHealthWorker,
  doctor;

  /// Stable identifier persisted to storage and (later) written to the
  /// user's Firestore document. Never persist `Enum.name` directly — this
  /// keeps renaming a Dart member from orphaning everyone's saved role.
  String get storageValue => switch (this) {
    UserRole.patient => 'patient',
    UserRole.communityHealthWorker => 'chw',
    UserRole.doctor => 'doctor',
  };

  static UserRole? fromStorageValue(String? value) {
    return switch (value) {
      'patient' => UserRole.patient,
      'chw' => UserRole.communityHealthWorker,
      'doctor' => UserRole.doctor,
      _ => null,
    };
  }
}
