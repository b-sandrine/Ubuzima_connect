import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/pills/status_pill.dart';
import '../../domain/entities/referral.dart';

/// The icon and colour the design gives each clinical specialty — reused by
/// both the card header glyph and the routing chips.
({IconData icon, Color color}) _specialtyStyle(String specialty) {
  final key = specialty.toLowerCase();
  if (key.contains('cardio')) {
    return (icon: LucideIcons.heart, color: Color(0xFF3B82F6));
  }
  if (key.contains('neuro')) {
    return (icon: LucideIcons.brain, color: Color(0xFF8B5CF6));
  }
  if (key.contains('nephro')) {
    return (icon: LucideIcons.droplet, color: Color(0xFF10B981));
  }
  if (key.contains('ophthal')) {
    return (icon: LucideIcons.eye, color: Color(0xFFEA580C));
  }
  if (key.contains('endocrin')) {
    return (icon: LucideIcons.activity, color: Color(0xFF0EA5E9));
  }
  return (icon: LucideIcons.stethoscope, color: AppColors.secondary);
}

/// The colour a referral's urgency tints its header tile with.
Color _urgencyColor(ReferralUrgency urgency) => switch (urgency) {
  ReferralUrgency.urgent => AppColors.danger,
  ReferralUrgency.pending => AppColors.warning,
  ReferralUrgency.routine => AppColors.secondary,
};

/// The colour a card's border is tinted with: the urgency colour while
/// pending, or the resolution colour once accepted/declined — matching the
/// colour each card is already making most prominent (the urgency pill, or
/// the resolved strip).
Color _cardBorderColor(Referral referral) => switch (referral.status) {
  ReferralStatus.pending => _urgencyColor(referral.urgency),
  ReferralStatus.accepted => AppColors.primary,
  ReferralStatus.declined => AppColors.danger,
};

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
  final VoidCallback onWithdraw;
  final bool isBusy;

  const ReferralCard({
    super.key,
    required this.referral,
    required this.onAccept,
    required this.onDecline,
    required this.onWithdraw,
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
        border: Border.all(
          color: _cardBorderColor(referral).withValues(alpha: 0.2),
        ),
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
            icon: LucideIcons.userRound,
            label: 'Referring Physician',
            body:
                '${referral.referringPhysician} · ${referral.referringFacility}',
          ),
          const SizedBox(height: 12),
          _Section(
            icon: LucideIcons.info,
            label: 'Reason for Referral',
            body: referral.reason,
          ),
          if (referral.clinicalSummary != null) ...[
            const SizedBox(height: 12),
            _Section(
              icon: LucideIcons.fileText,
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
                    style: _specialtyStyle(option),
                    isSelected: option == selectedRoute,
                    onTap: () => onRouteSelected?.call(option),
                  ),
              ],
            ),
          ],
          const SizedBox(height: 16),
          if (isPending && referral.direction == ReferralDirection.incoming)
            _Actions(onAccept: onAccept, onDecline: onDecline, isBusy: isBusy)
          else if (isPending)
            // Outgoing/follow-up referrals you sent can be withdrawn (delete).
            _WithdrawButton(onTap: isBusy ? null : onWithdraw)
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
    final urgencyColor = _urgencyColor(referral.urgency);
    final specialtyIcon = _specialtyStyle(referral.specialty).icon;

    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: urgencyColor.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(specialtyIcon, color: urgencyColor, size: 20),
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

  const _Section({required this.icon, required this.label, required this.body});

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
        const Icon(LucideIcons.clock, size: 15, color: AppColors.textSecondary),
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
  final ({IconData icon, Color color}) style;
  final bool isSelected;
  final VoidCallback onTap;

  const _RouteChip({
    required this.label,
    required this.style,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // Each specialty keeps its own hue: a soft tint when offered, the full
    // colour once chosen.
    final background = isSelected
        ? style.color
        : style.color.withValues(alpha: 0.1);
    final foreground = isSelected ? Colors.white : style.color;

    return Material(
      color: background,
      borderRadius: BorderRadius.circular(999),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(999),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(999),
            border: Border.all(
              color: isSelected
                  ? style.color
                  : style.color.withValues(alpha: 0.25),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(style.icon, size: 14, color: foreground),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w600,
                  color: foreground,
                ),
              ),
            ],
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
        Expanded(child: _DeclineButton(onTap: isBusy ? null : onDecline)),
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
              Icon(LucideIcons.x, size: 17, color: AppColors.danger),
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
                        Icon(LucideIcons.check, size: 17, color: Colors.white),
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

class _WithdrawButton extends StatelessWidget {
  final VoidCallback? onTap;

  const _WithdrawButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.danger.withValues(alpha: 0.06),
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          height: 46,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.danger.withValues(alpha: 0.25)),
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(LucideIcons.trash2, size: 16, color: AppColors.danger),
              SizedBox(width: 6),
              Text(
                'Withdraw Referral',
                style: TextStyle(
                  fontSize: 14,
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
          Icon(
            accepted ? LucideIcons.circleCheck : LucideIcons.circleX,
            size: 18,
            color: color,
          ),
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
