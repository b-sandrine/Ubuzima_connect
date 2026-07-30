import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/patient_intake_draft.dart';
import 'intake_inputs.dart';

/// Step 2 — Location Details: a free-text address plus a mock GPS capture
/// (no device geolocation call — this flags the record as located, the way
/// the design's "Capture Location" action reads).
class LocationDetailsSection extends StatelessWidget {
  final PatientIntakeDraft draft;
  final ValueChanged<PatientIntakeDraft> onChanged;

  const LocationDetailsSection({
    super.key,
    required this.draft,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return IntakeSectionCard(
      icon: LucideIcons.mapPin,
      title: 'Location Details',
      tint: AppColors.warning.withValues(alpha: 0.14),
      iconColor: AppColors.warning,
      children: [
        IntakeTextField(
          label: 'Street / Address',
          hint: 'e.g. KG 15 Ave, House 7B',
          value: draft.streetAddress,
          onChanged: (v) => onChanged(draft.copyWith(streetAddress: v)),
        ),
        IntakeTextField(
          label: 'Nearest Landmark',
          hint: 'e.g. Near Kimironko Market',
          value: draft.nearestLandmark,
          onChanged: (v) => onChanged(draft.copyWith(nearestLandmark: v)),
        ),
        const IntakeFieldLabel('GPS Coordinates'),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 14),
          decoration: BoxDecoration(
            color: AppColors.warning.withValues(alpha: 0.06),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.warning.withValues(alpha: 0.25)),
          ),
          child: Column(
            children: [
              Icon(
                draft.gpsCaptured ? LucideIcons.mapPinCheck : LucideIcons.radio,
                color: AppColors.warning,
                size: 26,
              ),
              const SizedBox(height: 8),
              Text(
                draft.gpsCaptured
                    ? 'Location captured'
                    : 'Capture GPS Location',
                style: const TextStyle(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                draft.gpsCaptured
                    ? 'Coordinates saved with this record'
                    : "Tap to record patient's home coordinates",
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 11.5,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 14),
              Material(
                color: draft.gpsCaptured
                    ? AppColors.primary
                    : AppColors.warning,
                borderRadius: BorderRadius.circular(999),
                child: InkWell(
                  onTap: draft.gpsCaptured
                      ? null
                      : () => onChanged(draft.copyWith(gpsCaptured: true)),
                  borderRadius: BorderRadius.circular(999),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          draft.gpsCaptured
                              ? LucideIcons.check
                              : LucideIcons.locateFixed,
                          size: 16,
                          color: Colors.white,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          draft.gpsCaptured ? 'Captured' : 'Capture Location',
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 4),
      ],
    );
  }
}
