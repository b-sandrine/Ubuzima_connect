import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/backgrounds/app_gradient_background.dart';
import '../../../../shared/widgets/branding/ubuzima_wordmark.dart';
import '../../../../shared/widgets/navigation/app_top_bar.dart';
import '../../../../shared/widgets/navigation/segmented_tabs.dart';
import '../../../../shared/widgets/navigation/ubuzima_bottom_nav.dart';
import '../../domain/entities/health_record.dart';
import '../bloc/health_record_bloc.dart';
import '../widgets/conditions_card.dart';
import '../widgets/demographics_card.dart';
import '../widgets/health_assessment_card.dart';
import '../widgets/next_steps_section.dart';
import '../widgets/patient_header_card.dart';

/// CHW health record — the community health worker's full patient record:
/// identity, demographics, an AI risk assessment, conditions & symptoms, and
/// the outstanding next steps.
class ChwHealthRecordPage extends StatelessWidget {
  const ChwHealthRecordPage({super.key});

  static const List<String> _tabs = [
    'Overview',
    'Vitals',
    'Visits',
    'Immunization',
  ];

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          getIt<HealthRecordBloc>()..add(const HealthRecordEvent.started()),
      child: const _HealthRecordView(),
    );
  }
}

class _HealthRecordView extends StatelessWidget {
  const _HealthRecordView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      bottomNavigationBar: const UbuzimaBottomNav(
        currentIndex: 1,
        items: [
          BottomNavItem(icon: LucideIcons.house, label: 'Home'),
          BottomNavItem(icon: LucideIcons.users, label: 'Patients'),
          BottomNavItem(
            icon: LucideIcons.userPlus,
            label: 'Register',
            isPrimary: true,
          ),
          BottomNavItem(
            icon: LucideIcons.triangleAlert,
            label: 'Alerts',
            badgeCount: 2,
          ),
          BottomNavItem(icon: LucideIcons.settings, label: 'Settings'),
        ],
      ),
      body: AppGradientBackground(
        child: SafeArea(
          child: BlocConsumer<HealthRecordBloc, HealthRecordState>(
            listenWhen: (prev, curr) =>
                prev.errorMessage != curr.errorMessage &&
                curr.errorMessage != null,
            listener: (context, state) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.errorMessage!)),
              );
            },
            builder: (context, state) {
              if (state.status == HealthRecordStatus.loading ||
                  state.status == HealthRecordStatus.initial) {
                return const Center(child: CircularProgressIndicator());
              }
              final record = state.record;
              if (record == null) {
                return const Center(
                  child: Text('Could not load the health record.'),
                );
              }

              return CustomScrollView(
                slivers: [
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                    sliver: SliverList(
                      delegate: SliverChildListDelegate(
                        _content(context, state, record),
                      ),
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

  List<Widget> _content(
    BuildContext context,
    HealthRecordState state,
    HealthRecord record,
  ) {
    final bloc = context.read<HealthRecordBloc>();

    return [
      _Header(
        sector: record.sector,
        dateLabel: record.dateLabel,
        onBack: () => Navigator.of(context).maybePop(),
      ),
      const SizedBox(height: 16),
      PatientHeaderCard(patient: record.patient),
      const SizedBox(height: 16),
      SegmentedTabs(
        tabs: ChwHealthRecordPage._tabs,
        selectedIndex: state.selectedTab,
        onSelected: (i) => bloc.add(HealthRecordEvent.tabChanged(i)),
      ),
      const SizedBox(height: 18),
      DemographicsCard(rows: record.demographics),
      const SizedBox(height: 18),
      HealthAssessmentCard(assessment: record.assessment),
      const SizedBox(height: 18),
      ConditionsCard(conditions: record.conditions),
      const SizedBox(height: 18),
      NextStepsSection(
        steps: record.nextSteps,
        onComplete: (stepId) =>
            bloc.add(HealthRecordEvent.stepCompleted(stepId)),
      ),
    ];
  }
}

/// The two-row record header: the app lockup and CHW actions on top, then the
/// "Health Record" title with the back control, the date, and the sector pill.
class _Header extends StatelessWidget {
  final String sector;
  final String dateLabel;
  final VoidCallback onBack;

  const _Header({
    required this.sector,
    required this.dateLabel,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Expanded(child: UbuzimaWordmark()),
            const CircleIconButton(icon: LucideIcons.bell, showDot: true),
            const SizedBox(width: 8),
            const _ChwAvatar(),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            _BackButton(onTap: onBack),
            const SizedBox(width: 10),
            const Expanded(
              child: Text(
                'Health Record',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            Text(
              dateLabel,
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.textTertiary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        _SectorPill(label: sector),
      ],
    );
  }
}

class _BackButton extends StatelessWidget {
  final VoidCallback onTap;

  const _BackButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.border),
        ),
        child: const Icon(
          LucideIcons.chevronLeft,
          size: 18,
          color: AppColors.textSecondary,
        ),
      ),
    );
  }
}

class _ChwAvatar extends StatelessWidget {
  const _ChwAvatar();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 40,
      height: 40,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          ClipOval(
            child: Image.asset(
              'assets/images/patient_avatar_sample.jpg',
              width: 40,
              height: 40,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                width: 40,
                height: 40,
                color: AppColors.primaryLight,
                child: const Icon(
                  LucideIcons.userRound,
                  size: 20,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          Positioned(
            right: -1,
            bottom: -1,
            child: Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectorPill extends StatelessWidget {
  final String label;

  const _SectorPill({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            LucideIcons.userRound,
            size: 13,
            color: AppColors.primaryDark,
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: AppColors.primaryDark,
            ),
          ),
        ],
      ),
    );
  }
}
