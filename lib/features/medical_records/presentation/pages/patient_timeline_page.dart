import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/routing/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../shared/utils/coming_soon.dart';
import '../../../../shared/widgets/backgrounds/app_gradient_background.dart';
import '../../../../shared/widgets/navigation/app_top_bar.dart';
import '../../../../shared/widgets/navigation/segmented_tabs.dart';
import '../../../../shared/widgets/navigation/ubuzima_bottom_nav.dart';
import '../../../../shared/widgets/pills/status_pill.dart';
import '../../domain/entities/patient_timeline.dart';
import '../bloc/timeline_bloc.dart';
import '../widgets/timeline_analysis_card.dart';
import '../widgets/timeline_event_card.dart';
import '../widgets/timeline_pdf_export.dart';
import '../widgets/trend_chart.dart';

/// DOC-04 — the doctor's patient medical timeline. A filterable, searchable
/// chronological history with a BP/glucose trend chart, year-grouped event
/// cards, and an AI analysis footer.
class PatientTimelinePage extends StatelessWidget {
  const PatientTimelinePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          getIt<TimelineBloc>()..add(const TimelineViewEvent.started()),
      child: const _TimelineView(),
    );
  }
}

class _TimelineView extends StatelessWidget {
  const _TimelineView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      bottomNavigationBar: UbuzimaBottomNav(
        currentIndex: 1,
        onTap: (index) {
          switch (index) {
            case 0:
              context.go(AppRoutes.doctorDashboard);
            case 2:
              showComingSoon(context, 'AI Insights');
            case 3:
              context.go(AppRoutes.doctorNotifications);
            case 4:
              context.go(AppRoutes.doctorSettings);
          }
        },
        items: const [
          BottomNavItem(icon: LucideIcons.house, label: 'Home'),
          BottomNavItem(icon: LucideIcons.folder, label: 'Records'),
          BottomNavItem(icon: LucideIcons.brain, label: 'AI Insights'),
          BottomNavItem(
            icon: LucideIcons.bell,
            label: 'Alerts',
            showDot: true,
            dotColor: AppColors.danger,
          ),
          BottomNavItem(icon: LucideIcons.settings, label: 'Settings'),
        ],
      ),
      body: AppGradientBackground(
        child: SafeArea(
          child: BlocConsumer<TimelineBloc, TimelineState>(
            listenWhen: (prev, curr) =>
                prev.errorMessage != curr.errorMessage &&
                curr.errorMessage != null,
            listener: (context, state) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.errorMessage!)),
              );
            },
            builder: (context, state) {
              if (state.status == TimelineStatus.loading ||
                  state.status == TimelineStatus.initial) {
                return const Center(child: CircularProgressIndicator());
              }
              final timeline = state.timeline;
              if (timeline == null) {
                return const Center(
                  child: Text('Could not load the timeline.'),
                );
              }

              return CustomScrollView(
                slivers: [
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                    sliver: SliverList(
                      delegate: SliverChildListDelegate(
                        _content(context, state, timeline),
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
    TimelineState state,
    PatientTimeline timeline,
  ) {
    final bloc = context.read<TimelineBloc>();

    return [
      AppTopBar(
        onBack: () => Navigator.of(context).maybePop(),
        trailing: [
          CircleIconButton(
            icon: LucideIcons.stethoscope,
            onTap: () => context.push(AppRoutes.consultation),
          ),
          const CircleIconButton(icon: LucideIcons.upload),
          const CircleIconButton(icon: LucideIcons.bell, showDot: true),
        ],
      ),
      const SizedBox(height: 14),
      _PatientChip(patient: timeline.patient),
      const SizedBox(height: 18),
      Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Patient Timeline',
                  style: TextStyle(
                    fontSize: 23,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: 3),
                Text(
                  'Chronological health record · 2018–2025',
                  style: TextStyle(
                    fontSize: 12.5,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          StatusPill(
            label: '${timeline.totalEvents} Events',
            color: AppColors.primary,
            icon: LucideIcons.layers,
            fontSize: 11.5,
          ),
        ],
      ),
      const SizedBox(height: 14),
      _SearchField(
        onChanged: (q) => bloc.add(TimelineViewEvent.searchChanged(q)),
      ),
      const SizedBox(height: 14),
      SegmentedTabs(
        tabs: [for (final f in TimelineFilter.values) f.label],
        selectedIndex: state.filter.index,
        onSelected: (i) =>
            bloc.add(TimelineViewEvent.filterChanged(TimelineFilter.values[i])),
      ),
      const SizedBox(height: 16),
      TrendChart(points: timeline.trend),
      const SizedBox(height: 18),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'EVENT TIMELINE',
            style: TextStyle(
              fontSize: 11.5,
              fontWeight: FontWeight.w700,
              letterSpacing: 1,
              color: AppColors.textTertiary,
            ),
          ),
          Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(8),
              onTap: () => exportTimelinePdf(
                timeline: timeline,
                events: state.visibleEvents,
              ),
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 2, horizontal: 2),
                child: Row(
                  children: [
                    Icon(
                      LucideIcons.download,
                      size: 15,
                      color: AppColors.primary,
                    ),
                    SizedBox(width: 4),
                    Text(
                      'Export PDF',
                      style: TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      const SizedBox(height: 14),
      if (state.visibleEvents.isEmpty)
        const _EmptyTimeline()
      else
        for (final group in state.groupedByYear) ...[
          _YearPill(year: group.year),
          const SizedBox(height: 12),
          for (var i = 0; i < group.events.length; i++)
            TimelineEventCard(
              event: group.events[i],
              isLast: i == group.events.length - 1,
            ),
          const SizedBox(height: 4),
        ],
      if (timeline.earlierCount > 0 &&
          !state.earlierRevealed &&
          state.filter == TimelineFilter.all &&
          state.query.isEmpty) ...[
        const SizedBox(height: 4),
        _LoadEarlierButton(
          count: timeline.earlierCount,
          onTap: () => bloc.add(const TimelineViewEvent.earlierRequested()),
        ),
      ],
      const SizedBox(height: 16),
      TimelineAnalysisCard(
        summary: timeline.aiSummary,
        viewLabel: timeline.aiViewLabel,
      ),
    ];
  }
}

class _PatientChip extends StatelessWidget {
  final TimelinePatient patient;

  const _PatientChip({required this.patient});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A0F172A),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: AppColors.rolePatientTint,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.primaryLight, width: 1.5),
            ),
            child: const Icon(
              LucideIcons.userRound,
              color: AppColors.rolePatient,
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  spacing: 8,
                  runSpacing: 4,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Text(
                      patient.name,
                      style: const TextStyle(
                        fontSize: 15.5,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    StatusPill(
                      label: patient.criticality,
                      color: AppColors.danger,
                      fontSize: 10,
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  patient.summary,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                patient.careHistory,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                  color: AppColors.primary,
                ),
              ),
              const Text(
                'care history',
                style: TextStyle(fontSize: 11, color: AppColors.textTertiary),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SearchField extends StatelessWidget {
  final ValueChanged<String> onChanged;

  const _SearchField({required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: onChanged,
      style: const TextStyle(fontSize: 14, color: AppColors.textPrimary),
      decoration: InputDecoration(
        hintText: 'Search events, diagnoses, medications…',
        hintStyle: const TextStyle(
          fontSize: 13.5,
          color: AppColors.textTertiary,
        ),
        prefixIcon: const Icon(
          LucideIcons.search,
          size: 18,
          color: AppColors.textTertiary,
        ),
        suffixIcon: const Icon(
          LucideIcons.slidersHorizontal,
          size: 18,
          color: AppColors.primary,
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(vertical: 12),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.6),
        ),
      ),
    );
  }
}

class _YearPill extends StatelessWidget {
  final int year;

  const _YearPill({required this.year});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: AppColors.primary.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(999),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              LucideIcons.calendar,
              size: 13,
              color: AppColors.primaryDark,
            ),
            const SizedBox(width: 6),
            Text(
              '$year',
              style: const TextStyle(
                fontSize: 12.5,
                fontWeight: FontWeight.w800,
                color: AppColors.primaryDark,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// The dashed "Load Earlier Records (N more)" affordance beneath the oldest
/// loaded event, as in the design. Reveals the collapsed older events on tap.
class _LoadEarlierButton extends StatelessWidget {
  final int count;
  final VoidCallback onTap;

  const _LoadEarlierButton({required this.count, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        color: AppColors.primary.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(14),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: AppColors.primary.withValues(alpha: 0.3),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  LucideIcons.rotateCcw,
                  size: 15,
                  color: AppColors.primary,
                ),
                const SizedBox(width: 8),
                Flexible(
                  child: Text(
                    'Load Earlier Records ($count more)',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _EmptyTimeline extends StatelessWidget {
  const _EmptyTimeline();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 40),
      child: Center(
        child: Column(
          children: [
            Icon(LucideIcons.searchX, size: 40, color: AppColors.textTertiary),
            SizedBox(height: 12),
            Text(
              'No events match your filter',
              style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
            ),
          ],
        ),
      ),
    );
  }
}
