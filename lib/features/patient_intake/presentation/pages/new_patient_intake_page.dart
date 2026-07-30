import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/backgrounds/app_gradient_background.dart';
import '../../../../shared/widgets/buttons/gradient_button.dart';
import '../../domain/entities/patient_intake_draft.dart';
import '../bloc/patient_intake_bloc.dart';
import '../widgets/contact_information_section.dart';
import '../widgets/demographics_section.dart';
import '../widgets/emergency_flags_section.dart';
import '../widgets/household_details_section.dart';
import '../widgets/intake_header.dart';
import '../widgets/location_details_section.dart';
import '../widgets/personal_identity_section.dart';
import '../widgets/qr_capture_section.dart';
import '../widgets/registration_summary_section.dart';
import '../widgets/risk_screening_section.dart';
import '../widgets/step_completed_banner.dart';
import '../widgets/symptoms_section.dart';

/// The three-step New Patient Registration flow: Identity & Household,
/// Demographics & Contact, and Confirm & Submit. Each step renders as its
/// own scrollable body — long sections never get clipped — while a single
/// [PatientIntakeBloc] carries the draft across all three so nothing is
/// lost moving back and forth.
class NewPatientIntakePage extends StatelessWidget {
  const NewPatientIntakePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<PatientIntakeBloc>(),
      child: const _NewPatientIntakeView(),
    );
  }
}

class _NewPatientIntakeView extends StatelessWidget {
  const _NewPatientIntakeView();

  void _onBack(BuildContext context, PatientIntakeState state) {
    final bloc = context.read<PatientIntakeBloc>();
    if (state.step > 0) {
      bloc.add(PatientIntakeEvent.stepChanged(state.step - 1));
    } else {
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: AppGradientBackground(
        child: SafeArea(
          child: BlocConsumer<PatientIntakeBloc, PatientIntakeState>(
            listenWhen: (prev, curr) => prev.status != curr.status,
            listener: (context, state) {
              if (state.status == PatientIntakeStatus.failure &&
                  state.errorMessage != null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.errorMessage!)),
                );
              }
            },
            builder: (context, state) {
              if (state.status == PatientIntakeStatus.success) {
                return _SuccessView(draft: state.draft);
              }

              return SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 28),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    IntakeHeader(
                      step: state.step,
                      onBack: () => _onBack(context, state),
                    ),
                    const SizedBox(height: 18),
                    ..._stepContent(context, state),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  List<Widget> _stepContent(BuildContext context, PatientIntakeState state) {
    final bloc = context.read<PatientIntakeBloc>();
    void updateDraft(PatientIntakeDraft draft) =>
        bloc.add(PatientIntakeEvent.draftUpdated(draft));
    void goToStep(int step) =>
        bloc.add(PatientIntakeEvent.stepChanged(step));

    switch (state.step) {
      case 0:
        return [
          PersonalIdentitySection(draft: state.draft, onChanged: updateDraft),
          const SizedBox(height: 18),
          HouseholdDetailsSection(draft: state.draft, onChanged: updateDraft),
          const SizedBox(height: 18),
          const _QuickTip(
            message:
                "Fields marked with * are required. You can scan the "
                "patient's NID card using the QR icon for faster entry.",
          ),
          const SizedBox(height: 20),
          _StepNavRow(
            onBack: () => _onBack(context, state),
            primaryLabel: 'Next: Health Profile',
            onPrimary: state.canContinueIdentityStep
                ? () => goToStep(1)
                : null,
          ),
        ];
      case 1:
        return [
          StepCompletedBanner(
            title: 'Step 1 Completed',
            subtitle: _identitySummary(state.draft),
            onEdit: () => goToStep(0),
          ),
          const SizedBox(height: 18),
          ContactInformationSection(
            draft: state.draft,
            onChanged: updateDraft,
          ),
          const SizedBox(height: 18),
          DemographicsSection(draft: state.draft, onChanged: updateDraft),
          const SizedBox(height: 18),
          LocationDetailsSection(draft: state.draft, onChanged: updateDraft),
          const SizedBox(height: 18),
          QrCaptureSection(draft: state.draft, onChanged: updateDraft),
          const SizedBox(height: 18),
          const _QuickTip(
            message:
                'Capturing GPS coordinates helps with follow-up visits. QR '
                'code scanning speeds up future check-ins at clinics and '
                'pharmacies.',
          ),
          const SizedBox(height: 20),
          _StepNavRow(
            onBack: () => goToStep(0),
            primaryLabel: 'Next: Confirm & Submit',
            onPrimary: state.canContinueContactStep ? () => goToStep(2) : null,
          ),
        ];
      case 2:
        return [
          StepCompletedBanner(
            title: 'Steps 1 & 2 Completed',
            subtitle: _identitySummary(state.draft),
            onEdit: () => goToStep(0),
          ),
          const SizedBox(height: 18),
          SymptomsSection(draft: state.draft, onChanged: updateDraft),
          const SizedBox(height: 18),
          RiskScreeningSection(draft: state.draft, onChanged: updateDraft),
          const SizedBox(height: 18),
          EmergencyFlagsSection(draft: state.draft, onChanged: updateDraft),
          const SizedBox(height: 18),
          RegistrationSummarySection(draft: state.draft),
          const SizedBox(height: 18),
          const _ChwConfirmation(),
          const SizedBox(height: 20),
          _StepNavRow(
            onBack: () => goToStep(1),
            primaryLabel: 'Save & Submit Patient',
            primaryIcon: LucideIcons.send,
            isLoading: state.status == PatientIntakeStatus.submitting,
            onPrimary: state.canSubmit
                ? () => bloc.add(const PatientIntakeEvent.submitted())
                : null,
          ),
        ];
      default:
        return const [];
    }
  }

  String _identitySummary(PatientIntakeDraft draft) {
    final name = draft.fullName.isEmpty ? 'Unnamed patient' : draft.fullName;
    final gender = switch (draft.gender) {
      Gender.female => 'Female',
      Gender.male => 'Male',
      null => null,
    };
    final age = draft.age;
    final bits = [?gender, if (age != null) '$age yrs'].join(' · ');
    final location = [
      draft.district,
      draft.province,
    ].where((p) => p.trim().isNotEmpty).join(', ');

    final headline = bits.isEmpty ? name : '$name · $bits';
    return location.isEmpty ? headline : '$headline\n$location';
  }
}

class _QuickTip extends StatelessWidget {
  final String message;

  const _QuickTip({required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.secondary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.secondary.withValues(alpha: 0.2)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(LucideIcons.lightbulb, size: 18, color: AppColors.secondary),
          const SizedBox(width: 10),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: const TextStyle(
                  fontSize: 12,
                  height: 1.45,
                  color: AppColors.textSecondary,
                ),
                children: [
                  const TextSpan(
                    text: 'Quick Tip\n',
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  TextSpan(text: message),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ChwConfirmation extends StatelessWidget {
  const _ChwConfirmation();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(
                LucideIcons.badgeCheck,
                size: 18,
                color: AppColors.primary,
              ),
              const SizedBox(width: 10),
              const Expanded(
                child: Text(
                  'I confirm that all information provided is accurate and '
                  "was collected with the patient's consent as per Rwanda "
                  'Community Health protocols.',
                  style: TextStyle(
                    fontSize: 12,
                    height: 1.45,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: const BoxDecoration(
                  color: AppColors.primaryLight,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  LucideIcons.userRound,
                  size: 18,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 10),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Aline Mukamana',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    Text(
                      'CHW · Gasabo Sector · ID: CHW-KGL-0041',
                      style: TextStyle(
                        fontSize: 11,
                        color: AppColors.textTertiary,
                      ),
                    ),
                  ],
                ),
              ),
              const _VerifiedPill(),
            ],
          ),
        ],
      ),
    );
  }
}

class _VerifiedPill extends StatelessWidget {
  const _VerifiedPill();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(LucideIcons.check, size: 11, color: AppColors.primary),
          SizedBox(width: 3),
          Text(
            'Verified',
            style: TextStyle(
              fontSize: 10.5,
              fontWeight: FontWeight.w700,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }
}

class _StepNavRow extends StatelessWidget {
  final VoidCallback onBack;
  final String primaryLabel;
  final VoidCallback? onPrimary;
  final IconData? primaryIcon;
  final bool isLoading;

  const _StepNavRow({
    required this.onBack,
    required this.primaryLabel,
    required this.onPrimary,
    this.primaryIcon,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Material(
          color: Colors.white,
          shape: const CircleBorder(side: BorderSide(color: AppColors.border)),
          child: InkWell(
            onTap: onBack,
            customBorder: const CircleBorder(),
            child: const SizedBox(
              width: 52,
              height: 56,
              child: Icon(
                LucideIcons.chevronLeft,
                color: AppColors.textSecondary,
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: GradientButton(
            label: primaryLabel,
            icon: primaryIcon ?? LucideIcons.arrowRight,
            isLoading: isLoading,
            onPressed: onPrimary,
          ),
        ),
      ],
    );
  }
}

class _SuccessView extends StatelessWidget {
  final PatientIntakeDraft draft;

  const _SuccessView({required this.draft});

  @override
  Widget build(BuildContext context) {
    final risk = PatientRiskCalculator.calculate(draft);
    final name = draft.fullName.isEmpty ? 'The patient' : draft.fullName;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  LucideIcons.circleCheck,
                  color: AppColors.primary,
                  size: 36,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Patient registered',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                '$name has been added with a ${risk.level.name} risk rating '
                '(${risk.score}).',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 13,
                  height: 1.5,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 20),
              GradientButton(
                label: 'Done',
                icon: LucideIcons.check,
                onPressed: () => context.pop(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
