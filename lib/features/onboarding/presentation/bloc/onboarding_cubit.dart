import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';

import '../../domain/usecases/complete_onboarding.dart';
import 'onboarding_state.dart';

@injectable
class OnboardingCubit extends Cubit<OnboardingState> {
  final CompleteOnboarding _completeOnboarding;

  OnboardingCubit(this._completeOnboarding) : super(const OnboardingState());

  void pageChanged(int index) => emit(state.copyWith(pageIndex: index));

  Future<void> finish() async {
    if (state.isFinishing) return;
    emit(state.copyWith(isFinishing: true));

    final result = await _completeOnboarding();

    result.fold(
      // Even if persistence fails, don't trap the user on the tutorial —
      // they'll just see it again next launch, which is a minor annoyance,
      // not a blocker.
      (_) => emit(state.copyWith(isFinishing: false, didFinish: true)),
      (_) => emit(state.copyWith(isFinishing: false, didFinish: true)),
    );
  }
}
