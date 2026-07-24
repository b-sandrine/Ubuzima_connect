import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/pills/status_pill.dart';
import '../../domain/entities/referral.dart';

/// One referral in the DOC-06 queue: identity, the clinical narrative, the
/// requested timeline, optional specialty routing, and the Accept / Decline
/// actions. Once actioned it settles into a status strip instead of buttons.
class ReferralCard extends StatelessWidget {
  final Referral referral;

  /// The specialty currently chosen from the routing chips, if any.
  final String? selectedRoute;
  final ValueChanged<String>? onRouteSelected;
  final VoidCallback onAccept;
  final VoidCallback onDecline;
  final bool isBusy;

  const ReferralCard({
    super.key,
    required this.referral,
    required this.onAccept,
    required this.onDecline,
    this.selectedRoute,
    this.onRouteSelected,
    this.isBusy = false,
  });

  @override
  Widget build(BuildContext context) {
    final isPending = referral.status == ReferralStatus.pending;
    final showRouting =
        isPending &&
        referral.direction == ReferralDirection.incoming &&
        referral.routeOptions.isNotEmpty;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A0F172A),
            blurRadius: 14,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _Header(referral: referral),
          const SizedBox(height: 4),
          Text(
            'Ref #${referral.reference} · ${referral.receivedLabel}',
            style: const TextStyle(fontSize: 12, color: AppColors.textTertiary),
          ),
          const SizedBox(height: 14),
          _Section(
            icon: Icons.person_outline,
            label: 'Referring Physician',
            body:
                '${referral.referringPhysician} · ${referral.referringFacility}',
          ),
          const SizedBox(height: 12),
          _Section(
            icon: Icons.info_outline,
            label: 'Reason for Referral',
            body: referral.reason,
          ),
          if (referral.clinicalSummary != null) ...[
            const SizedBox(height: 12),
            _Section(
              icon: Icons.description_outlined,
              label: 'Clinical Summary',
              body: referral.clinicalSummary!,
            ),
          ],
          const SizedBox(height: 12),
          _TimelineRow(referral: referral),
          if (showRouting) ...[
            const SizedBox(height: 16),
            const Text(
              'ROUTE TO SPECIALTY',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                letterSpacing: 1,
                color: AppColors.textTertiary,
              ),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final option in referral.routeOptions)
                  _RouteChip(
                    label: option,
                    isSelected: option == selectedRoute,
                    onTap: () => onRouteSelected?.call(option),
                  ),
              ],
            ),
          ],
          const SizedBox(height: 16),
          if (isPending)
            _Actions(onAccept: onAccept, onDecline: onDecline, isBusy: isBusy)
          else
            _ResolvedStrip(status: referral.status),
        ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  final Referral referral;

  const _Header({required this.referral});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: AppColors.roleDoctorTint,
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(
            Icons.favorite,
            color: AppColors.roleDoctor,
            size: 20,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Row(
            children: [
              Flexible(
                child: Text(
                  referral.specialty,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              _urgencyPill(referral.urgency),
            ],
          ),
        ),
        const SizedBox(width: 8),
        StatusPill(
          label: referral.facility,
          color: AppColors.textSecondary,
          filled: false,
          fontSize: 10.5,
        ),
      ],
    );
  }

  Widget _urgencyPill(ReferralUrgency urgency) => switch (urgency) {
    ReferralUrgency.urgent => const StatusPill(
      label: 'Urgent',
      color: AppColors.danger,
      fontSize: 10.5,
    ),
    ReferralUrgency.pending => const StatusPill(
      label: 'Pending',
      color: AppColors.warning,
      fontSize: 10.5,
    ),
    ReferralUrgency.routine => const StatusPill(
      label: 'Routine',
      color: AppColors.secondary,
      fontSize: 10.5,
    ),
  };
}

class _Section extends StatelessWidget {
  final IconData icon;
  final String label;
  final String body;

  const _Section({
    required this.icon,
    required this.label,
    required this.body,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 15, color: AppColors.textSecondary),
            const SizedBox(width: 6),
            Text(
              label,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Padding(
          padding: const EdgeInsets.only(left: 21),
          child: Text(
            body,
            style: const TextStyle(
              fontSize: 12.5,
              height: 1.45,
              color: AppColors.textSecondary,
            ),
          ),
        ),
      ],
    );
  }
}

class _TimelineRow extends StatelessWidget {
  final Referral referral;

  const _TimelineRow({required this.referral});

  @override
  Widget build(BuildContext context) {
    final color = referral.timelineIsUrgent
        ? AppColors.danger
        : AppColors.warning;
    return Row(
      children: [
        const Icon(
          Icons.schedule,
          size: 15,
          color: AppColors.textSecondary,
        ),
        const SizedBox(width: 6),
        const Text(
          'Requested Timeline',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        const Spacer(),
        Flexible(
          child: Text(
            referral.requestedTimeline,
            textAlign: TextAlign.right,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 12.5,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
        ),
      ],
    );
  }
}

class _RouteChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _RouteChip({
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
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
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

class _Actions extends StatelessWidget {
  final VoidCallback onAccept;
  final VoidCallback onDecline;
  final bool isBusy;

  const _Actions({
    required this.onAccept,
    required this.onDecline,
    required this.isBusy,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _DeclineButton(onTap: isBusy ? null : onDecline),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _AcceptButton(onTap: isBusy ? null : onAccept, isBusy: isBusy),
        ),
      ],
    );
  }
}

class _DeclineButton extends StatelessWidget {
  final VoidCallback? onTap;

  const _DeclineButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.danger.withValues(alpha: 0.08),
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          height: 46,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.danger.withValues(alpha: 0.3)),
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.close, size: 17, color: AppColors.danger),
              SizedBox(width: 6),
              Text(
                'Decline',
                style: TextStyle(
                  fontSize: 14.5,
                  fontWeight: FontWeight.w700,
                  color: AppColors.danger,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AcceptButton extends StatelessWidget {
  final VoidCallback? onTap;
  final bool isBusy;

  const _AcceptButton({required this.onTap, required this.isBusy});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: AppColors.primaryGradient),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(14),
          child: SizedBox(
            height: 46,
            child: Center(
              child: isBusy
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.4,
                        valueColor: AlwaysStoppedAnimation(Colors.white),
                      ),
                    )
                  : const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.check, size: 17, color: Colors.white),
                        SizedBox(width: 6),
                        Text(
                          'Accept',
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
      ),
    );
  }
}

class _ResolvedStrip extends StatelessWidget {
  final ReferralStatus status;

  const _ResolvedStrip({required this.status});

  @override
  Widget build(BuildContext context) {
    final accepted = status == ReferralStatus.accepted;
    final color = accepted ? AppColors.primary : AppColors.danger;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(accepted ? Icons.check_circle : Icons.cancel, size: 18,
              color: color),
          const SizedBox(width: 8),
          Text(
            accepted ? 'Accepted' : 'Declined',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
