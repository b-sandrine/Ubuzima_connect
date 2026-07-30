import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/failure.dart';
import '../repositories/onboarding_repository.dart';

@injectable
class GetOnboardingComplete {
  final OnboardingRepository _repository;

  const GetOnboardingComplete(this._repository);

  Future<Either<Failure, bool>> call() => _repository.isOnboardingComplete();
}
