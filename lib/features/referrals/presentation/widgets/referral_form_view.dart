import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/buttons/gradient_button.dart';
import '../../domain/entities/referral.dart';
import '../bloc/referral_form_bloc.dart';

/// The referral-creation form shared by the doctor's "+ New" flow (DOC-06)
/// and the CHW referral-to-hospital flow (CHW-06b). It expects a
/// [ReferralFormBloc] provided above it; the two screens differ only in the
/// framing text and which specialties/facilities they suggest.
class ReferralFormView extends StatelessWidget {
  final String submitLabel;
  final List<String> specialties;
  final List<String> facilities;
  final List<String> timelines;

  /// Called once a referral is created, with its assigned reference.
  final ValueChanged<String>? onCreated;

  const ReferralFormView({
    super.key,
    this.submitLabel = 'Submit Referral',
    this.onCreated,
    this.specialties = const [
      'Cardiology',
      'Nephrology',
      'Ophthalmology',
      'Neurology',
      'Endocrinology',
    ],
    this.facilities = const [
      'CHUK',
      'CHUB',
      'Rwanda Military Hospital',
      'King Faisal Hospital',
    ],
    this.timelines = const [
      'Within 48 hours',
      'Within 1 week',
      'Within 4 weeks',
      'Routine',
    ],
  });

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ReferralFormBloc, ReferralFormState>(
      listenWhen: (prev, curr) => prev.status != curr.status,
      listener: (context, state) {
        if (state.status == ReferralFormStatus.success &&
            state.createdReference != null) {
          onCreated?.call(state.createdReference!);
        } else if (state.status == ReferralFormStatus.failure &&
            state.errorMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.errorMessage!)),
          );
        }
      },
      builder: (context, state) {
        if (state.status == ReferralFormStatus.success) {
          return _SuccessPanel(reference: state.createdReference!);
        }

        final bloc = context.read<ReferralFormBloc>();
        final draft = state.draft;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _Field(
              label: 'Patient name',
              hint: 'e.g. Marie Uwase',
              value: draft.patientName,
              onChanged: (v) => bloc.add(
                ReferralFormEvent.fieldChanged(ReferralField.patientName, v),
              ),
            ),
            const SizedBox(height: 16),
            _ChoiceField(
              label: 'Destination facility',
              options: facilities,
              selected: draft.destinationFacility,
              onSelected: (v) => bloc.add(
                ReferralFormEvent.fieldChanged(
                  ReferralField.destinationFacility,
                  v,
                ),
              ),
            ),
            const SizedBox(height: 16),
            _ChoiceField(
              label: 'Specialty',
              options: specialties,
              selected: draft.specialty,
              onSelected: (v) => bloc.add(
                ReferralFormEvent.fieldChanged(ReferralField.specialty, v),
              ),
            ),
            const SizedBox(height: 16),
            _UrgencyField(
              selected: draft.urgency,
              onSelected: (u) =>
                  bloc.add(ReferralFormEvent.urgencyChanged(u)),
            ),
            const SizedBox(height: 16),
            _Field(
              label: 'Reason for referral',
              hint: 'Clinical reason and what is being requested',
              value: draft.reason,
              maxLines: 3,
              onChanged: (v) => bloc.add(
                ReferralFormEvent.fieldChanged(ReferralField.reason, v),
              ),
            ),
            const SizedBox(height: 16),
            _Field(
              label: 'Clinical summary (optional)',
              hint: 'BP, HR, labs, relevant vitals',
              value: draft.clinicalSummary,
              maxLines: 2,
              onChanged: (v) => bloc.add(
                ReferralFormEvent.fieldChanged(
                  ReferralField.clinicalSummary,
                  v,
                ),
              ),
            ),
            const SizedBox(height: 16),
            _ChoiceField(
              label: 'Requested timeline',
              options: timelines,
              selected: draft.requestedTimeline,
              onSelected: (v) => bloc.add(
                ReferralFormEvent.fieldChanged(
                  ReferralField.requestedTimeline,
                  v,
                ),
              ),
            ),
            const SizedBox(height: 24),
            GradientButton(
              label: submitLabel,
              icon: Icons.send_rounded,
              isLoading: state.status == ReferralFormStatus.submitting,
              onPressed: state.canSubmit
                  ? () => bloc.add(const ReferralFormEvent.submitted())
                  : null,
            ),
            const SizedBox(height: 16),
          ],
        );
      },
    );
  }
}

class _Field extends StatelessWidget {
  final String label;
  final String hint;
  final String value;
  final int maxLines;
  final ValueChanged<String> onChanged;

  const _Field({
    required this.label,
    required this.hint,
    required this.value,
    required this.onChanged,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _Label(label),
        const SizedBox(height: 8),
        TextFormField(
          initialValue: value,
          maxLines: maxLines,
          onChanged: onChanged,
          style: const TextStyle(fontSize: 14, color: AppColors.textPrimary),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(
              fontSize: 13.5,
              color: AppColors.textTertiary,
            ),
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 12,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: AppColors.border),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: AppColors.primary, width: 1.6),
            ),
          ),
        ),
      ],
    );
  }
}

class _ChoiceField extends StatelessWidget {
  final String label;
  final List<String> options;
  final String selected;
  final ValueChanged<String> onSelected;

  const _ChoiceField({
    required this.label,
    required this.options,
    required this.selected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _Label(label),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final option in options)
              _Chip(
                label: option,
                isSelected: option == selected,
                onTap: () => onSelected(option),
              ),
          ],
        ),
      ],
    );
  }
}

class _UrgencyField extends StatelessWidget {
  final ReferralUrgency selected;
  final ValueChanged<ReferralUrgency> onSelected;

  const _UrgencyField({required this.selected, required this.onSelected});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _Label('Urgency'),
        const SizedBox(height: 8),
        Row(
          children: [
            for (final urgency in ReferralUrgency.values) ...[
              Expanded(
                child: _UrgencyOption(
                  urgency: urgency,
                  isSelected: urgency == selected,
                  onTap: () => onSelected(urgency),
                ),
              ),
              if (urgency != ReferralUrgency.values.last)
                const SizedBox(width: 8),
            ],
          ],
        ),
      ],
    );
  }
}

class _UrgencyOption extends StatelessWidget {
  final ReferralUrgency urgency;
  final bool isSelected;
  final VoidCallback onTap;

  const _UrgencyOption({
    required this.urgency,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final (label, color) = switch (urgency) {
      ReferralUrgency.urgent => ('Urgent', AppColors.danger),
      ReferralUrgency.pending => ('Priority', AppColors.warning),
      ReferralUrgency.routine => ('Routine', AppColors.secondary),
    };
    return Material(
      color: isSelected ? color.withValues(alpha: 0.12) : Colors.white,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          height: 42,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? color : AppColors.border,
              width: isSelected ? 1.6 : 1,
            ),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: isSelected ? color : AppColors.textSecondary,
            ),
          ),
        ),
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _Chip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: isSelected ? AppColors.primary : Colors.white,
      borderRadius: BorderRadius.circular(999),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(999),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(999),
            border: Border.all(
              color: isSelected ? AppColors.primary : AppColors.border,
            ),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12.5,
              fontWeight: FontWeight.w600,
              color: isSelected ? Colors.white : AppColors.textSecondary,
            ),
          ),
        ),
      ),
    );
  }
}

class _Label extends StatelessWidget {
  final String text;

  const _Label(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 12.5,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
      ),
    );
  }
}

class _SuccessPanel extends StatelessWidget {
  final String reference;

  const _SuccessPanel({required this.reference});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.check_circle,
              color: AppColors.primary,
              size: 36,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Referral submitted',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Reference #$reference has been sent and is awaiting acceptance.',
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
            icon: Icons.check,
            onPressed: () => Navigator.of(context).maybePop(),
          ),
        ],
      ),
    );
  }
}
