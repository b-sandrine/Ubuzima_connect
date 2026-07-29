import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../domain/models/patient_detail.dart';
import 'dashboard_style.dart';

/// The identity card at the top of Patient Details: avatar, name + status,
/// ID/demographics, ward/hospital, condition tags, and the primary action
/// row (Consult / History / Refer / Lab).
class PatientDetailHeader extends StatelessWidget {
  final PatientDetail patient;
  final VoidCallback? onConsult;
  final VoidCallback? onHistory;
  final VoidCallback? onRefer;
  final VoidCallback? onLab;

  const PatientDetailHeader({
    super.key,
    required this.patient,
    this.onConsult,
    this.onHistory,
    this.onRefer,
    this.onLab,
  });

  static const _tagPalette = [
    AppColors.warning,
    AppColors.secondary,
    Color(0xFF7C3AED),
  ];

  @override
  Widget build(BuildContext context) {
    final statusColor = DashboardStyle.patientRecordStatusColor(patient.status);
    final statusLabel = DashboardStyle.patientRecordStatusLabel(patient.status);

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: statusColor.withValues(alpha: 0.04),
        borderRadius: BorderRadius.circular(AppRadius.lg + 4),
        border: Border.all(color: statusColor.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _Avatar(photoUrl: patient.photoUrl, statusColor: statusColor),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            patient.name,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color: statusColor.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(AppRadius.full),
                          ),
                          child: Text(
                            statusLabel,
                            style: TextStyle(
                              fontSize: 11.5,
                              fontWeight: FontWeight.w700,
                              color: statusColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'ID: ${patient.patientCode} · ${patient.gender} · '
                      '${patient.age} yrs · DOB: ${patient.dateOfBirth}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${patient.location} · ${patient.hospital}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: [
              for (var i = 0; i < patient.tags.length; i++)
                _Tag(
                  label: patient.tags[i],
                  color: _tagPalette[i % _tagPalette.length],
                ),
            ],
          ),
          const SizedBox(height: 14),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _PrimaryAction(
                  icon: LucideIcons.stethoscope,
                  label: 'Consult',
                  onTap: onConsult,
                ),
                const SizedBox(width: 8),
                _SecondaryAction(
                  icon: LucideIcons.history,
                  label: 'History',
                  color: AppColors.secondary,
                  onTap: onHistory,
                ),
                const SizedBox(width: 8),
                _SecondaryAction(
                  icon: LucideIcons.share2,
                  label: 'Refer',
                  color: AppColors.warning,
                  onTap: onRefer,
                ),
                const SizedBox(width: 8),
                _IconOnlyAction(
                  icon: LucideIcons.flaskConical,
                  color: const Color(0xFF7C3AED),
                  onTap: onLab,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Avatar extends StatelessWidget {
  final String? photoUrl;
  final Color statusColor;

  const _Avatar({required this.photoUrl, required this.statusColor});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 64,
      height: 64,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(18),
            child: (photoUrl == null || photoUrl!.isEmpty)
                ? Container(
                    width: 64,
                    height: 64,
                    color: AppColors.rolePatientTint,
                    child: const Icon(
                      LucideIcons.userRound,
                      size: 26,
                      color: AppColors.rolePatient,
                    ),
                  )
                : Image.network(
                    photoUrl!,
                    width: 64,
                    height: 64,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      width: 64,
                      height: 64,
                      color: AppColors.rolePatientTint,
                      child: const Icon(
                        LucideIcons.userRound,
                        size: 26,
                        color: AppColors.rolePatient,
                      ),
                    ),
                  ),
          ),
          Positioned(
            left: -6,
            bottom: -6,
            child: Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: statusColor,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
              ),
              child: const Icon(
                LucideIcons.target,
                size: 12,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Tag extends StatelessWidget {
  final String label;
  final Color color;

  const _Tag({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(AppRadius.full),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11.5,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }
}

class _PrimaryAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;

  const _PrimaryAction({required this.icon, required this.label, this.onTap});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: AppColors.primaryGradient),
        borderRadius: BorderRadius.circular(AppRadius.md + 2),
        boxShadow: const [
          BoxShadow(
            color: Color(0x3310B981),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppRadius.md + 2),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, size: 16, color: Colors.white),
                const SizedBox(width: 6),
                Text(
                  label,
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
    );
  }
}

class _SecondaryAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback? onTap;

  const _SecondaryAction({
    required this.icon,
    required this.label,
    required this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color.withValues(alpha: 0.1),
      borderRadius: BorderRadius.circular(AppRadius.md + 2),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.md + 2),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 16, color: color),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _IconOnlyAction extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback? onTap;

  const _IconOnlyAction({required this.icon, required this.color, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color.withValues(alpha: 0.1),
      shape: const CircleBorder(),
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Icon(icon, size: 16, color: color),
        ),
      ),
    );
  }
}
