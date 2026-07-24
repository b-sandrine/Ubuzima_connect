import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/backgrounds/app_gradient_background.dart';
import '../../../../shared/widgets/navigation/app_top_bar.dart';
import '../../../../shared/widgets/navigation/segmented_tabs.dart';
import '../../../../shared/widgets/navigation/ubuzima_bottom_nav.dart';
import '../../../../shared/widgets/pills/status_pill.dart';
import '../../domain/entities/medication_dose.dart';
import '../bloc/medication_bloc.dart';
import '../widgets/ai_insight_card.dart';
import '../widgets/dose_card.dart';
import '../widgets/medication_summary_card.dart';
import '../widgets/refill_banner.dart';

/// PAT-03 — the patient's current-medications screen. Shows today's dose
/// schedule grouped by part of day, an adherence summary, a refill reminder,
/// and an AI insight footer.
class PatientMedicationsPage extends StatelessWidget {
  const PatientMedicationsPage({super.key});

  static const List<String> _tabs = [
    'Today',
    'Prescriptions',
    'Adherence',
    'History',
  ];

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          getIt<MedicationBloc>()..add(const MedicationEvent.started()),
      child: const _MedicationsView(),
    );
  }
}

class _MedicationsView extends StatelessWidget {
  const _MedicationsView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      bottomNavigationBar: const UbuzimaBottomNav(
        currentIndex: 3,
        items: [
          BottomNavItem(icon: Icons.home_outlined, label: 'Home'),
          BottomNavItem(icon: Icons.folder_outlined, label: 'Records'),
          BottomNavItem(icon: Icons.insights_outlined, label: 'AI Insights'),
          BottomNavItem(
            icon: Icons.notifications_outlined,
            label: 'Alerts',
            badgeCount: 2,
          ),
          BottomNavItem(icon: Icons.settings_outlined, label: 'Settings'),
        ],
      ),
      body: AppGradientBackground(
        child: SafeArea(
          child: BlocConsumer<MedicationBloc, MedicationState>(
            listenWhen: (prev, curr) =>
                prev.errorMessage != curr.errorMessage &&
                curr.errorMessage != null,
            listener: (context, state) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.errorMessage!)),
              );
            },
            builder: (context, state) {
              if (state.status == MedicationStatus.loading ||
                  state.status == MedicationStatus.initial) {
                return const Center(child: CircularProgressIndicator());
              }
              final schedule = state.schedule;
              if (schedule == null) {
                return const Center(
                  child: Text('Could not load your medications.'),
                );
              }

              return CustomScrollView(
                slivers: [
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 20),
                    sliver: SliverList(
                      delegate: SliverChildListDelegate([
                        const AppTopBar(
                          contextLabel: 'MEDICATIONS',
                          contextIcon: Icons.medication_liquid,
                          trailing: [
                            CircleIconButton(
                              icon: Icons.notifications_outlined,
                              showDot: true,
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        MedicationSummaryCard(summary: schedule.summary),
                        if (schedule.refill != null) ...[
                          const SizedBox(height: 14),
                          RefillBanner(
                            refill: schedule.refill!,
                            onRequest: () => context.read<MedicationBloc>().add(
                              const MedicationEvent.refillRequested(),
                            ),
                          ),
                        ],
                        const SizedBox(height: 16),
                        SegmentedTabs(
                          tabs: PatientMedicationsPage._tabs,
                          selectedIndex: state.selectedTab,
                          onSelected: (i) => context
                              .read<MedicationBloc>()
                              .add(MedicationEvent.tabChanged(i)),
                        ),
                        const SizedBox(height: 18),
                        if (state.selectedTab == 0)
                          _TodayTab(state: state)
                        else
                          _ComingSoonTab(
                            label: PatientMedicationsPage._tabs[state
                                .selectedTab],
                          ),
                      ]),
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
}

class _TodayTab extends StatelessWidget {
  final MedicationState state;

  const _TodayTab({required this.state});

  @override
  Widget build(BuildContext context) {
    final schedule = state.schedule!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Flexible(
              child: Text(
                "TODAY'S SCHEDULE",
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.1,
                  color: AppColors.textTertiary,
                ),
              ),
            ),
            Text(
              schedule.dateLabel,
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        for (final part in DayPart.values)
          if (_dosesFor(part).isNotEmpty) ...[
            _DayPartHeader(part: part, doses: _dosesFor(part)),
            const SizedBox(height: 10),
            for (final dose in _dosesFor(part)) ...[
              DoseCard(
                dose: dose,
                onTake: () => context.read<MedicationBloc>().add(
                  MedicationEvent.doseMarkedTaken(dose.id),
                ),
              ),
              const SizedBox(height: 10),
            ],
            const SizedBox(height: 6),
          ],
        const SizedBox(height: 6),
        AiInsightCard(insight: schedule.aiInsight),
      ],
    );
  }

  List<MedicationDose> _dosesFor(DayPart part) =>
      state.doses.where((d) => d.dayPart == part).toList();
}

class _DayPartHeader extends StatelessWidget {
  final DayPart part;
  final List<MedicationDose> doses;

  const _DayPartHeader({required this.part, required this.doses});

  @override
  Widget build(BuildContext context) {
    final (label, time, dotColor) = switch (part) {
      DayPart.morning => ('MORNING', doses.first.timeLabel, AppColors.warning),
      DayPart.afternoon => (
        'AFTERNOON',
        doses.first.timeLabel,
        AppColors.secondary,
      ),
      DayPart.evening => (
        'EVENING',
        doses.first.timeLabel,
        const Color(0xFF7C3AED),
      ),
    };

    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: dotColor, shape: BoxShape.circle),
        ),
        const SizedBox(width: 8),
        Flexible(
          child: Text(
            '$label · $time',
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.4,
              color: AppColors.textPrimary,
            ),
          ),
        ),
        const SizedBox(width: 8),
        const Spacer(),
        _groupPill(doses),
      ],
    );
  }

  Widget _groupPill(List<MedicationDose> doses) {
    if (doses.every((d) => d.status == DoseStatus.taken)) {
      return const StatusPill(label: 'Completed', color: AppColors.primary);
    }
    if (doses.any((d) => d.status == DoseStatus.dueSoon)) {
      return const StatusPill(label: 'Due Soon', color: AppColors.secondary);
    }
    return const StatusPill(label: 'Pending', color: AppColors.textSecondary);
  }
}

class _ComingSoonTab extends StatelessWidget {
  final String label;

  const _ComingSoonTab({required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 48),
      child: Center(
        child: Column(
          children: [
            Icon(
              Icons.event_note_outlined,
              size: 44,
              color: AppColors.textTertiary,
            ),
            const SizedBox(height: 12),
            Text(
              '$label view coming soon',
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
