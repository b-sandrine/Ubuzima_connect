import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/localization/locale_extensions.dart';
import '../../../../core/routing/app_routes.dart';
import '../../../../core/routing/auth_session.dart' as routing;
import '../../../../core/routing/role_home.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../../../shared/widgets/branding/ubuzima_wordmark.dart';
import '../../../../shared/widgets/buttons/gradient_button.dart';
import '../../../../shared/widgets/language/language_switcher.dart';
import '../../domain/entities/user_role.dart';
import '../bloc/login_bloc.dart';

/// AUTH-02 for Patient / Doctor — email sign-in with role badge, matching the
/// CHW login visual language without the phone-first CHW extras.
class RoleLoginView extends StatefulWidget {
  final UserRole role;

  const RoleLoginView({super.key, required this.role});

  @override
  State<RoleLoginView> createState() => _RoleLoginViewState();
}

class _RoleLoginViewState extends State<RoleLoginView> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<LoginBloc>().add(
        const LoginEvent.loginMethodChanged(LoginMethod.email),
      );
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final accent = _accentFor(widget.role);
    final tint = _tintFor(widget.role);

    return BlocConsumer<LoginBloc, LoginState>(
      listenWhen: (previous, current) => previous.status != current.status,
      listener: (context, state) {
        if (state.status == LoginStatus.success) {
          context.go(RoleHome.forRole(_toRoutingRole(widget.role)));
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
                child: _RoleBadge(
                  label: _titleFor(widget.role, l10n),
                  icon: _iconFor(widget.role),
                  accent: accent,
                  tint: tint,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                _subtitleFor(widget.role, l10n),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 14.5,
                  height: 1.45,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 22),
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
                      OutlinedPillButton(
                        label: l10n.loginWithGoogle,
                        onPressed: isSubmitting
                            ? null
                            : () => bloc.add(
                                const LoginEvent.googleSignInRequested(),
                              ),
                      ),
                    ],
                  ),
                ),
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
            ],
          ),
        );
      },
    );
  }

  routing.UserRole _toRoutingRole(UserRole role) => switch (role) {
        UserRole.patient => routing.UserRole.patient,
        UserRole.doctor => routing.UserRole.doctor,
        UserRole.communityHealthWorker =>
          routing.UserRole.communityHealthWorker,
      };

  IconData _iconFor(UserRole role) => switch (role) {
        UserRole.patient => LucideIcons.personStanding,
        UserRole.doctor => LucideIcons.stethoscope,
        UserRole.communityHealthWorker => LucideIcons.userRound,
      };

  Color _accentFor(UserRole role) => switch (role) {
        UserRole.patient => AppColors.rolePatient,
        UserRole.doctor => AppColors.roleDoctor,
        UserRole.communityHealthWorker => AppColors.roleChw,
      };

  Color _tintFor(UserRole role) => switch (role) {
        UserRole.patient => AppColors.rolePatientTint,
        UserRole.doctor => AppColors.roleDoctorTint,
        UserRole.communityHealthWorker => AppColors.roleChwTint,
      };

  String _titleFor(UserRole role, AppLocalizations l10n) => switch (role) {
        UserRole.patient => l10n.rolePatient,
        UserRole.doctor => l10n.roleDoctor,
        UserRole.communityHealthWorker => l10n.roleCommunityHealthWorker,
      };

  String _subtitleFor(UserRole role, AppLocalizations l10n) => switch (role) {
        UserRole.patient => l10n.loginPatientSubtitle,
        UserRole.doctor => l10n.loginDoctorSubtitle,
        UserRole.communityHealthWorker => l10n.loginChwSubtitle,
      };
}

class _RoleBadge extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color accent;
  final Color tint;

  const _RoleBadge({
    required this.label,
    required this.icon,
    required this.accent,
    required this.tint,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: tint,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: accent.withValues(alpha: 0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 15, color: accent),
          const SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: accent,
            ),
          ),
        ],
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
          color: const Color(0xFFF9FAFB),
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
