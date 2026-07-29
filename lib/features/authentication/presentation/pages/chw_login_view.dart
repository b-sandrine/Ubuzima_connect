import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/localization/locale_extensions.dart';
import '../../../../core/routing/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/branding/ubuzima_wordmark.dart';
import '../../../../shared/widgets/buttons/gradient_button.dart';
import '../../../../shared/widgets/language/language_switcher.dart';
import '../bloc/login_bloc.dart';

/// AUTH-02 (CHW) — phone-first sign-in matching the Ubuzima CHW login design.
class ChwLoginView extends StatefulWidget {
  const ChwLoginView({super.key});

  @override
  State<ChwLoginView> createState() => _ChwLoginViewState();
}

class _ChwLoginViewState extends State<ChwLoginView> {
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _phoneController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return BlocConsumer<LoginBloc, LoginState>(
      listenWhen: (previous, current) => previous.status != current.status,
      listener: (context, state) {
        if (state.status == LoginStatus.success) {
          context.go(AppRoutes.chwDashboard);
        } else if (state.status == LoginStatus.failure &&
            state.errorMessage != null) {
          context.showSnackBar(state.errorMessage!);
        }
      },
      builder: (context, state) {
        final bloc = context.read<LoginBloc>();
        final isSubmitting = state.status == LoginStatus.submitting;

        return SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Align(
                alignment: Alignment.centerRight,
                child: LanguageSwitcher(),
              ),
              const SizedBox(height: 16),
              const Center(child: UbuzimaWordmark()),
              const SizedBox(height: 20),
              Text(
                l10n.loginWelcomeBackChw,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  height: 1.2,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 12),
              Center(
                child: _RoleBadge(label: l10n.roleCommunityHealthWorker),
              ),
              const SizedBox(height: 10),
              Text(
                l10n.loginChwSubtitle,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 14.5,
                  height: 1.45,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 18),
              const _OfflineAccessBanner(),
              const SizedBox(height: 18),
              DecoratedBox(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: AppColors.border),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x0D0F172A),
                      blurRadius: 20,
                      offset: Offset(0, 6),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(18, 18, 18, 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _LoginMethodToggle(
                        method: state.loginMethod,
                        onChanged: (method) =>
                            bloc.add(LoginEvent.loginMethodChanged(method)),
                      ),
                      const SizedBox(height: 18),
                      if (state.loginMethod == LoginMethod.phone) ...[
                        _FieldLabel(label: l10n.loginPhoneLabel),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const _CountryCodeField(),
                            const SizedBox(width: 10),
                            Expanded(
                              child: _AuthInput(
                                controller: _phoneController,
                                hint: l10n.loginPhoneHint,
                                keyboardType: TextInputType.phone,
                                onChanged: (value) =>
                                    bloc.add(LoginEvent.phoneChanged(value)),
                              ),
                            ),
                          ],
                        ),
                      ] else ...[
                        _FieldLabel(label: l10n.loginEmailLabel),
                        const SizedBox(height: 8),
                        _AuthInput(
                          controller: _emailController,
                          hint: l10n.loginEmailHint,
                          keyboardType: TextInputType.emailAddress,
                          prefix: LucideIcons.mail,
                          onChanged: (value) =>
                              bloc.add(LoginEvent.emailChanged(value)),
                        ),
                      ],
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          _FieldLabel(label: l10n.loginPasswordLabel),
                          const Spacer(),
                          GestureDetector(
                            onTap: () => context.go(AppRoutes.resetPassword),
                            child: Text(
                              l10n.loginForgotPassword,
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      _AuthInput(
                        controller: _passwordController,
                        hint: l10n.loginPasswordHint,
                        obscureText: state.obscurePassword,
                        prefix: LucideIcons.lock,
                        suffix: IconButton(
                          onPressed: () => bloc.add(
                            const LoginEvent.passwordVisibilityToggled(),
                          ),
                          icon: Icon(
                            state.obscurePassword
                                ? LucideIcons.eyeOff
                                : LucideIcons.eye,
                            size: 20,
                            color: const Color(0xFFB0BEC5),
                          ),
                        ),
                        onChanged: (value) =>
                            bloc.add(LoginEvent.passwordChanged(value)),
                      ),
                      const SizedBox(height: 14),
                      _RememberMeRow(
                        value: state.rememberMe,
                        onChanged: (value) =>
                            bloc.add(LoginEvent.rememberMeToggled(value)),
                      ),
                      const SizedBox(height: 20),
                      GradientButton(
                        label: l10n.signIn,
                        icon: LucideIcons.logIn,
                        isLoading: isSubmitting,
                        onPressed: state.canSubmit
                            ? () => bloc.add(const LoginEvent.submitted())
                            : null,
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          const Expanded(child: Divider(color: AppColors.border)),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: Text(
                              l10n.loginOrContinueWithLower,
                              style: const TextStyle(
                                fontSize: 12.5,
                                color: AppColors.textTertiary,
                              ),
                            ),
                          ),
                          const Expanded(child: Divider(color: AppColors.border)),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: _AltLoginButton(
                              label: l10n.loginBiometric,
                              icon: LucideIcons.fingerprint,
                              color: AppColors.primary,
                              onPressed: () => context.showSnackBar(
                                l10n.loginFeatureComingSoon,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _AltLoginButton(
                              label: l10n.loginQrCode,
                              icon: LucideIcons.qrCode,
                              color: AppColors.secondary,
                              onPressed: () => context.showSnackBar(
                                l10n.loginFeatureComingSoon,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              _ContinueOfflineButton(
                onPressed: () => context.go(AppRoutes.chwDashboard),
              ),
              const SizedBox(height: 24),
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
              const SizedBox(height: 22),
              Text(
                l10n.securedAndTrusted,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 11.5,
                  color: AppColors.textTertiary,
                ),
              ),
              const SizedBox(height: 10),
              const _TrustFooter(),
            ],
          ),
        );
      },
    );
  }
}

class _RoleBadge extends StatelessWidget {
  final String label;

  const _RoleBadge({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.roleChwTint,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: AppColors.roleChw.withValues(alpha: 0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            LucideIcons.userRound,
            size: 15,
            color: AppColors.roleChw,
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: AppColors.roleChw,
            ),
          ),
        ],
      ),
    );
  }
}

class _OfflineAccessBanner extends StatelessWidget {
  const _OfflineAccessBanner();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF7ED),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFFED7AA)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: const Color(0xFFFFEDD5),
              shape: BoxShape.circle,
              border: Border.all(
                color: AppColors.warning.withValues(alpha: 0.25),
              ),
            ),
            child: const Icon(
              LucideIcons.wifi,
              size: 17,
              color: AppColors.warning,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: const TextStyle(
                  fontSize: 12.5,
                  height: 1.45,
                  color: Color(0xFF9A3412),
                ),
                children: [
                  TextSpan(
                    text: l10n.loginOfflineAccessTitle,
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                  const TextSpan(
                    text: ' • ',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                  TextSpan(text: l10n.loginOfflineAccessMessage),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LoginMethodToggle extends StatelessWidget {
  final LoginMethod method;
  final ValueChanged<LoginMethod> onChanged;

  const _LoginMethodToggle({
    required this.method,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: Row(
          children: [
            Expanded(
              child: _MethodTab(
                label: l10n.loginPhoneTab,
                icon: LucideIcons.phone,
                isActive: method == LoginMethod.phone,
                onTap: () => onChanged(LoginMethod.phone),
              ),
            ),
            Expanded(
              child: _MethodTab(
                label: l10n.loginEmailTab,
                icon: LucideIcons.mail,
                isActive: method == LoginMethod.email,
                onTap: () => onChanged(LoginMethod.email),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MethodTab extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isActive;
  final VoidCallback onTap;

  const _MethodTab({
    required this.label,
    required this.icon,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = isActive ? AppColors.primary : AppColors.textTertiary;

    return Material(
      color: isActive ? Colors.white : Colors.transparent,
      borderRadius: BorderRadius.circular(12),
      elevation: isActive ? 1 : 0,
      shadowColor: const Color(0x1A0F172A),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 16, color: color),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  final String label;

  const _FieldLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: AppColors.textSecondary,
      ),
    );
  }
}

class _CountryCodeField extends StatelessWidget {
  const _CountryCodeField();

  /// Very light fill — almost white, just enough to separate from the card.
  static const Color fieldFill = Color(0xFFF9FAFB);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 96,
      height: 52,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: fieldFill,
        borderRadius: BorderRadius.circular(26),
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '+250',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(width: 4),
          Icon(
            LucideIcons.chevronDown,
            size: 16,
            color: Color(0xFFB0BEC5),
          ),
        ],
      ),
    );
  }
}

class _AuthInput extends StatelessWidget {
  final TextEditingController? controller;
  final String? hint;
  final bool obscureText;
  final TextInputType keyboardType;
  final IconData? prefix;
  final Widget? suffix;
  final ValueChanged<String>? onChanged;

  const _AuthInput({
    this.controller,
    this.hint,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.prefix,
    this.suffix,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Theme(
      // Prevent the global filled input theme from darkening these fields.
      data: Theme.of(context).copyWith(
        inputDecorationTheme: const InputDecorationTheme(
          filled: false,
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
        ),
      ),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: _CountryCodeField.fieldFill,
          borderRadius: BorderRadius.circular(26),
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
              color: Color(0xFFB0BEC5),
              fontWeight: FontWeight.w400,
            ),
            filled: true,
            fillColor: Colors.transparent,
            border: InputBorder.none,
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 18,
              vertical: 16,
            ),
            prefixIcon: prefix == null
                ? null
                : Icon(prefix, size: 18, color: const Color(0xFFB0BEC5)),
            suffixIcon: suffix,
          ),
        ),
      ),
    );
  }
}

class _RememberMeRow extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;

  const _RememberMeRow({
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onChanged(!value),
      borderRadius: BorderRadius.circular(8),
      child: Row(
        children: [
          SizedBox(
            width: 22,
            height: 22,
            child: Checkbox(
              value: value,
              onChanged: (checked) => onChanged(checked ?? false),
              activeColor: AppColors.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
              side: const BorderSide(color: AppColors.border),
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              context.l10n.loginRememberMe,
              style: const TextStyle(
                fontSize: 13.5,
                color: AppColors.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AltLoginButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onPressed;

  const _AltLoginButton({
    required this.label,
    required this.icon,
    required this.color,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          height: 72,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 22, color: color),
              const SizedBox(height: 8),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ContinueOfflineButton extends StatelessWidget {
  final VoidCallback onPressed;

  const _ContinueOfflineButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          height: 56,
          padding: const EdgeInsets.symmetric(horizontal: 18),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFFED7AA)),
            boxShadow: const [
              BoxShadow(
                color: Color(0x080F172A),
                blurRadius: 8,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              const Icon(
                LucideIcons.cloudDownload,
                size: 20,
                color: AppColors.warning,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  context.l10n.loginContinueOffline,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF9A3412),
                  ),
                ),
              ),
              const Icon(
                LucideIcons.chevronRight,
                size: 20,
                color: AppColors.warning,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TrustFooter extends StatelessWidget {
  const _TrustFooter();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _TrustBadge(
          icon: LucideIcons.shieldCheck,
          label: l10n.trustHipaaAligned,
          color: AppColors.primary,
        ),
        const _TrustDivider(),
        _TrustBadge(
          icon: LucideIcons.wifiOff,
          label: l10n.trustOfflineReady,
          color: AppColors.secondary,
        ),
        const _TrustDivider(),
        _TrustBadge(
          icon: LucideIcons.flag,
          label: l10n.trustMadeForRwanda,
          color: AppColors.warning,
        ),
      ],
    );
  }
}

class _TrustDivider extends StatelessWidget {
  const _TrustDivider();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: 22,
      margin: const EdgeInsets.symmetric(horizontal: 12),
      color: AppColors.border,
    );
  }
}

class _TrustBadge extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _TrustBadge({
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: color),
        const SizedBox(width: 5),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 66),
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 10.5,
              height: 1.15,
              color: AppColors.textSecondary,
            ),
          ),
        ),
      ],
    );
  }
}
