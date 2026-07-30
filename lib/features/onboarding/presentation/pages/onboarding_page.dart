import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/localization/locale_extensions.dart';
import '../../../../core/routing/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/backgrounds/app_gradient_background.dart';
import '../../../../shared/widgets/language/language_switcher.dart';
import '../bloc/onboarding_cubit.dart';
import '../bloc/onboarding_state.dart';
import '../widgets/onboarding_slide.dart';

/// TUTORIAL-01. Reachable at [AppRoutes.onboarding] — the seam for wiring
/// it into the real cold-start flow is `core/routing/route_guards.dart`
/// (documented there): once `GetOnboardingComplete` returns false, redirect
/// here before `AppRoutes.roleSelection` rather than showing role
/// selection directly.
class OnboardingPage extends StatelessWidget {
  const OnboardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<OnboardingCubit>(),
      child: const _OnboardingView(),
    );
  }
}

class _OnboardingView extends StatefulWidget {
  const _OnboardingView();

  @override
  State<_OnboardingView> createState() => _OnboardingViewState();
}

class _OnboardingViewState extends State<_OnboardingView> {
  late final PageController _controller;

  @override
  void initState() {
    super.initState();
    _controller = PageController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  List<OnboardingSlideData> _slides(BuildContext context) {
    final l10n = context.l10n;
    return [
      OnboardingSlideData(
        icon: Icons.favorite_rounded,
        title: l10n.onboardingSlide1Title,
        body: l10n.onboardingSlide1Body,
        accent: AppColors.rolePatient,
      ),
      OnboardingSlideData(
        icon: Icons.route_rounded,
        title: l10n.onboardingSlide2Title,
        body: l10n.onboardingSlide2Body,
        accent: AppColors.roleChw,
      ),
      OnboardingSlideData(
        icon: Icons.cloud_off_rounded,
        title: l10n.onboardingSlide3Title,
        body: l10n.onboardingSlide3Body,
        accent: AppColors.roleDoctor,
      ),
    ];
  }

  void _finish(BuildContext context) {
    context.read<OnboardingCubit>().finish();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final slides = _slides(context);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: AppGradientBackground(
        child: SafeArea(
          child: BlocConsumer<OnboardingCubit, OnboardingState>(
            listenWhen: (prev, curr) => !prev.didFinish && curr.didFinish,
            listener: (context, state) {
              context.go(AppRoutes.roleSelection);
            },
            builder: (context, state) {
              final isLast = state.pageIndex == slides.length - 1;

              final canGoBack = Navigator.of(context).canPop();

              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(12, 12, 20, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            if (canGoBack)
                              IconButton(
                                onPressed: () =>
                                    Navigator.of(context).maybePop(),
                                icon: const Icon(
                                  Icons.arrow_back,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            const LanguageSwitcher(),
                          ],
                        ),
                        TextButton(
                          onPressed: state.isFinishing
                              ? null
                              : () => _finish(context),
                          child: Text(
                            l10n.onboardingSkip,
                            style: const TextStyle(
                              fontWeight: FontWeight.w700,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: PageView.builder(
                      controller: _controller,
                      itemCount: slides.length,
                      onPageChanged: (i) =>
                          context.read<OnboardingCubit>().pageChanged(i),
                      itemBuilder: (context, i) =>
                          OnboardingSlideView(data: slides[i]),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24, 0, 24, 28),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            for (var i = 0; i < slides.length; i++)
                              AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 4,
                                ),
                                width: i == state.pageIndex ? 22 : 8,
                                height: 8,
                                decoration: BoxDecoration(
                                  color: i == state.pageIndex
                                      ? AppColors.primary
                                      : AppColors.border,
                                  borderRadius: BorderRadius.circular(999),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 22),
                        SizedBox(
                          width: double.infinity,
                          height: 52,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                              elevation: 0,
                            ),
                            onPressed: state.isFinishing
                                ? null
                                : () {
                                    if (isLast) {
                                      _finish(context);
                                    } else {
                                      _controller.nextPage(
                                        duration: const Duration(
                                          milliseconds: 300,
                                        ),
                                        curve: Curves.easeInOut,
                                      );
                                    }
                                  },
                            child: state.isFinishing
                                ? const SizedBox(
                                    width: 22,
                                    height: 22,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2.4,
                                      color: Colors.white,
                                    ),
                                  )
                                : Text(
                                    isLast
                                        ? l10n.onboardingGetStarted
                                        : l10n.onboardingNext,
                                    style: const TextStyle(
                                      fontSize: 15.5,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
