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
import '../bloc/register_bloc.dart';

/// AUTH-03 — new account creation via Firebase Auth.
class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<RegisterBloc>(),
      child: const _RegisterView(),
    );
  }
}

class _RegisterView extends StatefulWidget {
  const _RegisterView();

  @override
  State<_RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<_RegisterView> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: AppGradientBackground(
        child: SafeArea(
          child: BlocConsumer<RegisterBloc, RegisterState>(
            listenWhen: (prev, curr) => prev.status != curr.status,
            listener: (context, state) {
              if (state.status == RegisterStatus.success) {
                context.go(AppRoutes.home);
              } else if (state.status == RegisterStatus.failure &&
                  state.errorMessage != null) {
                context.showSnackBar(state.errorMessage!);
              }
            },
            builder: (context, state) {
              final bloc = context.read<RegisterBloc>();
              final isLoading = state.status == RegisterStatus.submitting;

              return SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
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
                    const SizedBox(height: 24),
                    Text(
                      'Create your account',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w800,
                        height: 1.2,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Join Ubuzima Connect and start managing your health.',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 14.5,
                        height: 1.45,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 28),
                    _AuthField(
                      label: 'Full name',
                      hint: 'Enter your full name',
                      controller: _nameController,
                      prefix: LucideIcons.userRound,
                      onChanged: (v) =>
                          bloc.add(RegisterEvent.nameChanged(v)),
                    ),
                    const SizedBox(height: 14),
                    _AuthField(
                      label: 'Email address',
                      hint: 'you@example.com',
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      prefix: LucideIcons.mail,
                      onChanged: (v) =>
                          bloc.add(RegisterEvent.emailChanged(v)),
                    ),
                    const SizedBox(height: 14),
                    _AuthField(
                      label: 'Password',
                      hint: 'At least 6 characters',
                      controller: _passwordController,
                      obscureText: state.obscurePassword,
                      prefix: LucideIcons.lock,
                      suffix: IconButton(
                        onPressed: () => bloc.add(
                          const RegisterEvent.passwordVisibilityToggled(),
                        ),
                        icon: Icon(
                          state.obscurePassword
                              ? LucideIcons.eyeOff
                              : LucideIcons.eye,
                          size: 20,
                          color: AppColors.textTertiary,
                        ),
                      ),
                      onChanged: (v) =>
                          bloc.add(RegisterEvent.passwordChanged(v)),
                    ),
                    const SizedBox(height: 14),
                    _AuthField(
                      label: 'Confirm password',
                      hint: 'Re-enter your password',
                      controller: _confirmController,
                      obscureText: state.obscurePassword,
                      prefix: LucideIcons.lockKeyhole,
                      onChanged: (v) =>
                          bloc.add(RegisterEvent.confirmPasswordChanged(v)),
                    ),
                    if (state.passwordMismatch != null) ...[
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(
                            LucideIcons.circleAlert,
                            size: 14,
                            color: AppColors.danger,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            state.passwordMismatch!,
                            style: const TextStyle(
                              fontSize: 12.5,
                              color: AppColors.danger,
                            ),
                          ),
                        ],
                      ),
                    ],
                    const SizedBox(height: 28),
                    GradientButton(
                      label: 'Create Account',
                      icon: LucideIcons.userPlus,
                      isLoading: isLoading,
                      onPressed: state.canSubmit && state.passwordMismatch == null
                          ? () => bloc.add(const RegisterEvent.submitted())
                          : null,
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Already have an account? ',
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        GestureDetector(
                          onTap: () => context.go(AppRoutes.login),
                          child: const Text(
                            'Sign in',
                            style: TextStyle(
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
