import 'package:injectable/injectable.dart';

import '../../../../../core/constants/storage_keys.dart';
import '../../../../../core/exceptions/app_exceptions.dart';
import '../../../../../core/storage/local_storage_service.dart';

abstract interface class OnboardingLocalDataSource {
  bool readOnboardingComplete();

  Future<void> cacheOnboardingComplete();
}

@LazySingleton(as: OnboardingLocalDataSource)
class OnboardingLocalDataSourceImpl implements OnboardingLocalDataSource {
  final LocalStorageService _localStorageService;

  const OnboardingLocalDataSourceImpl(this._localStorageService);

  @override
  bool readOnboardingComplete() =>
      _localStorageService.getBool(StorageKeys.onboardingComplete) ?? false;

  @override
  Future<void> cacheOnboardingComplete() async {
    final written = await _localStorageService.setBool(
      StorageKeys.onboardingComplete,
      true,
    );

    if (!written) {
      throw const CacheException('Could not save onboarding progress.');
    }
  }
}
