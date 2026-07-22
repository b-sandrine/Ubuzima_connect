import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/localization/locale_extensions.dart';
import '../../../../core/routing/app_routes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../../../shared/widgets/buttons/primary_button.dart';
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

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Scaffold(
      body: SafeArea(
        child: BlocConsumer<RoleSelectionBloc, RoleSelectionState>(
          listenWhen: (previous, current) => previous.status != current.status,
          listener: (context, state) {
            switch (state.status) {
              case RoleSelectionStatus.saved:
                context.go(AppRoutes.login);
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
            return Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.roleSelectionTitle,
                    style: context.textStyles.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    l10n.roleSelectionSubtitle,
                    style: context.textStyles.bodyMedium?.copyWith(
                      color: context.colors.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  Expanded(
                    child: ListView.separated(
                      itemCount: UserRole.values.length,
                      separatorBuilder: (_, _) =>
                          const SizedBox(height: AppSpacing.md),
                      itemBuilder: (context, index) {
                        final role = UserRole.values[index];

                        return RoleOptionCard(
                          icon: _iconFor(role),
                          title: _titleFor(role, l10n),
                          description: _descriptionFor(role, l10n),
                          isSelected: state.highlightedRole == role,
                          onTap: () => context.read<RoleSelectionBloc>().add(
                            RoleSelectionEvent.roleHighlighted(role),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  PrimaryButton(
                    label: l10n.continueLabel,
                    isLoading: state.status == RoleSelectionStatus.saving,
                    onPressed: state.canConfirm
                        ? () => context.read<RoleSelectionBloc>().add(
                            const RoleSelectionEvent.confirmed(),
                          )
                        : null,
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  IconData _iconFor(UserRole role) => switch (role) {
    UserRole.patient => Icons.person_outline,
    UserRole.communityHealthWorker => Icons.volunteer_activism_outlined,
    UserRole.doctor => Icons.medical_services_outlined,
  };

  String _titleFor(UserRole role, AppLocalizations l10n) => switch (role) {
    UserRole.patient => l10n.rolePatient,
    UserRole.communityHealthWorker => l10n.roleCommunityHealthWorker,
    UserRole.doctor => l10n.roleDoctor,
  };

  String _descriptionFor(UserRole role, AppLocalizations l10n) =>
      switch (role) {
        UserRole.patient => l10n.rolePatientDescription,
        UserRole.communityHealthWorker =>
          l10n.roleCommunityHealthWorkerDescription,
        UserRole.doctor => l10n.roleDoctorDescription,
      };
}
