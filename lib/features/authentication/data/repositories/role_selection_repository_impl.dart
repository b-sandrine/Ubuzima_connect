import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/failure.dart';
import '../../../../core/exceptions/app_exceptions.dart';
import '../../domain/entities/user_role.dart';
import '../../domain/repositories/role_selection_repository.dart';
import '../datasources/local/role_selection_local_data_source.dart';

@LazySingleton(as: RoleSelectionRepository)
class RoleSelectionRepositoryImpl implements RoleSelectionRepository {
  final RoleSelectionLocalDataSource _localDataSource;

  const RoleSelectionRepositoryImpl(this._localDataSource);

  @override
  Future<Either<Failure, Unit>> saveSelectedRole(UserRole role) async {
    try {
      await _localDataSource.cacheSelectedRole(role.storageValue);
      return const Right(unit);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserRole?>> getSelectedRole() async {
    try {
      final stored = _localDataSource.readSelectedRole();
      return Right(UserRole.fromStorageValue(stored));
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }
}
