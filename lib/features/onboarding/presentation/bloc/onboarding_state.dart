import 'package:equatable/equatable.dart';

class OnboardingState extends Equatable {
  final int pageIndex;
  final bool isFinishing;
  final bool didFinish;

  const OnboardingState({
    this.pageIndex = 0,
    this.isFinishing = false,
    this.didFinish = false,
  });

  OnboardingState copyWith({
    int? pageIndex,
    bool? isFinishing,
    bool? didFinish,
  }) {
    return OnboardingState(
      pageIndex: pageIndex ?? this.pageIndex,
      isFinishing: isFinishing ?? this.isFinishing,
      didFinish: didFinish ?? this.didFinish,
    );
  }

  @override
  List<Object?> get props => [pageIndex, isFinishing, didFinish];
}
