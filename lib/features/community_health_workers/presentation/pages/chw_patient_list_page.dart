import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/routing/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/backgrounds/app_gradient_background.dart';
import '../../../../shared/widgets/error/error_view.dart';
import '../../../../shared/widgets/loading/loading_indicator.dart';
import '../../../../shared/widgets/navigation/app_top_bar.dart';
import '../../../patient_intake/domain/entities/patient_intake_draft.dart';
import '../../../patient_intake/domain/entities/registered_patient.dart';
import '../bloc/chw_patient_list_bloc.dart';
import '../widgets/chw_bottom_nav.dart';

/// CHW-02 — searchable list of patients registered via intake, loaded from
/// Firestore `patients/{id}`.
class ChwPatientListPage extends StatelessWidget {
  const ChwPatientListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          getIt<ChwPatientListBloc>()
            ..add(const ChwPatientListEvent.started()),
      child: const _ChwPatientListView(),
    );
  }
}

class _ChwPatientListView extends StatelessWidget {
  const _ChwPatientListView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      bottomNavigationBar: const ChwBottomNav(currentIndex: 1),
      body: AppGradientBackground(
        child: SafeArea(
          child: BlocBuilder<ChwPatientListBloc, ChwPatientListState>(
            builder: (context, state) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                    child: AppTopBar(
                      contextLabel: 'PATIENTS',
                      contextColor: AppColors.roleChw,
                      trailing: [
                        CircleIconButton(
                          icon: LucideIcons.userRoundPlus,
                          color: AppColors.roleChw,
                          onTap: () =>
                              context.push(AppRoutes.newPatientIntake),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                    child: Text(
                      state.status == ChwPatientListStatus.ready
                          ? '${state.patients.length} registered'
                          : 'Your community caseload',
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                    child: TextField(
                      onChanged: (v) => context.read<ChwPatientListBloc>().add(
                        ChwPatientListEvent.queryChanged(v),
                      ),
                      decoration: InputDecoration(
                        hintText: 'Search by name, phone, or location',
                        prefixIcon: const Icon(LucideIcons.search, size: 18),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 12,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: const BorderSide(color: AppColors.border),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: const BorderSide(color: AppColors.border),
                        ),
                      ),
                    ),
                  ),
                  Expanded(child: _Body(state: state)),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _Body extends StatelessWidget {
  final ChwPatientListState state;

  const _Body({required this.state});

  @override
  Widget build(BuildContext context) {
    return switch (state.status) {
      ChwPatientListStatus.initial || ChwPatientListStatus.loading =>
        const Center(child: LoadingIndicator()),
      ChwPatientListStatus.failure => ErrorView(
        message: state.errorMessage ?? 'Could not load patients.',
        onRetry: () => context.read<ChwPatientListBloc>().add(
          const ChwPatientListEvent.refreshed(),
        ),
      ),
      ChwPatientListStatus.ready => _PatientList(
        patients: state.filteredPatients,
        isEmptyBecauseFilter:
            state.patients.isNotEmpty && state.filteredPatients.isEmpty,
      ),
    };
  }
}

class _PatientList extends StatelessWidget {
  final List<RegisteredPatient> patients;
  final bool isEmptyBecauseFilter;

  const _PatientList({
    required this.patients,
    required this.isEmptyBecauseFilter,
  });

  @override
  Widget build(BuildContext context) {
    if (patients.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                isEmptyBecauseFilter
                    ? LucideIcons.searchX
                    : LucideIcons.users,
                size: 40,
                color: AppColors.textTertiary,
              ),
              const SizedBox(height: 12),
              Text(
                isEmptyBecauseFilter
                    ? 'No patients match your search'
                    : 'No patients registered yet',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                isEmptyBecauseFilter
                    ? 'Try a different name, phone, or place.'
                    : 'Tap Register to add your first community patient.',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 13.5,
                  color: AppColors.textSecondary,
                ),
              ),
              if (!isEmptyBecauseFilter) ...[
                const SizedBox(height: 18),
                FilledButton.icon(
                  onPressed: () => context.push(AppRoutes.newPatientIntake),
                  icon: const Icon(LucideIcons.userRoundPlus, size: 18),
                  label: const Text('Register patient'),
                ),
              ],
            ],
          ),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        final bloc = context.read<ChwPatientListBloc>();
        bloc.add(const ChwPatientListEvent.refreshed());
        await bloc.stream.firstWhere(
          (s) =>
              s.status == ChwPatientListStatus.ready ||
              s.status == ChwPatientListStatus.failure,
        );
      },
      child: ListView.separated(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        itemCount: patients.length,
        separatorBuilder: (_, _) => const SizedBox(height: 10),
        itemBuilder: (context, index) {
          final patient = patients[index];
          return _PatientCard(
            patient: patient,
            onTap: () => context.push(
              AppRoutes.chwHealthRecordFor(patient.id),
            ),
          );
        },
      ),
    );
  }
}

class _PatientCard extends StatelessWidget {
  final RegisteredPatient patient;
  final VoidCallback onTap;

  const _PatientCard({required this.patient, required this.onTap});

  Color get _riskColor => switch (patient.riskLevel) {
    RiskLevel.low => AppColors.riskLow,
    RiskLevel.moderate => AppColors.riskMedium,
    RiskLevel.high => AppColors.riskHigh,
    RiskLevel.critical => AppColors.riskCritical,
  };

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.border),
          ),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: AppColors.roleChwTint,
                  borderRadius: BorderRadius.circular(12),
                ),
                alignment: Alignment.center,
                child: Text(
                  patient.fullName.isNotEmpty
                      ? patient.fullName[0].toUpperCase()
                      : '?',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: AppColors.roleChw,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      patient.fullName,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      patient.detailLine,
                      style: const TextStyle(
                        fontSize: 12.5,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    if (patient.locationLabel.isNotEmpty) ...[
                      const SizedBox(height: 2),
                      Text(
                        patient.locationLabel,
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.textTertiary,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: _riskColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  '${patient.riskScore}',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: _riskColor,
                  ),
                ),
              ),
              const SizedBox(width: 4),
              const Icon(Icons.chevron_right, color: AppColors.textTertiary),
            ],
          ),
        ),
      ),
    );
  }
}
