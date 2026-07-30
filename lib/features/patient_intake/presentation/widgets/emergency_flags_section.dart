import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/patient_intake_draft.dart';
import 'intake_inputs.dart';

/// Human-readable copy for each [EmergencyFlag] toggle.
abstract final class EmergencyFlagCopy {
  static const Map<EmergencyFlag, (String, String, IconData)> entries = {
    EmergencyFlag.unconscious: (
      'Unconscious / Unresponsive',
      'Patient cannot respond to stimuli',
      LucideIcons.bedDouble,
    ),
    EmergencyFlag.severeBreathingDifficulty: (
      'Severe Breathing Difficulty',
      'Cannot breathe normally or speak',
      LucideIcons.wind,
    ),
    EmergencyFlag.severeBleeding: (
      'Severe / Uncontrolled Bleeding',
      'Active uncontrolled hemorrhage',
      LucideIcons.droplets,
    ),
    EmergencyFlag.highFever: (
      'High Fever (>40°C)',
      'Dangerously elevated body temperature',
      LucideIcons.thermometer,
    ),
    EmergencyFlag.convulsions: (
      'Convulsions / Seizures',
      'Uncontrolled muscle spasms or fits',
      LucideIcons.zap,
    ),
    EmergencyFlag.pregnancyEmergency: (
      'Pregnancy Emergency',
      'Danger signs in pregnant patient',
      LucideIcons.baby,
    ),
  };
}

/// Step 3 — Emergency Flags: critical conditions the CHW can raise manually,
/// independent of the auto-analyzed AI risk score above. Any active flag
/// prioritizes the patient in the emergency alert queue.
class EmergencyFlagsSection extends StatelessWidget {
  final PatientIntakeDraft draft;
  final ValueChanged<PatientIntakeDraft> onChanged;

  const EmergencyFlagsSection({
    super.key,
    required this.draft,
    required this.onChanged,
  });

  void _toggle(EmergencyFlag flag, bool active) {
    final next = {...draft.emergencyFlags};
    if (active) {
      next.add(flag);
    } else {
      next.remove(flag);
    }
    onChanged(draft.copyWith(emergencyFlags: next));
  }

  @override
  Widget build(BuildContext context) {
    return IntakeSectionCard(
      icon: LucideIcons.triangleAlert,
      title: 'Emergency Flags',
      tint: AppColors.danger.withValues(alpha: 0.12),
      iconColor: AppColors.danger,
      trailing: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: AppColors.danger.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(999),
        ),
        child: const Text(
          'Critical',
          style: TextStyle(
            fontSize: 10.5,
            fontWeight: FontWeight.w700,
            color: AppColors.danger,
          ),
        ),
      ),
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          margin: const EdgeInsets.only(bottom: 6),
          decoration: BoxDecoration(
            color: AppColors.danger.withValues(alpha: 0.06),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Text(
            'Flag any condition requiring immediate referral or emergency '
            'response. Flagged patients are prioritized in the alert system.',
            style: TextStyle(
              fontSize: 11.5,
              height: 1.4,
              color: AppColors.textSecondary,
            ),
          ),
        ),
        for (final flag in EmergencyFlag.values)
          IntakeSwitchTile(
            icon: EmergencyFlagCopy.entries[flag]!.$3,
            title: EmergencyFlagCopy.entries[flag]!.$1,
            subtitle: EmergencyFlagCopy.entries[flag]!.$2,
            value: draft.emergencyFlags.contains(flag),
            onChanged: (v) => _toggle(flag, v),
          ),
        if (draft.emergencyFlags.isNotEmpty) ...[
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.danger.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.danger.withValues(alpha: 0.3)),
            ),
            child: Row(
              children: [
                const Icon(
                  LucideIcons.triangleAlert,
                  size: 16,
                  color: AppColors.danger,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${draft.emergencyFlags.length} Emergency '
                        '${draft.emergencyFlags.length == 1 ? 'Flag' : 'Flags'} Active',
                        style: const TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w800,
                          color: AppColors.danger,
                        ),
                      ),
                      const Text(
                        'This patient will be prioritized in the Emergency '
                        'Alerts queue.',
                        style: TextStyle(
                          fontSize: 11.5,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}
