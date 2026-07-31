import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/routing/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../shared/widgets/backgrounds/app_gradient_background.dart';
import '../../../../shared/widgets/error/error_view.dart';
import '../../../../shared/widgets/loading/loading_indicator.dart';
import '../../../../shared/widgets/navigation/app_top_bar.dart';
import '../../../../shared/widgets/navigation/segmented_tabs.dart';
import '../../data/repositories/mock_patient_records_repository.dart';
import '../../domain/models/records_patient_profile.dart';
import '../../domain/models/visit_summary.dart';
import '../../domain/repositories/patient_records_repository.dart';
import '../widgets/patient_bottom_navigation_bar.dart';
import '../widgets/patient_records_header_card.dart';
import '../widgets/records_search_field.dart';
import '../widgets/visit_summary_card.dart';

/// The patient's Medical Records screen: identity summary, search, a
/// Visits / Lab Results / Prescriptions / Timeline segmented control, and
/// the visit-summary history.
///
/// Data comes from a [PatientRecordsRepository] —
/// [MockPatientRecordsRepository] by default — so swapping in a
/// Firestore-backed implementation later only touches the constructor
/// call, not this screen.
class PatientRecordsPage extends StatefulWidget {
  final PatientRecordsRepository repository;

  const PatientRecordsPage({
    super.key,
    this.repository = const MockPatientRecordsRepository(),
  });

  @override
  State<PatientRecordsPage> createState() => _PatientRecordsPageState();
}

class _RecordsData {
  final RecordsPatientProfile profile;
  final List<VisitSummary> visits;
  final int totalVisitCount;

  const _RecordsData({
    required this.profile,
    required this.visits,
    required this.totalVisitCount,
  });
}

class _PatientRecordsPageState extends State<PatientRecordsPage> {
  static const List<String> _tabs = [
    'Visits',
    'Lab Results',
    'Prescriptions',
    'Timeline',
  ];

  late Future<_RecordsData> _future;
  int _tabIndex = 0;
  int _navIndex = 1;

  @override
  void initState() {
    super.initState();
    _future = _load();
  }

  Future<_RecordsData> _load() async {
    final results = await Future.wait([
      widget.repository.getPatientProfile(),
      widget.repository.getVisitSummaries(),
      widget.repository.getTotalVisitCount(),
    ]);

    return _RecordsData(
      profile: results[0] as RecordsPatientProfile,
      visits: results[1] as List<VisitSummary>,
      totalVisitCount: results[2] as int,
    );
  }

  Future<void> _refresh() async {
    final next = _load();
    setState(() => _future = next);
    await next;
  }

  void _onTabSelected(int index) {
    // Only the Visits tab has seeded content today; Prescriptions and
    // Timeline already have their own screens elsewhere in the app, so tab
    // taps hand off to those instead of duplicating them here.
    // TODO: build a dedicated Lab Results view once that data is available.
    switch (index) {
      case 2:
        context.push(AppRoutes.patientMedications);
      case 3:
        context.push(AppRoutes.patientMedicalTimeline);
      default:
        setState(() => _tabIndex = index);
    }
  }

  void _onNavTap(int index) {
    switch (index) {
      case 0:
        context.go(AppRoutes.patientDashboard);
      case 1:
        break;
      case 2:
        context.go(AppRoutes.patientAiInsights);
      case 3:
        context.go(AppRoutes.patientNotifications);
      case 4:
        context.go(AppRoutes.patientSettings);
      default:
        setState(() => _navIndex = index);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: AppGradientBackground(
        child: SafeArea(
          child: FutureBuilder<_RecordsData>(
            future: _future,
            builder: (context, snapshot) {
              if (snapshot.connectionState != ConnectionState.done) {
                return const LoadingIndicator(message: 'Loading records…');
              }
              if (snapshot.hasError) {
                return ErrorView(
                  message: 'Could not load medical records. Please try again.',
                  onRetry: _refresh,
                );
              }

              final data = snapshot.requireData;
              return RefreshIndicator(
                onRefresh: _refresh,
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.md,
                    AppSpacing.sm,
                    AppSpacing.md,
                    AppSpacing.xl,
                  ),
                  children: [
                    const AppTopBar(
                      contextLabel: 'MY RECORDS',
                      contextIcon: LucideIcons.folderOpen,
                      trailing: [CircleIconButton(icon: LucideIcons.bell)],
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    PatientRecordsHeaderCard(
                      profile: data.profile,
                      onHealthIdTap: () => _printAction('Health ID'),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    RecordsSearchField(
                      onChanged: (query) => _printAction('Search · $query'),
                      onFilterTap: () => _printAction('Search · Filters'),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    SegmentedTabs(
                      tabs: _tabs,
                      selectedIndex: _tabIndex,
                      onSelected: _onTabSelected,
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'VISIT SUMMARIES',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.6,
                            color: AppColors.textTertiary,
                          ),
                        ),
                        Text(
                          '${data.totalVisitCount} total',
                          style: const TextStyle(
                            fontSize: 12.5,
                            color: AppColors.textTertiary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.sm + 2),
                    for (final visit in data.visits) ...[
                      VisitSummaryCard(
                        visit: visit,
                        onFullReport: () =>
                            _printAction('Full Report · ${visit.title}'),
                        onChipTap: (chip) =>
                            _printAction('${chip.label} · ${visit.title}'),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                    ],
                    const SizedBox(height: AppSpacing.xs),
                    _LoadOlderVisitsButton(
                      remaining: data.totalVisitCount - data.visits.length,
                      onTap: () => _printAction('Load older visits'),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
      bottomNavigationBar: PatientBottomNavigationBar(
        currentIndex: _navIndex,
        onTap: _onNavTap,
      ),
    );
  }

  void _printAction(String action) => debugPrint('Tapped: $action');
}

class _LoadOlderVisitsButton extends StatelessWidget {
  final int remaining;
  final VoidCallback onTap;

  const _LoadOlderVisitsButton({required this.remaining, required this.onTap});

  @override
  Widget build(BuildContext context) {
    if (remaining <= 0) return const SizedBox.shrink();

    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(AppRadius.lg),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppRadius.lg),
            border: Border.all(color: AppColors.border),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                LucideIcons.history,
                size: 15,
                color: AppColors.textSecondary,
              ),
              const SizedBox(width: 8),
              Text(
                'Load older visits ($remaining more)',
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
