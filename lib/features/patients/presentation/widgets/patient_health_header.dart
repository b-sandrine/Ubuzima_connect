import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../medical_records/domain/entities/patient_timeline.dart';

/// The greeting hero at the top of PAT-02b — the patient's own, friendlier
/// read of the same [TimelinePatient] DOC-04 shows a doctor. Clinical
/// severity language ("Critical") is deliberately softened here: a patient
/// opening their own record should feel informed and supported, not
/// alarmed, so the raw criticality is translated into a calmer status and a
/// short, reassuring next step instead of a blunt red badge.
class PatientHealthHeader extends StatelessWidget {
  final TimelinePatient patient;
  final VoidCallback? onShare;
  final VoidCallback? onDownload;

  const PatientHealthHeader({
    super.key,
    required this.patient,
    this.onShare,
    this.onDownload,
  });

  @override
  Widget build(BuildContext context) {
    final status = _PatientWellnessStatus.from(patient.criticality);
    final firstName = patient.name.split(' ').first;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: AppColors.primaryGradient,
        ),
        borderRadius: BorderRadius.circular(22),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1A059669),
            blurRadius: 18,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.22),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.5),
                  ),
                ),
                child: const Icon(
                  LucideIcons.userRound,
                  color: Colors.white,
                  size: 26,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Hello, $firstName',
                      style: const TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Your care team has walked with you for '
                      '${patient.careHistory}',
                      style: TextStyle(
                        fontSize: 12.5,
                        color: Colors.white.withValues(alpha: 0.92),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.16),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: Colors.white.withValues(alpha: 0.3)),
            ),
            child: Row(
              children: [
                Icon(status.icon, size: 17, color: Colors.white),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    status.message,
                    style: const TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                      height: 1.3,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: _HeaderAction(
                  icon: LucideIcons.share2,
                  label: 'Share with Provider',
                  onTap: onShare,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _HeaderAction(
                  icon: LucideIcons.download,
                  label: 'Download PDF',
                  onTap: onDownload,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _HeaderAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;

  const _HeaderAction({required this.icon, required this.label, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white.withValues(alpha: 0.18),
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap ?? () {},
        borderRadius: BorderRadius.circular(12),
        child: Container(
          height: 42,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.white.withValues(alpha: 0.4)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 15, color: Colors.white),
              const SizedBox(width: 7),
              Flexible(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Translates a clinician-facing criticality label into a patient-facing
/// tone and next step. Unrecognised values fall back to a neutral read
/// rather than guessing at severity.
class _PatientWellnessStatus {
  final IconData icon;
  final String message;

  const _PatientWellnessStatus({required this.icon, required this.message});

  factory _PatientWellnessStatus.from(String criticality) {
    switch (criticality.toLowerCase()) {
      case 'critical':
        return const _PatientWellnessStatus(
          icon: LucideIcons.heartPulse,
          message:
              'Your care team is watching your health closely right now. '
              'Keep your upcoming appointments — they matter.',
        );
      case 'moderate':
        return const _PatientWellnessStatus(
          icon: LucideIcons.activity,
          message:
              'A few things are being monitored. Your next visit will help '
              'keep things on track.',
        );
      case 'stable':
      case 'low':
        return const _PatientWellnessStatus(
          icon: LucideIcons.circleCheck,
          message: 'Things are looking stable. Keep up your routine care.',
        );
      default:
        return _PatientWellnessStatus(
          icon: LucideIcons.info,
          message: 'Here is your complete health record, all in one place.',
        );
    }
  }
}
