import 'package:injectable/injectable.dart';

import '../../../../../core/constants/storage_keys.dart';
import '../../../../../core/exceptions/app_exceptions.dart';
import '../../../../../core/storage/local_storage_service.dart';

/// Reads/writes the pre-account role choice. SharedPreferences rather than
/// secure storage: the choice is a UI preference until sign-up turns it
/// into an actual account claim, and nothing is authorized off the back of
/// it.
abstract interface class RoleSelectionLocalDataSource {
  Future<void> cacheSelectedRole(String storageValue);

  String? readSelectedRole();
}

@LazySingleton(as: RoleSelectionLocalDataSource)
class RoleSelectionLocalDataSourceImpl implements RoleSelectionLocalDataSource {
  final LocalStorageService _localStorageService;

  const RoleSelectionLocalDataSourceImpl(this._localStorageService);

  @override
  Future<void> cacheSelectedRole(String storageValue) async {
    final written = await _localStorageService.setString(
      StorageKeys.selectedRole,
      storageValue,
    );

    if (!written) {
      throw const CacheException('Could not save the selected role.');
    }
  }

  @override
  String? readSelectedRole() =>
      _localStorageService.getString(StorageKeys.selectedRole);
}
