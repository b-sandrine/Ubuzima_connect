import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/backgrounds/app_gradient_background.dart';
import '../../../../shared/widgets/navigation/app_top_bar.dart';
import '../bloc/referral_form_bloc.dart';
import '../widgets/referral_form_view.dart';

/// DOC-06 (creation) — the doctor's "+ New" referral form, reached from the
/// management board. Wraps the shared [ReferralFormView] with doctor framing.
class NewReferralPage extends StatelessWidget {
  const NewReferralPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<ReferralFormBloc>(),
      child: const _NewReferralView(),
    );
  }
}

class _NewReferralView extends StatelessWidget {
  const _NewReferralView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: AppGradientBackground(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppTopBar(onBack: () => Navigator.of(context).maybePop()),
                const SizedBox(height: 16),
                const Text(
                  'New Referral',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 3),
                const Text(
                  'Route a patient to a specialist and set the urgency',
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 20),
                ReferralFormView(
                  submitLabel: 'Send Referral',
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
