import 'package:equatable/equatable.dart';

/// Base type every repository returns on the left side of an
/// `Either<Failure, T>`. Presentation only ever branches on a [Failure] —
/// raw exceptions never cross the Data → Domain boundary (see
/// `core/exceptions` for what gets translated into these).
sealed class Failure extends Equatable {
  final String message;

  const Failure(this.message);

  @override
  List<Object?> get props => [message];
}

/// Firestore/Firebase call failed (permission denied, quota, unknown host).
final class ServerFailure extends Failure {
  const ServerFailure([super.message = 'A server error occurred.']);
}

/// Local SQLite / secure storage / shared preferences read or write failed.
final class CacheFailure extends Failure {
  const CacheFailure([super.message = 'A local storage error occurred.']);
}

/// Device is offline and no usable cache exists for the requested read.
final class NetworkFailure extends Failure {
  const NetworkFailure([super.message = 'No internet connection.']);
}

/// A queued offline write conflicted with a remote change during sync.
final class SyncConflictFailure extends Failure {
  const SyncConflictFailure([super.message = 'A sync conflict occurred.']);
}

/// Input failed domain validation rules before ever reaching a data source.
final class ValidationFailure extends Failure {
  const ValidationFailure([super.message = 'Invalid input.']);
}

/// Firebase Authentication rejected the credential/session.
final class AuthFailure extends Failure {
  const AuthFailure([super.message = 'Authentication failed.']);
}

/// The signed-in user's role does not permit the attempted action.
final class PermissionFailure extends Failure {
  const PermissionFailure([super.message = 'Permission denied.']);
}

/// Catch-all for anything not classified above.
final class UnexpectedFailure extends Failure {
  const UnexpectedFailure([super.message = 'An unexpected error occurred.']);
}
