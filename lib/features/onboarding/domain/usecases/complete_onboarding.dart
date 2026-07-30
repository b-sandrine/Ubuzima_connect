import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/failure.dart';
import '../repositories/onboarding_repository.dart';

@injectable
class CompleteOnboarding {
  final OnboardingRepository _repository;

  const CompleteOnboarding(this._repository);

  Future<Either<Failure, Unit>> call() => _repository.completeOnboarding();
}
