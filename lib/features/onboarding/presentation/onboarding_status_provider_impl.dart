import 'package:injectable/injectable.dart';

import '../../../core/routing/onboarding_status.dart';
import '../data/datasources/local/onboarding_local_data_source.dart';

@LazySingleton(as: OnboardingStatusProvider)
class OnboardingStatusProviderImpl implements OnboardingStatusProvider {
  final OnboardingLocalDataSource _localDataSource;

  const OnboardingStatusProviderImpl(this._localDataSource);

  @override
  bool get isComplete => _localDataSource.readOnboardingComplete();
}