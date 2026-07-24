import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/routing/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/backgrounds/app_gradient_background.dart';
import '../../../../shared/widgets/navigation/app_top_bar.dart';
import '../../../../shared/widgets/navigation/segmented_tabs.dart';
import '../../../../shared/widgets/navigation/ubuzima_bottom_nav.dart';
import '../../../../shared/widgets/pills/status_pill.dart';
import '../../domain/entities/referral.dart';
import '../../domain/entities/referral_board.dart';
import '../bloc/referral_board_bloc.dart';
import '../widgets/referral_card.dart';

/// DOC-06 — the doctor's referral management board. Incoming / Outgoing /
/// Follow-Up queues with a pending banner, per-card Accept / Decline with
/// specialty routing, and a "+ New" entry into referral creation.
class ReferralManagementPage extends StatelessWidget {
  const ReferralManagementPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          getIt<ReferralBoardBloc>()..add(const ReferralBoardEvent.started()),
      child: const _ReferralManagementView(),
    );
  }
}

class _ReferralManagementView extends StatefulWidget {
  const _ReferralManagementView();

  @override
  State<_ReferralManagementView> createState() =>
      _ReferralManagementViewState();
}

class _ReferralManagementViewState extends State<_ReferralManagementView> {
  /// The routing choice per referral reference, held in the view since it is
  /// a transient UI selection until Accept is pressed.
  final Map<String, String> _routes = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
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
          child: BlocConsumer<ReferralBoardBloc, ReferralBoardState>(
            listenWhen: (prev, curr) =>
                prev.errorMessage != curr.errorMessage &&
                curr.errorMessage != null,
            listener: (context, state) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.errorMessage!)),
              );
            },
            builder: (context, state) {
              if (state.status == ReferralBoardStatus.loading ||
                  state.status == ReferralBoardStatus.initial) {
                return const Center(child: CircularProgressIndicator());
              }
              final board = state.board;
              if (board == null) {
                return const Center(
                  child: Text('Could not load referrals.'),
                );
              }

              return CustomScrollView(
                slivers: [
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 20),
                    sliver: SliverList(
                      delegate: SliverChildListDelegate(
                        _content(context, state, board),
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
    ReferralBoardState state,
    ReferralBoard board,
  ) {
    final bloc = context.read<ReferralBoardBloc>();
    final pending = board.pendingCount(state.direction);
    final urgent = board.urgentCount(state.direction);

    return [
      AppTopBar(
        onBack: () => Navigator.of(context).maybePop(),
        contextLabel: 'LIVE',
        contextColor: AppColors.primary,
        contextIcon: Icons.circle,
        trailing: const [
          CircleIconButton(icon: Icons.notifications_outlined, showDot: true),
        ],
      ),
      const SizedBox(height: 14),
      _PatientChip(patient: board.patient, referralCount: board.referrals.length),
      const SizedBox(height: 18),
      _Header(
        onNew: () => context.push(AppRoutes.newReferral),
      ),
      const SizedBox(height: 16),
      SegmentedTabs(
        tabs: [
          'Incoming${board.pendingCount(ReferralDirection.incoming) > 0 ? '  ${board.pendingCount(ReferralDirection.incoming)}' : ''}',
          'Outgoing',
          'Follow-Up',
        ],
        selectedIndex: state.selectedTab,
        onSelected: (i) => bloc.add(ReferralBoardEvent.tabChanged(i)),
      ),
      const SizedBox(height: 16),
      if (pending > 0) ...[
        _PendingBanner(pending: pending, urgent: urgent),
        const SizedBox(height: 16),
      ],
      if (state.visibleReferrals.isEmpty)
        const _EmptyQueue()
      else
        for (final referral in state.visibleReferrals) ...[
          ReferralCard(
            referral: referral,
            selectedRoute:
                _routes[referral.reference] ?? referral.specialty,
            isBusy: state.actioningReference == referral.reference,
            onRouteSelected: (route) =>
                setState(() => _routes[referral.reference] = route),
            onAccept: () => bloc.add(
              ReferralBoardEvent.accepted(
                referral.reference,
                routedSpecialty:
                    _routes[referral.reference] ?? referral.specialty,
              ),
            ),
            onDecline: () =>
                bloc.add(ReferralBoardEvent.declined(referral.reference)),
          ),
          const SizedBox(height: 14),
        ],
    ];
  }
}

class _PatientChip extends StatelessWidget {
  final ReferralPatient patient;
  final int referralCount;

  const _PatientChip({required this.patient, required this.referralCount});

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
                  'ID: ${patient.id} · ${patient.summary}',
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
                '$referralCount Referrals',
                style: const TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                ),
              ),
              const Text(
                'Active session',
                style: TextStyle(fontSize: 11, color: AppColors.textTertiary),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  final VoidCallback onNew;

  const _Header({required this.onNew});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Referral Management',
                style: TextStyle(
                  fontSize: 23,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
              ),
              SizedBox(height: 3),
              Text(
                'Specialty routing · Accept / Reject · Follow-up',
                style: TextStyle(
                  fontSize: 12.5,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        _NewButton(onTap: onNew),
      ],
    );
  }
}

class _NewButton extends StatelessWidget {
  final VoidCallback onTap;

  const _NewButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: AppColors.primaryGradient),
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [
          BoxShadow(
            color: Color(0x3316A34A),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(14),
          child: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 11),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.add, size: 18, color: Colors.white),
                SizedBox(width: 6),
                Text(
                  'New',
                  style: TextStyle(
                    fontSize: 14.5,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
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

class _PendingBanner extends StatelessWidget {
  final int pending;
  final int urgent;

  const _PendingBanner({required this.pending, required this.urgent});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFFEF2F2),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFFECACA)),
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
              Icons.inbox_outlined,
              color: AppColors.danger,
              size: 22,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$pending Pending ${pending == 1 ? 'Referral' : 'Referrals'}',
                  style: const TextStyle(
                    fontSize: 14.5,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  urgent > 0
                      ? '$urgent urgent · Requires your action today'
                      : 'Requires your review',
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          if (urgent > 0)
            const Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                StatusPill(
                  label: 'Urgent',
                  color: AppColors.danger,
                  icon: Icons.circle,
                  fontSize: 10.5,
                ),
                SizedBox(height: 3),
                Text(
                  'Just received',
                  style: TextStyle(
                    fontSize: 10.5,
                    color: AppColors.textTertiary,
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}

class _EmptyQueue extends StatelessWidget {
  const _EmptyQueue();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 48),
      child: Center(
        child: Column(
          children: [
            Icon(
              Icons.inbox_outlined,
              size: 44,
              color: AppColors.textTertiary,
            ),
            SizedBox(height: 12),
            Text(
              'No referrals in this queue',
              style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
            ),
          ],
        ),
      ),
    );
  }
}
