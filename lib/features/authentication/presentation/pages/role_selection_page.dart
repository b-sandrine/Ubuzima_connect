import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/localization/locale_extensions.dart';
import '../../../../core/routing/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../../../shared/widgets/backgrounds/app_gradient_background.dart';
import '../../../../shared/widgets/branding/ubuzima_wordmark.dart';
import '../../../../shared/widgets/buttons/gradient_button.dart';
import '../../../../shared/widgets/language/language_switcher.dart';
import '../../domain/entities/user_role.dart';
import '../bloc/role_selection_bloc.dart';
import '../widgets/role_option_card.dart';

/// AUTH-05 — the first thing a new user sees. The chosen role is saved
/// on-device and read back by sign-up, so the decision survives the user
/// closing the app mid-onboarding.
class RoleSelectionPage extends StatelessWidget {
  const RoleSelectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          getIt<RoleSelectionBloc>()..add(const RoleSelectionEvent.started()),
      child: const _RoleSelectionView(),
    );
  }
}

class _RoleSelectionView extends StatelessWidget {
  const _RoleSelectionView();

  /// Design order, which leads with CHW rather than following the
  /// declaration order of [UserRole].
  static const List<UserRole> _displayOrder = [
    UserRole.communityHealthWorker,
    UserRole.patient,
    UserRole.doctor,
  ];

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: AppGradientBackground(
        child: SafeArea(
          child: BlocConsumer<RoleSelectionBloc, RoleSelectionState>(
            listenWhen: (previous, current) =>
                previous.status != current.status,
            listener: (context, state) {
              switch (state.status) {
                case RoleSelectionStatus.saved:
                  context.go(
                    state.destination == AuthDestination.createAccount
                        ? AppRoutes.register
                        : AppRoutes.login,
                  );
                case RoleSelectionStatus.failure:
                  context.showSnackBar(
                    state.errorMessage ?? l10n.somethingWentWrong,
                  );
                case RoleSelectionStatus.editing:
                case RoleSelectionStatus.saving:
                  break;
              }
            },
            builder: (context, state) {
              final isSaving = state.status == RoleSelectionStatus.saving;

              return SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Align(
                      alignment: Alignment.centerRight,
                      child: LanguageSwitcher(),
                    ),
                    const SizedBox(height: 24),
                    const Center(child: UbuzimaWordmark()),
                    const SizedBox(height: 20),
                    const _HeroImage(),
                    const SizedBox(height: 20),
                    _Eyebrow(label: l10n.rwandaHealth),
                    const SizedBox(height: 10),
                    Text(
                      l10n.roleSelectionTitle,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w800,
                        height: 1.2,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      l10n.roleSelectionSubtitle,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 14.5,
                        height: 1.45,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      l10n.selectYourRole.toUpperCase(),
                      style: const TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.2,
                        color: AppColors.textTertiary,
                      ),
                    ),
                    const SizedBox(height: 12),
                    for (final role in _displayOrder) ...[
                      RoleOptionCard(
                        icon: _iconFor(role),
                        title: _titleFor(role, l10n),
                        badge: _badgeFor(role, l10n),
                        description: _descriptionFor(role, l10n),
                        accent: _accentFor(role),
                        accentTint: _accentTintFor(role),
                        isSelected: state.highlightedRole == role,
                        onTap: () => context.read<RoleSelectionBloc>().add(
                          RoleSelectionEvent.roleHighlighted(role),
                        ),
                      ),
                      const SizedBox(height: 12),
                    ],
                    const SizedBox(height: 8),
                    GradientButton(
                      label: l10n.signIn,
                      icon: Icons.login,
                      isLoading:
                          isSaving &&
                          state.destination == AuthDestination.signIn,
                      onPressed: state.canConfirm
                          ? () => context.read<RoleSelectionBloc>().add(
                              const RoleSelectionEvent.confirmed(
                                AuthDestination.signIn,
                              ),
                            )
                          : null,
                    ),
                    const SizedBox(height: 12),
                    OutlinedPillButton(
                      label: l10n.createAccount,
                      icon: Icons.person_add_alt_1,
                      onPressed: state.canConfirm
                          ? () => context.read<RoleSelectionBloc>().add(
                              const RoleSelectionEvent.confirmed(
                                AuthDestination.createAccount,
                              ),
                            )
                          : null,
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
                    _TrustFooter(l10n: l10n),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  IconData _iconFor(UserRole role) => switch (role) {
    UserRole.patient => Icons.accessibility_new,
    UserRole.communityHealthWorker => Icons.badge_outlined,
    UserRole.doctor => Icons.medical_services_outlined,
  };

  Color _accentFor(UserRole role) => switch (role) {
    UserRole.patient => AppColors.rolePatient,
    UserRole.communityHealthWorker => AppColors.roleChw,
    UserRole.doctor => AppColors.roleDoctor,
  };

  Color _accentTintFor(UserRole role) => switch (role) {
    UserRole.patient => AppColors.rolePatientTint,
    UserRole.communityHealthWorker => AppColors.roleChwTint,
    UserRole.doctor => AppColors.roleDoctorTint,
  };

  String _titleFor(UserRole role, AppLocalizations l10n) => switch (role) {
    UserRole.patient => l10n.rolePatient,
    UserRole.communityHealthWorker => l10n.roleCommunityHealthWorker,
    UserRole.doctor => l10n.roleDoctor,
  };

  String _badgeFor(UserRole role, AppLocalizations l10n) => switch (role) {
    UserRole.patient => l10n.roleBadgePatient,
    UserRole.communityHealthWorker => l10n.roleBadgeChw,
    UserRole.doctor => l10n.roleBadgeDoctor,
  };

  String _descriptionFor(UserRole role, AppLocalizations l10n) =>
      switch (role) {
        UserRole.patient => l10n.rolePatientDescription,
        UserRole.communityHealthWorker =>
          l10n.roleCommunityHealthWorkerDescription,
        UserRole.doctor => l10n.roleDoctorDescription,
      };
}

/// The welcome photograph. Falls back to a mint panel with the app mark
/// when the asset has not been exported into `assets/images/` yet, so the
/// screen keeps its proportions either way.
class _HeroImage extends StatelessWidget {
  const _HeroImage();

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: AspectRatio(
        aspectRatio: 1.55,
        child: Image.asset(
          'assets/images/onboarding_hero.jpg',
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => const DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFFD1FAE5), Color(0xFFA7F3D0)],
              ),
            ),
            child: Center(
              child: Icon(
                Icons.volunteer_activism,
                size: 56,
                color: Color(0xFF15803D),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Eyebrow extends StatelessWidget {
  final String label;

  const _Eyebrow({required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 7,
          height: 7,
          decoration: const BoxDecoration(
            color: AppColors.primaryLight,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 7),
        Text(
          label.toUpperCase(),
          style: const TextStyle(
            fontSize: 11.5,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.4,
            color: AppColors.primary,
          ),
        ),
      ],
    );
  }
}

class _TrustFooter extends StatelessWidget {
  final AppLocalizations l10n;

  const _TrustFooter({required this.l10n});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _TrustBadge(
          icon: Icons.shield_outlined,
          label: l10n.trustHipaaAligned,
          color: AppColors.primary,
        ),
        const _TrustDivider(),
        _TrustBadge(
          icon: Icons.wifi_off_outlined,
          label: l10n.trustOfflineReady,
          color: AppColors.secondary,
        ),
        const _TrustDivider(),
        _TrustBadge(
          icon: Icons.flag_outlined,
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
