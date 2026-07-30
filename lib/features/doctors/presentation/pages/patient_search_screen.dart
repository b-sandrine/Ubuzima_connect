import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/routing/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../shared/widgets/backgrounds/app_gradient_background.dart';
import '../../../../shared/widgets/error/error_view.dart';
import '../../../../shared/widgets/loading/loading_indicator.dart';
import '../../data/repositories/mock_patient_search_repository.dart';
import '../../domain/models/ai_insight.dart';
import '../../domain/models/dashboard_stat.dart';
import '../../domain/models/patient_filter.dart';
import '../../domain/models/patient_record.dart';
import '../../domain/repositories/patient_search_repository.dart';
import '../widgets/ai_insight_banner.dart';
import '../widgets/dashboard_stat_card.dart';
import '../widgets/dashboard_top_bar.dart';
import '../widgets/doctor_bottom_navigation_bar.dart';
import '../widgets/patient_filter_chip.dart';
import '../widgets/patient_record_card.dart';
import '../widgets/patient_search_field.dart';
import '../widgets/register_patient_button.dart';

/// The doctor's Patient Search / Records screen: search, quick filters,
/// panel stats, an AI follow-up nudge, and the recent patients list.
///
/// Data comes from a [PatientSearchRepository] — [MockPatientSearchRepository]
/// by default — so swapping in a Firestore-backed implementation later only
/// touches the constructor call, not this screen.
class PatientSearchScreen extends StatefulWidget {
  final PatientSearchRepository repository;

  const PatientSearchScreen({
    super.key,
    this.repository = const MockPatientSearchRepository(),
  });

  @override
  State<PatientSearchScreen> createState() => _PatientSearchScreenState();
}

class _PatientSearchData {
  final List<DashboardStat> stats;
  final AiInsight insight;
  final List<PatientRecord> patients;

  const _PatientSearchData({
    required this.stats,
    required this.insight,
    required this.patients,
  });
}

class _PatientSearchScreenState extends State<PatientSearchScreen> {
  late Future<_PatientSearchData> _future;
  PatientFilter _selectedFilter = PatientFilter.all;
  String _query = '';
  int _navIndex = 1;

  @override
  void initState() {
    super.initState();
    _future = _load();
  }

  Future<_PatientSearchData> _load() async {
    final results = await Future.wait([
      widget.repository.getPatientStats(),
      widget.repository.getFollowUpInsight(),
      widget.repository.getRecentPatients(),
    ]);

    return _PatientSearchData(
      stats: results[0] as List<DashboardStat>,
      insight: results[1] as AiInsight,
      patients: results[2] as List<PatientRecord>,
    );
  }

  Future<void> _refresh() async {
    final next = _load();
    setState(() => _future = next);
    await next;
  }

  List<PatientRecord> _applyFilters(List<PatientRecord> patients) {
    final query = _query.trim().toLowerCase();

    return patients.where((patient) {
      final matchesQuery =
          query.isEmpty ||
          patient.name.toLowerCase().contains(query) ||
          patient.patientCode.toLowerCase().contains(query) ||
          patient.tags.any((tag) => tag.toLowerCase().contains(query));

      final matchesFilter = switch (_selectedFilter) {
        PatientFilter.all => true,
        PatientFilter.today => !patient.lastActivityLabel.contains('day'),
        PatientFilter.critical =>
          patient.status == PatientRecordStatus.critical,
        PatientFilter.followUp => patient.tags.any(
          (tag) => tag.toLowerCase().contains('follow-up'),
        ),
      };

      return matchesQuery && matchesFilter;
    }).toList();
  }

  void _printAction(String action) => debugPrint('Tapped: $action');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: AppGradientBackground(
        child: SafeArea(
          child: FutureBuilder<_PatientSearchData>(
            future: _future,
            builder: (context, snapshot) {
              if (snapshot.connectionState != ConnectionState.done) {
                return const LoadingIndicator(message: 'Loading patients…');
              }
              if (snapshot.hasError) {
                return ErrorView(
                  message: 'Could not load patients. Please try again.',
                  onRetry: _refresh,
                );
              }

              final data = snapshot.requireData;
              final patients = _applyFilters(data.patients);

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
                    DashboardTopBar(
                      onNotificationsTap: () =>
                          _printAction('Open notifications'),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    const Text(
                      'Patient Search',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    const Text(
                      'Find and access patient records',
                      style: TextStyle(
                        fontSize: 13.5,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    PatientSearchField(
                      onChanged: (value) => setState(() => _query = value),
                      onFilterTap: () => _printAction('Advanced filters'),
                    ),
                    const SizedBox(height: AppSpacing.sm + 2),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          for (final filter in PatientFilter.values) ...[
                            PatientFilterChip(
                              label: filter.label,
                              selected: filter == _selectedFilter,
                              onTap: () =>
                                  setState(() => _selectedFilter = filter),
                            ),
                            const SizedBox(width: 8),
                          ],
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Row(
                      children: [
                        for (final stat in data.stats) ...[
                          Expanded(child: DashboardStatCard(stat: stat)),
                          if (stat != data.stats.last)
                            const SizedBox(width: AppSpacing.sm),
                        ],
                      ],
                    ),
                    const SizedBox(height: AppSpacing.md),
                    AiInsightBanner(
                      message: data.insight.message,
                      onTap: () => _printAction('Review follow-up insight'),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'RECENT PATIENTS',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.6,
                            color: AppColors.textTertiary,
                          ),
                        ),
                        InkWell(
                          onTap: () =>
                              _printAction('Recent Patients · View All'),
                          child: const Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 4,
                              vertical: 2,
                            ),
                            child: Text(
                              'View All',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.sm + 2),
                    if (patients.isEmpty)
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: AppSpacing.lg),
                        child: Center(
                          child: Text(
                            'No patients match your search.',
                            style: TextStyle(color: AppColors.textSecondary),
                          ),
                        ),
                      )
                    else
                      for (final patient in patients) ...[
                        PatientRecordCard(
                          patient: patient,
                          onTap: () => context.push(AppRoutes.patientDetail),
                        ),
                        const SizedBox(height: AppSpacing.sm),
                      ],
                    const SizedBox(height: AppSpacing.sm),
                    RegisterPatientButton(
                      onTap: () => _printAction('Register New Patient'),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
      bottomNavigationBar: DoctorBottomNavigationBar(
        currentIndex: _navIndex,
        onTap: _onNavTap,
      ),
    );
  }

  void _onNavTap(int index) {
    switch (index) {
      case 0:
        context.go(AppRoutes.doctorDashboard);
      case 1:
        break;
      case 3:
        context.go(AppRoutes.doctorNotifications);
      case 4:
        context.go(AppRoutes.doctorSettings);
      default:
        setState(() => _navIndex = index);
    }
  }
}
