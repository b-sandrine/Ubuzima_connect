import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/backgrounds/app_gradient_background.dart';
import '../../../../shared/widgets/navigation/app_top_bar.dart';
import '../../../../shared/widgets/navigation/segmented_tabs.dart';
import '../../../../shared/widgets/navigation/ubuzima_bottom_nav.dart';
import '../../../../shared/widgets/pills/status_pill.dart';
import '../../domain/entities/patient_timeline.dart';
import '../bloc/timeline_bloc.dart';
import '../widgets/timeline_analysis_card.dart';
import '../widgets/timeline_event_card.dart';
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
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text(
          'New Entry',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      bottomNavigationBar: const UbuzimaBottomNav(
        currentIndex: 1,
        items: [
          BottomNavItem(icon: Icons.home_outlined, label: 'Home'),
          BottomNavItem(icon: Icons.folder_outlined, label: 'Records'),
          BottomNavItem(icon: Icons.insights_outlined, label: 'AI Insights'),
          BottomNavItem(
            icon: Icons.notifications_outlined,
            label: 'Alerts',
          ),
          BottomNavItem(icon: Icons.settings_outlined, label: 'Settings'),
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
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 90),
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
        contextLabel: 'LIVE',
        contextColor: AppColors.primary,
        contextIcon: Icons.circle,
        trailing: const [
          CircleIconButton(icon: Icons.ios_share),
          CircleIconButton(icon: Icons.notifications_outlined, showDot: true),
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
                  'Chronological medical history · Filterable',
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
            label: '${timeline.eventCount} Events',
            color: AppColors.primary,
            icon: Icons.event_note,
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
          Row(
            children: const [
              Icon(Icons.picture_as_pdf_outlined,
                  size: 15, color: AppColors.primary),
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
      const SizedBox(height: 8),
      TimelineAnalysisCard(summary: timeline.aiSummary),
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
            decoration: const BoxDecoration(
              color: AppColors.rolePatientTint,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.person, color: AppColors.rolePatient),
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
          const Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Icon(Icons.summarize_outlined, size: 18, color: AppColors.primary),
              SizedBox(height: 2),
              Text(
                'Full Summary',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                ),
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
          Icons.search,
          size: 20,
          color: AppColors.textTertiary,
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
        child: Text(
          '$year',
          style: const TextStyle(
            fontSize: 12.5,
            fontWeight: FontWeight.w800,
            color: AppColors.primaryDark,
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
            Icon(Icons.search_off, size: 44, color: AppColors.textTertiary),
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
