import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/routing/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/backgrounds/app_gradient_background.dart';
import '../../../../shared/widgets/navigation/app_top_bar.dart';
import '../../../../shared/widgets/navigation/ubuzima_bottom_nav.dart';
import '../../../authentication/domain/usecases/sign_out.dart';
import '../../domain/entities/health_record.dart';

/// CHW-01 — the community health worker's main dashboard. Shows today's
/// summary, quick actions, and a snapshot of the assigned patient list.
class ChwDashboardPage extends StatelessWidget {
  const ChwDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      bottomNavigationBar: UbuzimaBottomNav(
        currentIndex: 0,
        onTap: (i) async {
          if (i == 1) {
            context.go(AppRoutes.chwHealthRecord);
            return;
          }
          if (i == 4) {
            final result = await getIt<SignOut>()();
            if (!context.mounted) return;
            result.fold(
              (failure) => ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(failure.message)),
              ),
              (_) => context.go(AppRoutes.splash),
            );
          }
        },
        items: const [
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
          child: CustomScrollView(
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    _TopBar(),
                    const SizedBox(height: 20),
                    const _GreetingCard(),
                    const SizedBox(height: 20),
                    const _SectionLabel('Today\'s Summary'),
                    const SizedBox(height: 12),
                    const _SummaryRow(),
                    const SizedBox(height: 24),
                    const _SectionLabel('Quick Actions'),
                    const SizedBox(height: 12),
                    const _QuickActionsGrid(),
                    const SizedBox(height: 24),
                    const _SectionLabel('Recent Patients'),
                    const SizedBox(height: 12),
                    const _RecentPatientsList(),
                    const SizedBox(height: 24),
                    const _SectionLabel('Upcoming Visits'),
                    const SizedBox(height: 12),
                    const _UpcomingVisitsList(),
                  ]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AppTopBar(
      trailing: [
        CircleIconButton(
          icon: LucideIcons.bell,
          showDot: true,
          onTap: () {},
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
  const _SummaryRow();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _StatCard(
            icon: LucideIcons.users,
            count: '24',
            label: 'Patients',
            color: AppColors.primary,
            tint: AppColors.roleChwTint,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _StatCard(
            icon: LucideIcons.calendarCheck,
            count: '3',
            label: 'Visits today',
            color: AppColors.secondary,
            tint: AppColors.rolePatientTint,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _StatCard(
            icon: LucideIcons.triangleAlert,
            count: '2',
            label: 'Alerts',
            color: AppColors.warning,
            tint: const Color(0xFFFFF7ED),
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
        onTap: () => context.go(AppRoutes.chwHealthRecord),
      ),
      _QuickAction(
        icon: LucideIcons.share2,
        label: 'Refer Patient',
        color: AppColors.secondary,
        tint: AppColors.rolePatientTint,
        onTap: () => context.go(AppRoutes.chwReferral),
      ),
      _QuickAction(
        icon: LucideIcons.userRoundPlus,
        label: 'Register Patient',
        color: const Color(0xFF7C3AED),
        tint: const Color(0xFFF5F3FF),
        onTap: () {},
      ),
      _QuickAction(
        icon: LucideIcons.brain,
        label: 'AI Risk Check',
        color: AppColors.warning,
        tint: const Color(0xFFFFF7ED),
        onTap: () {},
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

final _kDemoPatients = [
  (name: 'Amina Uwase', detail: 'Female · 28y · Risk: Moderate', risk: RiskLevel.moderate),
  (name: 'Jean Habimana', detail: 'Male · 45y · Risk: High', risk: RiskLevel.high),
  (name: 'Marie Mukamana', detail: 'Female · 33y · Risk: Low', risk: RiskLevel.low),
];

class _RecentPatientsList extends StatelessWidget {
  const _RecentPatientsList();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (final p in _kDemoPatients) ...[
          _PatientRow(
            name: p.name,
            detail: p.detail,
            riskLevel: p.risk,
            onTap: () => context.go(AppRoutes.chwHealthRecord),
          ),
          const SizedBox(height: 8),
        ],
      ],
    );
  }
}

class _PatientRow extends StatelessWidget {
  final String name;
  final String detail;
  final RiskLevel riskLevel;
  final VoidCallback onTap;

  const _PatientRow({
    required this.name,
    required this.detail,
    required this.riskLevel,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final riskColor = _riskColor(riskLevel);

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
                      name,
                      style: const TextStyle(
                        fontSize: 14.5,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      detail,
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
                  _riskLabel(riskLevel),
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

const _kDemoVisits = [
  (time: '09:00', name: 'Amina Uwase', type: 'Prenatal check'),
  (time: '11:30', name: 'Claude Nzeyimana', type: 'Follow-up visit'),
  (time: '14:00', name: 'Olive Ingabire', type: 'Vaccination'),
];

class _UpcomingVisitsList extends StatelessWidget {
  const _UpcomingVisitsList();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (final v in _kDemoVisits) ...[
          _VisitRow(time: v.time, name: v.name, type: v.type),
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

  const _VisitRow({
    required this.time,
    required this.name,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
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
    );
  }
}
