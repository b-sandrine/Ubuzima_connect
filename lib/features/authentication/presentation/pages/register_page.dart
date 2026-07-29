import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/localization/locale_extensions.dart';
import '../../../../core/routing/app_routes.dart';
import '../../../../core/routing/auth_session.dart' as routing;
import '../../../../core/routing/role_home.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../../../shared/widgets/backgrounds/app_gradient_background.dart';
import '../../../../shared/widgets/branding/ubuzima_wordmark.dart';
import '../../../../shared/widgets/buttons/gradient_button.dart';
import '../../../../shared/widgets/language/language_switcher.dart';
import '../../domain/entities/user_role.dart';
import '../../domain/usecases/get_selected_role.dart';
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
  UserRole? _selectedRole;
  var _roleLoaded = false;

  @override
  void initState() {
    super.initState();
    _loadRole();
  }

  Future<void> _loadRole() async {
    final result = await getIt<GetSelectedRole>()();
    if (!mounted) return;
    result.fold(
      (_) => setState(() {
        _selectedRole = null;
        _roleLoaded = true;
      }),
      (role) => setState(() {
        _selectedRole = role;
        _roleLoaded = true;
      }),
    );
  }

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
    final l10n = context.l10n;
    final role = _selectedRole;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: AppGradientBackground(
        child: SafeArea(
          child: !_roleLoaded
              ? const Center(child: CircularProgressIndicator())
              : BlocConsumer<RegisterBloc, RegisterState>(
                  listenWhen: (prev, curr) => prev.status != curr.status,
                  listener: (context, state) {
                    if (state.status == RegisterStatus.success) {
                      context.go(
                        RoleHome.forRole(_toRoutingRole(role)),
                      );
                    } else if (state.status == RegisterStatus.failure &&
                        state.errorMessage != null) {
                      context.showSnackBar(state.errorMessage!);
                    }
                  },
                  builder: (context, state) {
                    final bloc = context.read<RegisterBloc>();
                    final isLoading =
                        state.status == RegisterStatus.submitting;

                    return SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Row(
                            children: [
                              IconButton(
                                onPressed: () =>
                                    context.go(AppRoutes.roleSelection),
                                icon: const Icon(LucideIcons.arrowLeft),
                                color: AppColors.textPrimary,
                              ),
                              const Spacer(),
                              const LanguageSwitcher(),
                            ],
                          ),
                          const SizedBox(height: 8),
                          const Center(child: UbuzimaWordmark()),
                          const SizedBox(height: 20),
                          Text(
                            l10n.registerTitle,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.w800,
                              height: 1.2,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          if (role != null) ...[
                            const SizedBox(height: 12),
                            Center(
                              child: _RoleBadge(
                                label: _titleFor(role, l10n),
                                icon: _iconFor(role),
                                accent: _accentFor(role),
                                tint: _tintFor(role),
                              ),
                            ),
                          ],
                          const SizedBox(height: 10),
                          Text(
                            l10n.registerSubtitle,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 14.5,
                              height: 1.45,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          const SizedBox(height: 28),
                          _AuthField(
                            label: l10n.registerNameLabel,
                            hint: l10n.registerNameHint,
                            controller: _nameController,
                            prefix: LucideIcons.userRound,
                            onChanged: (v) =>
                                bloc.add(RegisterEvent.nameChanged(v)),
                          ),
                          const SizedBox(height: 14),
                          _AuthField(
                            label: l10n.loginEmailLabel,
                            hint: l10n.loginEmailHint,
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            prefix: LucideIcons.mail,
                            onChanged: (v) =>
                                bloc.add(RegisterEvent.emailChanged(v)),
                          ),
                          const SizedBox(height: 14),
                          _AuthField(
                            label: l10n.loginPasswordLabel,
                            hint: l10n.registerPasswordHint,
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
                                color: const Color(0xFFB0BEC5),
                              ),
                            ),
                            onChanged: (v) =>
                                bloc.add(RegisterEvent.passwordChanged(v)),
                          ),
                          const SizedBox(height: 14),
                          _AuthField(
                            label: l10n.registerConfirmPasswordLabel,
                            hint: l10n.registerConfirmPasswordHint,
                            controller: _confirmController,
                            obscureText: state.obscurePassword,
                            prefix: LucideIcons.lockKeyhole,
                            onChanged: (v) => bloc.add(
                              RegisterEvent.confirmPasswordChanged(v),
                            ),
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
                            label: l10n.createAccount,
                            icon: LucideIcons.userPlus,
                            isLoading: isLoading,
                            onPressed: state.canSubmit &&
                                    state.passwordMismatch == null
                                ? () => bloc.add(
                                    const RegisterEvent.submitted(),
                                  )
                                : null,
                          ),
                          const SizedBox(height: 24),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                l10n.registerHaveAccount,
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                              GestureDetector(
                                onTap: () => context.go(AppRoutes.login),
                                child: Text(
                                  l10n.signIn,
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

  routing.UserRole _toRoutingRole(UserRole? role) => switch (role) {
        UserRole.patient => routing.UserRole.patient,
        UserRole.doctor => routing.UserRole.doctor,
        UserRole.communityHealthWorker =>
          routing.UserRole.communityHealthWorker,
        null => routing.UserRole.unknown,
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
        Theme(
          data: Theme.of(context).copyWith(
            inputDecorationTheme: const InputDecorationTheme(
              filled: false,
              border: InputBorder.none,
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
        ),
      ],
    );
  }
}
