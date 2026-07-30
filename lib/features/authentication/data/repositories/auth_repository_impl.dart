import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/failure.dart';
import '../../../../core/exceptions/app_exceptions.dart';
import '../../domain/entities/auth_user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/remote/firebase_auth_remote_data_source.dart';

@LazySingleton(as: AuthRepository)
class AuthRepositoryImpl implements AuthRepository {
  final FirebaseAuthRemoteDataSource _remoteDataSource;

  const AuthRepositoryImpl(this._remoteDataSource);

  @override
  AuthUser? get currentUser => _remoteDataSource.currentUser?.toEntity();

  @override
  Stream<AuthUser?> get authStateChanges =>
      _remoteDataSource.authStateChanges.map((user) => user?.toEntity());

  @override
  Future<Either<Failure, AuthUser>> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final user = await _remoteDataSource.signInWithEmail(
        email: email,
        password: password,
      );
      return Right(user.toEntity());
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, AuthUser>> signInWithGoogle() async {
    try {
      final user = await _remoteDataSource.signInWithGoogle();
      return Right(user.toEntity());
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, AuthUser>> registerWithEmail({
    required String email,
    required String password,
    required String displayName,
    required String role,
  }) async {
    try {
      final user = await _remoteDataSource.registerWithEmail(
        email: email,
        password: password,
        displayName: displayName,
        role: role,
      );
      return Right(user.toEntity());
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> sendPasswordReset({
    required String email,
  }) async {
    try {
      await _remoteDataSource.sendPasswordReset(email: email);
      return const Right(unit);
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> signOut() async {
    try {
      await _remoteDataSource.signOut();
      return const Right(unit);
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, String?>> fetchUserRole(String uid) async {
    try {
      final role = await _remoteDataSource.fetchUserRole(uid);
      return Right(role);
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }
}
