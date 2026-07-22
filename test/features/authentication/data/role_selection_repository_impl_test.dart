import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ubuzima_connect/core/errors/failure.dart';
import 'package:ubuzima_connect/core/exceptions/app_exceptions.dart';
import 'package:ubuzima_connect/features/authentication/data/datasources/local/role_selection_local_data_source.dart';
import 'package:ubuzima_connect/features/authentication/data/repositories/role_selection_repository_impl.dart';
import 'package:ubuzima_connect/features/authentication/domain/entities/user_role.dart';

class _MockLocalDataSource extends Mock
    implements RoleSelectionLocalDataSource {}

void main() {
  late _MockLocalDataSource localDataSource;
  late RoleSelectionRepositoryImpl repository;

  setUp(() {
    localDataSource = _MockLocalDataSource();
    repository = RoleSelectionRepositoryImpl(localDataSource);
  });

  group('saveSelectedRole', () {
    test('writes the role storage value and returns unit', () async {
      when(
        () => localDataSource.cacheSelectedRole(any()),
      ).thenAnswer((_) async {});

      final result = await repository.saveSelectedRole(UserRole.doctor);

      expect(result, const Right<Failure, Unit>(unit));
      verify(() => localDataSource.cacheSelectedRole('doctor')).called(1);
    });

    test('translates a CacheException into a CacheFailure', () async {
      when(
        () => localDataSource.cacheSelectedRole(any()),
      ).thenThrow(const CacheException('disk full'));

      final result = await repository.saveSelectedRole(UserRole.patient);

      expect(result, const Left<Failure, Unit>(CacheFailure('disk full')));
    });
  });

  group('getSelectedRole', () {
    test('maps the stored value back to a role', () async {
      when(() => localDataSource.readSelectedRole()).thenReturn('chw');

      final result = await repository.getSelectedRole();

      expect(
        result,
        const Right<Failure, UserRole?>(UserRole.communityHealthWorker),
      );
    });

    test('returns null when nothing has been chosen yet', () async {
      when(() => localDataSource.readSelectedRole()).thenReturn(null);

      final result = await repository.getSelectedRole();

      expect(result, const Right<Failure, UserRole?>(null));
    });

    test('returns null for a value written by an older app version', () async {
      when(() => localDataSource.readSelectedRole()).thenReturn('nurse');

      final result = await repository.getSelectedRole();

      expect(result, const Right<Failure, UserRole?>(null));
    });
  });
}
