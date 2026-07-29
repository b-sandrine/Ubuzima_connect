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
          child: BlocConsumer<ReferralBoardBloc, ReferralBoardState>(
            listenWhen: (prev, curr) =>
                prev.errorMessage != curr.errorMessage &&
                curr.errorMessage != null,
            listener: (context, state) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.errorMessage!)));
            },
            builder: (context, state) {
              if (state.status == ReferralBoardStatus.loading ||
                  state.status == ReferralBoardStatus.initial) {
                return const Center(child: CircularProgressIndicator());
              }
              final board = state.board;
              if (board == null) {
                return const Center(child: Text('Could not load referrals.'));
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
        contextDot: true,
        trailing: const [
          CircleIconButton(icon: LucideIcons.bell, showDot: true),
        ],
      ),
      const SizedBox(height: 14),
      _PatientChip(
        patient: board.patient,
        referralCount: board.referrals.length,
      ),
      const SizedBox(height: 18),
      _Header(
        // Reload on return so a referral just created via "+ New" shows up in
        // the Outgoing queue without needing a manual refresh.
        onNew: () {
          context.push(AppRoutes.newReferral).then((_) {
            if (context.mounted) {
              bloc.add(const ReferralBoardEvent.started());
            }
          });
        },
      ),
      const SizedBox(height: 16),
      SegmentedTabs(
        tabs: const ['Incoming', 'Outgoing', 'Follow-Up'],
        icons: const [
          LucideIcons.inbox,
          LucideIcons.send,
          LucideIcons.bookmark,
        ],
        badges: [
          board.pendingCount(ReferralDirection.incoming) > 0
              ? board.pendingCount(ReferralDirection.incoming)
              : null,
          null,
          null,
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
            // Routing chips stay unselected until the doctor picks one; if
            // none is picked, Accept still routes to the referral's specialty.
            selectedRoute: _routes[referral.reference],
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
            onWithdraw: () =>
                bloc.add(ReferralBoardEvent.withdrawn(referral.reference)),
          ),
          const SizedBox(height: 14),
        ],
    ];
  }
}

/// The colour a patient's criticality tints their chip's border with — the
/// same pattern `PatientDetailHeader` uses in the doctors feature.
Color _criticalityColor(String criticality) {
  return switch (criticality.toLowerCase()) {
    'critical' => AppColors.danger,
    'urgent' => AppColors.warning,
    'stable' => AppColors.success,
    _ => AppColors.textTertiary,
  };
}

class _PatientChip extends StatelessWidget {
  final ReferralPatient patient;
  final int referralCount;

  const _PatientChip({required this.patient, required this.referralCount});

  @override
  Widget build(BuildContext context) {
    final criticalityColor = _criticalityColor(patient.criticality);

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: criticalityColor.withValues(alpha: 0.04),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: criticalityColor.withValues(alpha: 0.2)),
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
          _PatientAvatar(criticality: patient.criticality),
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
                      color: criticalityColor,
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
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    LucideIcons.link2,
                    size: 13,
                    color: AppColors.primary,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '$referralCount Referrals',
                    style: const TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 2),
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

class _PatientAvatar extends StatelessWidget {
  final String criticality;

  const _PatientAvatar({required this.criticality});

  @override
  Widget build(BuildContext context) {
    final dotColor = _criticalityColor(criticality);

    return SizedBox(
      width: 46,
      height: 46,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: AppColors.rolePatientTint,
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(
              LucideIcons.userRound,
              color: AppColors.rolePatient,
              size: 22,
            ),
          ),
          Positioned(
            right: -2,
            bottom: -2,
            child: Container(
              width: 13,
              height: 13,
              decoration: BoxDecoration(
                color: dotColor,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
              ),
            ),
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
            color: Color(0x3310B981),
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
                Icon(LucideIcons.plus, size: 18, color: Colors.white),
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
        color: AppColors.warning.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.warning.withValues(alpha: 0.25)),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.danger,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(LucideIcons.inbox, color: Colors.white, size: 20),
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
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _Dot(color: AppColors.danger),
                    SizedBox(width: 5),
                    Text(
                      'Urgent',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: AppColors.danger,
                      ),
                    ),
                  ],
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

class _Dot extends StatelessWidget {
  final Color color;

  const _Dot({required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 6,
      height: 6,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
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
            Icon(LucideIcons.inbox, size: 40, color: AppColors.textTertiary),
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
