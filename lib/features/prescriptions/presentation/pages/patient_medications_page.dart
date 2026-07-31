import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/routing/app_routes.dart';
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
import '../widgets/prescription_details_sheet.dart';
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
      bottomNavigationBar: UbuzimaBottomNav(
        currentIndex: 1,
        onTap: (index) {
          switch (index) {
            case 0:
              context.go(AppRoutes.patientDashboard);
            case 2:
              context.go(AppRoutes.patientAiInsights);
            case 3:
              context.go(AppRoutes.patientNotifications);
            case 4:
              context.go(AppRoutes.patientSettings);
          }
        },
        items: const [
          BottomNavItem(icon: LucideIcons.house, label: 'Home'),
          BottomNavItem(icon: LucideIcons.folder, label: 'Records'),
          BottomNavItem(icon: LucideIcons.brain, label: 'AI Insights'),
          BottomNavItem(icon: LucideIcons.bell, label: 'Alerts', showDot: true),
          BottomNavItem(icon: LucideIcons.settings, label: 'Settings'),
        ],
      ),
      body: AppGradientBackground(
        child: SafeArea(
          child: BlocConsumer<MedicationBloc, MedicationState>(
            listenWhen: (prev, curr) =>
                prev.errorMessage != curr.errorMessage &&
                curr.errorMessage != null,
            listener: (context, state) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.errorMessage!)));
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
                          contextIcon: LucideIcons.pill,
                          trailing: [
                            CircleIconButton(
                              icon: LucideIcons.bell,
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
                          onSelected: (i) => context.read<MedicationBloc>().add(
                            MedicationEvent.tabChanged(i),
                          ),
                        ),
                        const SizedBox(height: 18),
                        switch (state.selectedTab) {
                          0 => _TodayTab(state: state),
                          1 => _PrescriptionsTab(state: state),
                          2 => _AdherenceTab(state: state),
                          _ => _HistoryTab(state: state),
                        },
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
                tileColor: _tileColorFor(dose),
                onTake: () => context.read<MedicationBloc>().add(
                  MedicationEvent.doseMarkedTaken(dose.id),
                ),
                onTap: () => showPrescriptionDetailsSheet(
                  context,
                  dose: dose,
                  tileColor: _tileColorFor(dose),
                  onTake: () => context.read<MedicationBloc>().add(
                    MedicationEvent.doseMarkedTaken(dose.id),
                  ),
                  onRequestRefill: () => context.read<MedicationBloc>().add(
                    const MedicationEvent.refillRequested(),
                  ),
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

  /// The design gives each dose row its own pill-tile hue in schedule order:
  /// emerald, blue, orange, violet — cycling if there are more than four.
  static const List<Color> _tilePalette = [
    Color(0xFF10B981),
    Color(0xFF3B82F6),
    Color(0xFFF97316),
    Color(0xFF7C3AED),
  ];

  Color _tileColorFor(MedicationDose dose) {
    final index = state.doses.indexOf(dose);
    return _tilePalette[index % _tilePalette.length];
  }
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
        Expanded(
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

class _PrescriptionGroup {
  final String name;
  final String dosage;
  final List<MedicationDose> doses;

  _PrescriptionGroup({
    required this.name,
    required this.dosage,
    required this.doses,
  });

  DoseStatus get overallStatus {
    if (doses.every((d) => d.status == DoseStatus.taken)) {
      return DoseStatus.taken;
    }
    if (doses.any((d) => d.status == DoseStatus.dueSoon)) {
      return DoseStatus.dueSoon;
    }
    return DoseStatus.pending;
  }

  List<DoseTag> get tags => {for (final d in doses) ...d.tags}.toList();
}

List<_PrescriptionGroup> _groupByMedication(List<MedicationDose> doses) {
  final byName = <String, List<MedicationDose>>{};
  final order = <String>[];
  for (final dose in doses) {
    byName.putIfAbsent(dose.name, () {
      order.add(dose.name);
      return [];
    }).add(dose);
  }
  return [
    for (final name in order)
      _PrescriptionGroup(
        name: name,
        dosage: byName[name]!.first.dosage,
        doses: byName[name]!,
      ),
  ];
}

/// PAT-03's Prescriptions tab — every medication on today's schedule rolled
/// up into one card, so the patient sees dosage, frequency, and instructions
/// without the per-dose repetition of the Today tab.
class _PrescriptionsTab extends StatelessWidget {
  final MedicationState state;

  const _PrescriptionsTab({required this.state});

  @override
  Widget build(BuildContext context) {
    final groups = _groupByMedication(state.doses);
    if (groups.isEmpty) {
      return const _EmptyTabState(
        icon: LucideIcons.pill,
        message: 'No active prescriptions on file.',
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'ACTIVE PRESCRIPTIONS',
          style: TextStyle(
            fontSize: 11.5,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.1,
            color: AppColors.textTertiary,
          ),
        ),
        const SizedBox(height: 12),
        for (final group in groups) ...[
          _PrescriptionCard(group: group),
          const SizedBox(height: 10),
        ],
      ],
    );
  }
}

class _PrescriptionCard extends StatelessWidget {
  final _PrescriptionGroup group;

  const _PrescriptionCard({required this.group});

  @override
  Widget build(BuildContext context) {
    final (label, color) = switch (group.overallStatus) {
      DoseStatus.taken => ('Taken Today', AppColors.primary),
      DoseStatus.dueSoon => ('Due Soon', AppColors.secondary),
      DoseStatus.pending => ('Pending', AppColors.textSecondary),
    };
    final frequency = group.doses.length == 1
        ? 'Once daily'
        : '${group.doses.length}x daily';

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  LucideIcons.pill,
                  color: AppColors.primary,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      group.name,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${group.dosage} · $frequency',
                      style: const TextStyle(
                        fontSize: 12.5,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              StatusPill(label: label, color: color),
            ],
          ),
          if (group.tags.isNotEmpty) ...[
            const SizedBox(height: 10),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: [
                for (final tag in group.tags)
                  StatusPill(
                    label: tag.label,
                    color: tag.kind == DoseTagKind.condition
                        ? const Color(0xFFE11D48)
                        : AppColors.textSecondary,
                    fontSize: 10.5,
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

/// PAT-03's Adherence tab — today's adherence figures from the schedule
/// summary, broken down per medication so the patient can see which drug is
/// behind.
class _AdherenceTab extends StatelessWidget {
  final MedicationState state;

  const _AdherenceTab({required this.state});

  @override
  Widget build(BuildContext context) {
    final summary = state.schedule!.summary;
    final groups = _groupByMedication(state.doses);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: AppColors.border),
          ),
          child: Row(
            children: [
              SizedBox(
                width: 64,
                height: 64,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: 64,
                      height: 64,
                      child: CircularProgressIndicator(
                        value: summary.adherencePercent / 100,
                        strokeWidth: 6,
                        backgroundColor: AppColors.border,
                        valueColor: const AlwaysStoppedAnimation(
                          AppColors.primary,
                        ),
                      ),
                    ),
                    Text(
                      '${summary.adherencePercent}%',
                      style: const TextStyle(
                        fontSize: 14.5,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Today's Adherence",
                      style: TextStyle(
                        fontSize: 14.5,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      '${summary.takenToday} of ${summary.totalToday} '
                      'doses taken',
                      style: const TextStyle(
                        fontSize: 12.5,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _AdherenceStatTile(
                icon: LucideIcons.flame,
                value: '${summary.streakDays}',
                label: 'Day streak',
                color: AppColors.warning,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _AdherenceStatTile(
                icon: LucideIcons.refreshCw,
                value: '${summary.refillsDue}',
                label: 'Refills due',
                color: AppColors.secondary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 18),
        const Text(
          'BY MEDICATION',
          style: TextStyle(
            fontSize: 11.5,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.1,
            color: AppColors.textTertiary,
          ),
        ),
        const SizedBox(height: 10),
        for (final group in groups) ...[
          _MedicationAdherenceRow(group: group),
          const SizedBox(height: 10),
        ],
      ],
    );
  }
}

class _AdherenceStatTile extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final Color color;

  const _AdherenceStatTile({
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          Icon(icon, size: 20, color: color),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                    color: color,
                  ),
                ),
                Text(
                  label,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 11.5,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MedicationAdherenceRow extends StatelessWidget {
  final _PrescriptionGroup group;

  const _MedicationAdherenceRow({required this.group});

  @override
  Widget build(BuildContext context) {
    final taken = group.doses.where((d) => d.status == DoseStatus.taken).length;
    final total = group.doses.length;
    final fraction = total == 0 ? 0.0 : taken / total;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                group.name,
                style: const TextStyle(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              Text(
                '$taken/$total today',
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
              value: fraction,
              minHeight: 6,
              backgroundColor: AppColors.border,
              valueColor: const AlwaysStoppedAnimation(AppColors.primary),
            ),
          ),
        ],
      ),
    );
  }
}

/// PAT-03's History tab — today's dose log in chronological order, taken and
/// pending doses both shown so the patient can see what's left and what they
/// already logged.
class _HistoryTab extends StatelessWidget {
  final MedicationState state;

  const _HistoryTab({required this.state});

  @override
  Widget build(BuildContext context) {
    final doses = [
      for (final part in DayPart.values)
        ...state.doses.where((d) => d.dayPart == part),
    ];
    if (doses.isEmpty) {
      return const _EmptyTabState(
        icon: LucideIcons.history,
        message: 'No dose history for today yet.',
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "TODAY'S LOG",
          style: TextStyle(
            fontSize: 11.5,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.1,
            color: AppColors.textTertiary,
          ),
        ),
        const SizedBox(height: 12),
        for (var i = 0; i < doses.length; i++)
          _HistoryLogRow(dose: doses[i], isLast: i == doses.length - 1),
      ],
    );
  }
}

class _HistoryLogRow extends StatelessWidget {
  final MedicationDose dose;
  final bool isLast;

  const _HistoryLogRow({required this.dose, required this.isLast});

  @override
  Widget build(BuildContext context) {
    final taken = dose.status == DoseStatus.taken;
    final dotColor = taken ? AppColors.primary : AppColors.textTertiary;

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Container(
                width: 10,
                height: 10,
                margin: const EdgeInsets.only(top: 4),
                decoration: BoxDecoration(
                  color: taken ? dotColor : Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(color: dotColor, width: 2),
                ),
              ),
              if (!isLast)
                Expanded(
                  child: Container(width: 1.5, color: AppColors.border),
                ),
            ],
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${dose.name} · ${dose.dosage}',
                          style: const TextStyle(
                            fontSize: 13.5,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          taken
                              ? dose.instruction
                              : 'Scheduled for ${dose.timeLabel}',
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  StatusPill(
                    label: taken ? 'Taken' : 'Pending',
                    color: dotColor,
                    fontSize: 10.5,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyTabState extends StatelessWidget {
  final IconData icon;
  final String message;

  const _EmptyTabState({required this.icon, required this.message});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 48),
      child: Center(
        child: Column(
          children: [
            Icon(icon, size: 40, color: AppColors.textTertiary),
            const SizedBox(height: 12),
            Text(
              message,
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
