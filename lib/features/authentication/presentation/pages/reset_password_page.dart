import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/routing/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/backgrounds/app_gradient_background.dart';
import '../../../../shared/widgets/branding/ubuzima_wordmark.dart';
import '../../../../shared/widgets/buttons/gradient_button.dart';
import '../bloc/reset_password_bloc.dart';

/// AUTH-04 — sends a Firebase password-reset email.
class ResetPasswordPage extends StatelessWidget {
  const ResetPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<ResetPasswordBloc>(),
      child: const _ResetView(),
    );
  }
}

class _ResetView extends StatefulWidget {
  const _ResetView();

  @override
  State<_ResetView> createState() => _ResetViewState();
}

class _ResetViewState extends State<_ResetView> {
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: AppGradientBackground(
        child: SafeArea(
          child: BlocConsumer<ResetPasswordBloc, ResetPasswordState>(
            listenWhen: (prev, curr) => prev.status != curr.status,
            listener: (context, state) {
              if (state.status == ResetPasswordStatus.failure &&
                  state.errorMessage != null) {
                context.showSnackBar(state.errorMessage!);
              }
            },
            builder: (context, state) {
              final bloc = context.read<ResetPasswordBloc>();
              final isLoading =
                  state.status == ResetPasswordStatus.submitting;
              final emailSent = state.status == ResetPasswordStatus.sent;

              return Padding(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: IconButton(
                        onPressed: () => context.go(AppRoutes.login),
                        icon: const Icon(LucideIcons.arrowLeft),
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Center(child: UbuzimaWordmark()),
                    const SizedBox(height: 32),
                    Center(
                      child: Container(
                        width: 72,
                        height: 72,
                        decoration: BoxDecoration(
                          color: emailSent
                              ? AppColors.roleChwTint
                              : const Color(0xFFEFF6FF),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          emailSent
                              ? LucideIcons.mailCheck
                              : LucideIcons.lockKeyhole,
                          size: 32,
                          color: emailSent
                              ? AppColors.primary
                              : AppColors.secondary,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      emailSent ? 'Check your email' : 'Forgot password?',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w800,
                        height: 1.2,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      emailSent
                          ? 'We sent a reset link to ${state.email}. Check your inbox and follow the instructions.'
                          : 'Enter the email address linked to your account and we\'ll send you a reset link.',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 14.5,
                        height: 1.5,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 32),
                    if (!emailSent) ...[
                      Text(
                        'Email address',
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      DecoratedBox(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppColors.border),
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0x0A0F172A),
                              blurRadius: 8,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: TextField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          onChanged: (v) => bloc.add(
                            ResetPasswordEvent.emailChanged(v),
                          ),
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: AppColors.textPrimary,
                          ),
                          decoration: const InputDecoration(
                            hintText: 'you@example.com',
                            hintStyle: TextStyle(
                              color: AppColors.textTertiary,
                              fontWeight: FontWeight.w400,
                            ),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 16,
                            ),
                            prefixIcon: Icon(
                              LucideIcons.mail,
                              size: 20,
                              color: AppColors.textTertiary,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      GradientButton(
                        label: 'Send reset link',
                        icon: LucideIcons.send,
                        isLoading: isLoading,
                        onPressed: state.canSubmit
                            ? () =>
                                bloc.add(const ResetPasswordEvent.submitted())
                            : null,
                      ),
                    ] else ...[
                      GradientButton(
                        label: 'Back to sign in',
                        icon: LucideIcons.logIn,
                        onPressed: () => context.go(AppRoutes.login),
                      ),
                      const SizedBox(height: 16),
                      OutlinedPillButton(
                        label: 'Resend email',
                        onPressed: () {
                          bloc.add(const ResetPasswordEvent.submitted());
                        },
                      ),
                    ],
                    const Spacer(),
                    GestureDetector(
                      onTap: () => context.go(AppRoutes.login),
                      child: const Text(
                        'Back to sign in',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
