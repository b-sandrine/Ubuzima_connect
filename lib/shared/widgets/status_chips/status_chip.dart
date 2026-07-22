import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

/// Generic status tone shared by every feature's status chip — a referral,
/// an appointment, or a sync-queue item all resolve to one of these before
/// rendering.
enum StatusTone { success, warning, danger, info, neutral }

/// Small pill used for appointment/referral/prescription/sync status
/// across every feature (e.g. "Pending", "Confirmed", "High Risk").
class StatusChip extends StatelessWidget {
  final String label;
  final StatusTone tone;

  const StatusChip({super.key, required this.label, required this.tone});

  Color get _color => switch (tone) {
    StatusTone.success => AppColors.success,
    StatusTone.warning => AppColors.warning,
    StatusTone.danger => AppColors.danger,
    StatusTone.info => AppColors.info,
    StatusTone.neutral => AppColors.border,
  };

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text(
        label,
        style: TextStyle(color: _color, fontWeight: FontWeight.w600),
      ),
      backgroundColor: _color.withValues(alpha: 0.12),
      side: BorderSide(color: _color.withValues(alpha: 0.3)),
      visualDensity: VisualDensity.compact,
    );
  }
}
