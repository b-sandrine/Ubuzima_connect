import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/localization/locale_extensions.dart';
import '../../../../core/routing/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/backgrounds/app_gradient_background.dart';
import '../../../../shared/widgets/branding/ubuzima_wordmark.dart';
import '../../../../shared/widgets/buttons/gradient_button.dart';
import '../bloc/login_bloc.dart';

/// AUTH-02 — email + Google sign-in via Firebase Auth.
class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<LoginBloc>(),
      child: const _LoginView(),
    );
  }
}

class _LoginView extends StatefulWidget {
  const _LoginView();

  @override
  State<_LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<_LoginView> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: AppGradientBackground(
        child: SafeArea(
          child: BlocConsumer<LoginBloc, LoginState>(
            listenWhen: (previous, current) =>
                previous.status != current.status,
            listener: (context, state) {
              if (state.status == LoginStatus.success) {
                context.go(AppRoutes.home);
              } else if (state.status == LoginStatus.failure &&
                  state.errorMessage != null) {
                context.showSnackBar(state.errorMessage!);
              }
            },
            builder: (context, state) {
              final isSubmitting = state.status == LoginStatus.submitting;

              return SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: IconButton(
                        onPressed: () => context.go(AppRoutes.roleSelection),
                        icon: const Icon(LucideIcons.arrowLeft),
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Center(child: UbuzimaWordmark()),
                    const SizedBox(height: 28),
                    Text(
                      l10n.loginWelcomeBack,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                        height: 1.2,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      l10n.loginSubtitle,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 14.5,
                        height: 1.45,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 28),
                    _AuthField(
                      label: l10n.loginEmailLabel,
                      hint: l10n.loginEmailHint,
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      prefix: LucideIcons.mail,
                      onChanged: (value) => context.read<LoginBloc>().add(
                        LoginEvent.emailChanged(value),
                      ),
                    ),
                    const SizedBox(height: 14),
                    _AuthField(
                      label: l10n.loginPasswordLabel,
                      hint: l10n.loginPasswordHint,
                      controller: _passwordController,
                      obscureText: state.obscurePassword,
                      prefix: LucideIcons.lock,
                      suffix: IconButton(
                        onPressed: () => context.read<LoginBloc>().add(
                          const LoginEvent.passwordVisibilityToggled(),
                        ),
                        icon: Icon(
                          state.obscurePassword
                              ? LucideIcons.eyeOff
                              : LucideIcons.eye,
                          size: 20,
                          color: AppColors.textTertiary,
                        ),
                      ),
                      onChanged: (value) => context.read<LoginBloc>().add(
                        LoginEvent.passwordChanged(value),
                      ),
                    ),
                    const SizedBox(height: 24),
                    GradientButton(
                      label: l10n.signIn,
                      icon: LucideIcons.logIn,
                      isLoading: isSubmitting,
                      onPressed: state.canSubmit
                          ? () => context.read<LoginBloc>().add(
                              const LoginEvent.submitted(),
                            )
                          : null,
                    ),
                    const SizedBox(height: 18),
                    Row(
                      children: [
                        const Expanded(child: Divider(color: AppColors.border)),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Text(
                            l10n.loginOrContinueWith,
                            style: const TextStyle(
                              fontSize: 12.5,
                              color: AppColors.textTertiary,
                            ),
                          ),
                        ),
                        const Expanded(child: Divider(color: AppColors.border)),
                      ],
                    ),
                    const SizedBox(height: 18),
                    OutlinedPillButton(
                      label: l10n.loginWithGoogle,
                      onPressed: isSubmitting
                          ? null
                          : () => context.read<LoginBloc>().add(
                              const LoginEvent.googleSignInRequested(),
                            ),
                    ),
                    const SizedBox(height: 28),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          l10n.loginNoAccount,
                          style: const TextStyle(
                            fontSize: 14,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        GestureDetector(
                          onTap: () => context.go(AppRoutes.register),
                          child: Text(
                            l10n.createAccount,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                      ],
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

class _AuthField extends StatelessWidget {
  final String label;
  final String? hint;
  final TextEditingController? controller;
  final bool obscureText;
  final TextInputType keyboardType;
  final IconData? prefix;
  final Widget? suffix;
  final ValueChanged<String>? onChanged;

  const _AuthField({
    required this.label,
    this.hint,
    this.controller,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.prefix,
    this.suffix,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          label,
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
            controller: controller,
            obscureText: obscureText,
            keyboardType: keyboardType,
            onChanged: onChanged,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: AppColors.textPrimary,
            ),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: const TextStyle(
                color: AppColors.textTertiary,
                fontWeight: FontWeight.w400,
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
              prefixIcon: prefix == null
                  ? null
                  : Icon(prefix, size: 20, color: AppColors.textTertiary),
              suffixIcon: suffix,
            ),
          ),
        ),
      ],
    );
  }
}
