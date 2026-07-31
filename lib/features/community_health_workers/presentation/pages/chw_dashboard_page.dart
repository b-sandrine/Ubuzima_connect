import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/routing/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/backgrounds/app_gradient_background.dart';
import '../../../../shared/widgets/navigation/app_top_bar.dart';
import '../../../patient_intake/domain/entities/patient_intake_draft.dart';
import '../../../patient_intake/domain/entities/registered_patient.dart';
import '../../../patient_intake/domain/usecases/list_registered_patients.dart';
import '../../data/repositories/chw_caseload_repository.dart';
import '../../domain/entities/chw_day_briefing.dart';
import '../../domain/entities/chw_upcoming_visit.dart';
import '../widgets/chw_bottom_nav.dart';

class _DashboardInsights {
  final List<RegisteredPatient> patients;
  final List<ChwUpcomingVisit> visits;
  final int alertCount;
  final List<ChwEmergencyAlert> emergencies;
  final ChwDayBriefing briefing;

  const _DashboardInsights({
    required this.patients,
    required this.visits,
    required this.alertCount,
    required this.emergencies,
    required this.briefing,
  });
}

/// CHW-01 — the community health worker's main dashboard. Shows today's
/// summary, quick actions, and a snapshot of the assigned patient list.
class ChwDashboardPage extends StatefulWidget {
  final ListRegisteredPatients _listRegisteredPatients;
  final ChwCaseloadRepository _caseload;

  ChwDashboardPage({
    super.key,
    ListRegisteredPatients? listRegisteredPatients,
    ChwCaseloadRepository? caseload,
  }) : _listRegisteredPatients =
           listRegisteredPatients ?? getIt<ListRegisteredPatients>(),
       _caseload = caseload ?? getIt<ChwCaseloadRepository>();

  @override
  State<ChwDashboardPage> createState() => _ChwDashboardPageState();
}

class _ChwDashboardPageState extends State<ChwDashboardPage> {
  late Future<_DashboardInsights> _insightsFuture;

  @override
  void initState() {
    super.initState();
    _insightsFuture = _loadInsights();
  }

  Future<_DashboardInsights> _loadInsights() async {
    final patientsResult = await widget._listRegisteredPatients();
    final patients = patientsResult.fold(
      (_) => throw Exception('Could not load patients.'),
      (p) => p,
    );
    final visits = await widget._caseload.listUpcomingVisits();
    final alertCount = await widget._caseload.alertCount();
    final emergencies = await widget._caseload.listEmergencyAlerts();
    final briefing = await widget._caseload.getDayBriefing(
      emergencies: emergencies,
      visits: visits,
      patientCount: patients.length,
      alertCount: alertCount,
    );
    return _DashboardInsights(
      patients: patients,
      visits: visits,
      alertCount: alertCount,
      emergencies: emergencies,
      briefing: briefing,
    );
  }

  Future<void> _refreshInsights() async {
    final next = _loadInsights();
    setState(() => _insightsFuture = next);
    await next;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      bottomNavigationBar: const ChwBottomNav(currentIndex: 0),
      body: AppGradientBackground(
        child: SafeArea(
          child: FutureBuilder<_DashboardInsights>(
            future: _insightsFuture,
            builder: (context, snapshot) {
              final insights = snapshot.data;
              return CustomScrollView(
                slivers: [
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                    sliver: SliverList(
                      delegate: SliverChildListDelegate([
                        _TopBar(
                          onBellTap: () =>
                              context.go(AppRoutes.chwNotifications),
                        ),
                        const SizedBox(height: 20),
                        const _GreetingCard(),
                        const SizedBox(height: 20),
                        const _SectionLabel('Today\'s Summary'),
                        const SizedBox(height: 12),
                        _SummaryRow(
                          patientCount: insights?.patients.length,
                          visitCount: insights?.visits.length,
                          alertCount: insights?.alertCount,
                          loading: snapshot.connectionState !=
                              ConnectionState.done,
                        ),
                        const SizedBox(height: 24),
                        _EmergencyAlertsSection(
                          alerts: insights?.emergencies ?? const [],
                          loading: snapshot.connectionState !=
                              ConnectionState.done,
                        ),
                        const SizedBox(height: 24),
                        _AiDayBriefingCard(
                          briefing: insights?.briefing,
                          loading: snapshot.connectionState !=
                              ConnectionState.done,
                        ),
                        const SizedBox(height: 24),
                        const _SectionLabel('Quick Actions'),
                        const SizedBox(height: 12),
                        const _QuickActionsGrid(),
                        const SizedBox(height: 24),
                        _RecentPatientsHeader(),
                        const SizedBox(height: 12),
                        if (snapshot.hasError)
                          _RecentPatientsMessage(
                            icon: LucideIcons.triangleAlert,
                            title: 'Could not load patients',
                            subtitle:
                                'Pull to retry, or open the full patient list.',
                            actionLabel: 'Retry',
                            onAction: _refreshInsights,
                          )
                        else if (insights == null)
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 24),
                            child: Center(
                              child: SizedBox(
                                width: 28,
                                height: 28,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.5,
                                ),
                              ),
                            ),
                          )
                        else
                          _RecentPatientsList(
                            patients: insights.patients,
                            onRefresh: _refreshInsights,
                          ),
                        const SizedBox(height: 24),
                        const _SectionLabel('Upcoming Visits'),
                        const SizedBox(height: 12),
                        _UpcomingVisitsList(
                          visits: insights?.visits ?? const [],
                          loading: snapshot.connectionState !=
                              ConnectionState.done,
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

class _TopBar extends StatelessWidget {
  final VoidCallback onBellTap;

  const _TopBar({required this.onBellTap});

  @override
  Widget build(BuildContext context) {
    return AppTopBar(
      trailing: [
        CircleIconButton(
          icon: LucideIcons.bell,
          showDot: true,
          onTap: onBellTap,
        ),
        _CwAvatar(),
      ],
    );
  }
}

class _CwAvatar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: AppColors.roleChwTint,
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.primary, width: 2),
      ),
      child: const Icon(
        LucideIcons.userRound,
        size: 20,
        color: AppColors.primary,
      ),
    );
  }
}

class _GreetingCard extends StatelessWidget {
  const _GreetingCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF10B981), Color(0xFF2563EB)],
        ),
        borderRadius: BorderRadius.circular(22),
        boxShadow: const [
          BoxShadow(
            color: Color(0x3310B981),
            blurRadius: 16,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _greeting(),
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Colors.white70,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Community Health Worker',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: const Text(
                    'CHW · Kigali Sector',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              LucideIcons.heartPulse,
              size: 30,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  String _greeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good morning,';
    if (hour < 17) return 'Good afternoon,';
    return 'Good evening,';
  }
}

class _SectionLabel extends StatelessWidget {
  final String text;

  const _SectionLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w800,
        color: AppColors.textPrimary,
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final int? patientCount;
  final int? visitCount;
  final int? alertCount;
  final bool loading;

  const _SummaryRow({
    required this.patientCount,
    required this.visitCount,
    required this.alertCount,
    required this.loading,
  });

  String _value(int? count) {
    if (loading) return '…';
    if (count == null) return '—';
    return '$count';
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _StatCard(
            icon: LucideIcons.users,
            count: _value(patientCount),
            label: 'Patients',
            color: AppColors.primary,
            tint: AppColors.roleChwTint,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _StatCard(
            icon: LucideIcons.calendarCheck,
            count: _value(visitCount),
            label: 'Visits today',
            color: AppColors.secondary,
            tint: AppColors.rolePatientTint,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: InkWell(
            onTap: () => context.go(AppRoutes.chwNotifications),
            borderRadius: BorderRadius.circular(18),
            child: _StatCard(
              icon: LucideIcons.triangleAlert,
              count: _value(alertCount),
              label: 'Alerts',
              color: AppColors.warning,
              tint: const Color(0xFFFFF7ED),
            ),
          ),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String count;
  final String label;
  final Color color;
  final Color tint;

  const _StatCard({
    required this.icon,
    required this.count,
    required this.label,
    required this.color,
    required this.tint,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A0F172A),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: tint,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 18, color: color),
          ),
          const SizedBox(height: 10),
          Text(
            count,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: color,
              height: 1,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            label,
            style: const TextStyle(
              fontSize: 11.5,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

class _EmergencyAlertsSection extends StatelessWidget {
  final List<ChwEmergencyAlert> alerts;
  final bool loading;

  const _EmergencyAlertsSection({
    required this.alerts,
    required this.loading,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Expanded(child: _SectionLabel('Emergency Alerts')),
            TextButton(
              onPressed: () => context.go(AppRoutes.chwNotifications),
              child: const Text(
                'See all',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: AppColors.danger,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        if (loading)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Center(
              child: SizedBox(
                width: 28,
                height: 28,
                child: CircularProgressIndicator(strokeWidth: 2.5),
              ),
            ),
          )
        else if (alerts.isEmpty)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFF0FDF4),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFBBF7D0)),
            ),
            child: const Row(
              children: [
                Icon(
                  LucideIcons.shieldCheck,
                  size: 20,
                  color: AppColors.primary,
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'No emergency flags right now. Keep screening on visits.',
                    style: TextStyle(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                      height: 1.35,
                    ),
                  ),
                ),
              ],
            ),
          )
        else
          Column(
            children: [
              for (final alert in alerts) ...[
                _EmergencyAlertRow(alert: alert),
                const SizedBox(height: 8),
              ],
            ],
          ),
      ],
    );
  }
}

class _EmergencyAlertRow extends StatelessWidget {
  final ChwEmergencyAlert alert;

  const _EmergencyAlertRow({required this.alert});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: () => context.push(
          AppRoutes.chwHealthRecordFor(alert.patientId),
        ),
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFFECACA)),
            color: const Color(0xFFFFF1F2),
          ),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.danger.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  LucideIcons.siren,
                  size: 20,
                  color: AppColors.danger,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      alert.patientName,
                      style: const TextStyle(
                        fontSize: 14.5,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      alert.flagsLabel,
                      style: const TextStyle(
                        fontSize: 12.5,
                        color: AppColors.danger,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (alert.location.isNotEmpty) ...[
                      const SizedBox(height: 2),
                      Text(
                        alert.location,
                        style: const TextStyle(
                          fontSize: 11.5,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const Icon(
                LucideIcons.chevronRight,
                size: 16,
                color: AppColors.textTertiary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AiDayBriefingCard extends StatelessWidget {
  final ChwDayBriefing? briefing;
  final bool loading;

  const _AiDayBriefingCard({
    required this.briefing,
    required this.loading,
  });

  static const _teal = Color(0xFF0F766E);
  static const _tealLight = Color(0xFF14B8A6);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SectionLabel('AI Recommendations'),
        const SizedBox(height: 12),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [_teal, _tealLight],
            ),
            borderRadius: BorderRadius.circular(18),
            boxShadow: const [
              BoxShadow(
                color: Color(0x3314B8A6),
                blurRadius: 16,
                offset: Offset(0, 6),
              ),
            ],
          ),
          child: loading || briefing == null
              ? const Padding(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  child: Center(
                    child: SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        color: Colors.white,
                      ),
                    ),
                  ),
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(
                          LucideIcons.sparkles,
                          size: 18,
                          color: Colors.white,
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Your day at a glance',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      briefing!.summary,
                      style: TextStyle(
                        fontSize: 13,
                        height: 1.45,
                        color: Colors.white.withValues(alpha: 0.95),
                      ),
                    ),
                    if (briefing!.recommendations.isNotEmpty) ...[
                      const SizedBox(height: 14),
                      Text(
                        'What to do',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: Colors.white.withValues(alpha: 0.85),
                        ),
                      ),
                      const SizedBox(height: 8),
                      for (final tip in briefing!.recommendations) ...[
                        Padding(
                          padding: const EdgeInsets.only(bottom: 6),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Padding(
                                padding: EdgeInsets.only(top: 2),
                                child: Icon(
                                  LucideIcons.circleCheck,
                                  size: 14,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  tip,
                                  style: TextStyle(
                                    fontSize: 12.5,
                                    height: 1.35,
                                    color: Colors.white.withValues(alpha: 0.95),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ],
                ),
        ),
      ],
    );
  }
}

class _QuickActionsGrid extends StatelessWidget {
  const _QuickActionsGrid();

  @override
  Widget build(BuildContext context) {
    final actions = [
      _QuickAction(
        icon: LucideIcons.clipboardPlus,
        label: 'New Visit',
        color: AppColors.primary,
        tint: AppColors.roleChwTint,
        onTap: () => context.go(AppRoutes.chwPatientList),
      ),
      _QuickAction(
        icon: LucideIcons.share2,
        label: 'Refer Patient',
        color: AppColors.secondary,
        tint: AppColors.rolePatientTint,
        onTap: () => context.push(AppRoutes.chwReferral),
      ),
      _QuickAction(
        icon: LucideIcons.userRoundPlus,
        label: 'Register Patient',
        color: const Color(0xFF7C3AED),
        tint: const Color(0xFFF5F3FF),
        onTap: () => context.push(AppRoutes.newPatientIntake),
      ),
      _QuickAction(
        icon: LucideIcons.brain,
        label: 'AI Risk Check',
        color: AppColors.warning,
        tint: const Color(0xFFFFF7ED),
        onTap: () => context.go(AppRoutes.chwPatientList),
      ),
    ];

    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 10,
      crossAxisSpacing: 10,
      childAspectRatio: 2.2,
      children: actions,
    );
  }
}

class _QuickAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final Color tint;
  final VoidCallback onTap;

  const _QuickAction({
    required this.icon,
    required this.label,
    required this.color,
    required this.tint,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.border),
          ),
          child: Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: tint,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, size: 18, color: color),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  label,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// -- Recent patients --

class _RecentPatientsHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(child: _SectionLabel('Recent Patients')),
        TextButton(
          onPressed: () => context.go(AppRoutes.chwPatientList),
          child: const Text(
            'See all',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: AppColors.roleChw,
            ),
          ),
        ),
      ],
    );
  }
}

class _RecentPatientsList extends StatelessWidget {
  final List<RegisteredPatient> patients;
  final Future<void> Function() onRefresh;

  static const _previewLimit = 5;

  const _RecentPatientsList({
    required this.patients,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    if (patients.isEmpty) {
      return _RecentPatientsMessage(
        icon: LucideIcons.users,
        title: 'No patients yet',
        subtitle: 'Register a community patient to see them here.',
        actionLabel: 'Register patient',
        onAction: () => context.push(AppRoutes.newPatientIntake),
      );
    }

    final preview = patients.take(_previewLimit).toList();
    return Column(
      children: [
        for (final patient in preview) ...[
          _PatientRow(
            patient: patient,
            onTap: () => context.push(
              AppRoutes.chwHealthRecordFor(patient.id),
            ),
          ),
          const SizedBox(height: 8),
        ],
        if (patients.length > _previewLimit)
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton(
              onPressed: () => context.go(AppRoutes.chwPatientList),
              child: Text(
                'View all ${patients.length} patients',
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  color: AppColors.roleChw,
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class _RecentPatientsMessage extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String actionLabel;
  final VoidCallback onAction;

  const _RecentPatientsMessage({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.actionLabel,
    required this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          Icon(icon, color: AppColors.textTertiary, size: 28),
          const SizedBox(height: 10),
          Text(
            title,
            style: const TextStyle(
              fontSize: 14.5,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 12.5,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 12),
          TextButton(onPressed: onAction, child: Text(actionLabel)),
        ],
      ),
    );
  }
}

class _PatientRow extends StatelessWidget {
  final RegisteredPatient patient;
  final VoidCallback onTap;

  const _PatientRow({
    required this.patient,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final riskColor = _riskColor(patient.riskLevel);

    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
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
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(
                  LucideIcons.userRound,
                  color: AppColors.primary,
                  size: 22,
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
                        fontSize: 14.5,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      patient.detailLine,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: riskColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  _riskLabel(patient.riskLevel),
                  style: TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w700,
                    color: riskColor,
                  ),
                ),
              ),
              const SizedBox(width: 6),
              const Icon(
                LucideIcons.chevronRight,
                size: 16,
                color: AppColors.textTertiary,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _riskColor(RiskLevel level) => switch (level) {
        RiskLevel.low => AppColors.primary,
        RiskLevel.moderate => const Color(0xFFEA580C),
        RiskLevel.high => AppColors.danger,
        RiskLevel.critical => const Color(0xFF7F1D1D),
      };

  String _riskLabel(RiskLevel level) => switch (level) {
        RiskLevel.low => 'Low',
        RiskLevel.moderate => 'Moderate',
        RiskLevel.high => 'High',
        RiskLevel.critical => 'Critical',
      };
}

// -- Upcoming visits --

class _UpcomingVisitsList extends StatelessWidget {
  final List<ChwUpcomingVisit> visits;
  final bool loading;

  const _UpcomingVisitsList({
    required this.visits,
    required this.loading,
  });

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 16),
        child: Center(
          child: SizedBox(
            width: 28,
            height: 28,
            child: CircularProgressIndicator(strokeWidth: 2.5),
          ),
        ),
      );
    }

    if (visits.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border),
        ),
        child: const Text(
          'No upcoming visits scheduled. High-risk follow-ups will appear here.',
          style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
        ),
      );
    }

    return Column(
      children: [
        for (final v in visits) ...[
          _VisitRow(
            time: v.timeLabel,
            name: v.patientName,
            type: v.type,
            onTap: () => context.push(
              AppRoutes.chwHealthRecordFor(v.patientId),
            ),
          ),
          const SizedBox(height: 8),
        ],
      ],
    );
  }
}

class _VisitRow extends StatelessWidget {
  final String time;
  final String name;
  final String type;
  final VoidCallback? onTap;

  const _VisitRow({
    required this.time,
    required this.name,
    required this.type,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.border),
            boxShadow: const [
              BoxShadow(
                color: Color(0x0A0F172A),
                blurRadius: 8,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.roleChwTint,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  time,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color: AppColors.primaryDark,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      type,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                LucideIcons.calendarClock,
                size: 18,
                color: AppColors.textTertiary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
