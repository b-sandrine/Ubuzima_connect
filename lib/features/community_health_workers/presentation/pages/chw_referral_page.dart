import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/backgrounds/app_gradient_background.dart';
import '../../../../shared/widgets/navigation/app_top_bar.dart';
import '../../../../shared/widgets/navigation/ubuzima_bottom_nav.dart';
import '../../../../shared/widgets/pills/status_pill.dart';
import '../../../referrals/presentation/bloc/referral_form_bloc.dart';
import '../../../referrals/presentation/widgets/referral_form_view.dart';

/// CHW-06b — the community health worker's referral-to-hospital form. Reuses
/// the shared referrals form, framed for a CHW escalating a patient from the
/// field to a receiving hospital, with hospital destinations and the
/// escalation reasons a CHW actually routes on.
class ChwReferralPage extends StatelessWidget {
  const ChwReferralPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<ReferralFormBloc>(),
      child: const _ChwReferralView(),
    );
  }
}

class _ChwReferralView extends StatelessWidget {
  const _ChwReferralView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      bottomNavigationBar: const UbuzimaBottomNav(
        currentIndex: 2,
        items: [
          BottomNavItem(icon: Icons.home_outlined, label: 'Home'),
          BottomNavItem(icon: Icons.people_outline, label: 'Patients'),
          BottomNavItem(
            icon: Icons.local_hospital_outlined,
            label: 'Refer',
            isPrimary: true,
          ),
          BottomNavItem(icon: Icons.notifications_outlined, label: 'Alerts'),
          BottomNavItem(icon: Icons.settings_outlined, label: 'Settings'),
        ],
      ),
      body: AppGradientBackground(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppTopBar(
                  onBack: () => Navigator.of(context).maybePop(),
                  trailing: const [
                    CircleIconButton(icon: Icons.notifications_outlined),
                  ],
                ),
                const SizedBox(height: 14),
                const _ChwBadge(),
                const SizedBox(height: 16),
                const Text(
                  'Refer to Hospital',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 3),
                const Text(
                  'Escalate a patient from the field to a receiving hospital',
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 16),
                const _RoutingNotice(),
                const SizedBox(height: 20),
                ReferralFormView(
                  submitLabel: 'Send to Hospital',
                  specialties: const [
                    'Emergency',
                    'Maternity',
                    'Paediatrics',
                    'Internal Medicine',
                    'Surgery',
                  ],
                  facilities: const [
                    'Muhima District Hospital',
                    'Kibagabaga Hospital',
                    'CHUK',
                    'King Faisal Hospital',
                  ],
                  timelines: const [
                    'Immediately',
                    'Within 24 hours',
                    'Within 1 week',
                    'Routine',
                  ],
                  onCreated: (_) {},
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// The "CHW · Kigali Sector" identity chip carried across the CHW surfaces.
class _ChwBadge extends StatelessWidget {
  const _ChwBadge();

  @override
  Widget build(BuildContext context) {
    return const StatusPill(
      label: 'CHW · Kigali Sector',
      color: AppColors.primary,
      icon: Icons.badge_outlined,
      fontSize: 12,
    );
  }
}

class _RoutingNotice extends StatelessWidget {
  const _RoutingNotice();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.rolePatientTint.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.rolePatientTint),
      ),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: AppColors.secondary.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(11),
            ),
            child: const Icon(
              Icons.info_outline,
              color: AppColors.secondary,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Text(
              'This referral reaches the receiving hospital’s triage desk '
              'and syncs when you are back online.',
              style: TextStyle(
                fontSize: 12.5,
                height: 1.4,
                color: AppColors.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
