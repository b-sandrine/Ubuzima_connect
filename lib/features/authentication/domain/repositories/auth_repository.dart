import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../entities/auth_user.dart';

abstract interface class AuthRepository {
  AuthUser? get currentUser;

  Stream<AuthUser?> get authStateChanges;

  Future<Either<Failure, AuthUser>> signInWithEmail({
    required String email,
    required String password,
  });

  Future<Either<Failure, AuthUser>> signInWithGoogle();

  Future<Either<Failure, AuthUser>> registerWithEmail({
    required String email,
    required String password,
    required String displayName,
    required String role,
  });

  Future<Either<Failure, Unit>> sendPasswordReset({required String email});

  Future<Either<Failure, Unit>> signOut();

  /// Server role for [uid] (`patient` / `chw` / `doctor`), if present.
  Future<Either<Failure, String?>> fetchUserRole(String uid);
}
