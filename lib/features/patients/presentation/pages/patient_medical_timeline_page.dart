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
import '../../../medical_records/domain/entities/patient_timeline.dart';
import '../../../medical_records/domain/entities/timeline_event.dart';
import '../../../medical_records/presentation/bloc/timeline_bloc.dart';
import '../../../medical_records/presentation/widgets/timeline_event_card.dart';
import '../../../medical_records/presentation/widgets/trend_chart.dart';
import '../widgets/patient_health_header.dart';
import '../widgets/patient_insight_card.dart';

/// PAT-02b — the patient's own medical timeline. Reads the exact same
/// [PatientTimeline] Firestore record that DOC-04 (the doctor's view)
/// reads — a patient's history is one source of truth, not a copy — but
/// presents it through a warmer, patient-facing lens: a supportive header
/// instead of a clinical status badge, and an insight card that points the
/// patient to their CHW rather than a print button.
class PatientMedicalTimelinePage extends StatelessWidget {
  const PatientMedicalTimelinePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          getIt<TimelineBloc>()..add(const TimelineViewEvent.started()),
      child: const _PatientTimelineView(),
    );
  }
}

class _PatientTimelineView extends StatelessWidget {
  const _PatientTimelineView();

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
            case 1:
              context.go(AppRoutes.patientRecords);
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
                  child: Text('We could not load your health record.'),
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
    final years = _yearRange(timeline.events);

    return [
      AppTopBar(
        onBack: () => Navigator.of(context).maybePop(),
        contextLabel: 'MY RECORD',
        contextColor: AppColors.rolePatient,
        contextIcon: LucideIcons.shieldCheck,
        trailing: const [
          CircleIconButton(icon: LucideIcons.bell, showDot: true),
        ],
      ),
      const SizedBox(height: 14),
      PatientHealthHeader(
        patient: timeline.patient,
        onShare: () => _showComingSoon(context, 'Sharing your record'),
        onDownload: () => _showComingSoon(context, 'Downloading your PDF'),
      ),
      const SizedBox(height: 20),
      Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'My Health Timeline',
                  style: TextStyle(
                    fontSize: 21,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  years == null
                      ? 'Your complete care history, in one place'
                      : 'Your complete care history · $years',
                  style: const TextStyle(
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
      const SizedBox(height: 6),
      const Padding(
        padding: EdgeInsets.symmetric(horizontal: 4),
        child: Text(
          'These are your blood pressure and glucose readings over time. '
          'Ask your CHW if anything here looks unfamiliar.',
          style: TextStyle(fontSize: 11.5, color: AppColors.textTertiary),
        ),
      ),
      const SizedBox(height: 18),
      const Padding(
        padding: EdgeInsets.symmetric(horizontal: 2),
        child: Text(
          'YOUR HEALTH EVENTS',
          style: TextStyle(
            fontSize: 11.5,
            fontWeight: FontWeight.w700,
            letterSpacing: 1,
            color: AppColors.textTertiary,
          ),
        ),
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
      PatientInsightCard(
        summary: timeline.aiSummary,
        viewLabel: timeline.aiViewLabel,
        onAskChw: () => _showComingSoon(context, 'Messaging your CHW'),
        onDownload: () => _showComingSoon(context, 'Downloading your PDF'),
      ),
    ];
  }

  /// "2018–2025" from the loaded events, or null if there is nothing loaded
  /// yet to derive a range from.
  String? _yearRange(List<TimelineEvent> events) {
    if (events.isEmpty) return null;
    final years = events.map((e) => e.year);
    final earliest = years.reduce((a, b) => a < b ? a : b);
    final latest = years.reduce((a, b) => a > b ? a : b);
    return earliest == latest ? '$latest' : '$earliest–$latest';
  }

  void _showComingSoon(BuildContext context, String action) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$action is coming soon.')),
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
        hintText: 'Search your visits, diagnoses, medications…',
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
/// loaded event, same as DOC-04. Reveals the collapsed older events on tap.
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
              'Nothing matches that search',
              style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
            ),
          ],
        ),
      ),
    );
  }
}
