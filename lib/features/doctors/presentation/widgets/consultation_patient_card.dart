import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../domain/models/patient_record.dart';
import 'dashboard_style.dart';

/// Shortens a condition tag to the abbreviation the design uses in the
/// Consultation header ("Hypertension" → "HTN").
abstract final class _ConditionAbbreviation {
  static const Map<String, String> _map = {
    'Hypertension': 'HTN',
    'Diabetes': 'T2DM',
    'CKD': 'CKD',
  };

  static String of(String tag) => _map[tag] ?? tag;
}

/// The patient-identity card at the top of the Consultation screen: avatar
/// with a status-colour ring, name + status pill, the ID/demographics/
/// condition line, and today's date.
class ConsultationPatientCard extends StatelessWidget {
  final PatientRecord patient;
  final String dateLabel;

  const ConsultationPatientCard({
    super.key,
    required this.patient,
    required this.dateLabel,
  });

  @override
  Widget build(BuildContext context) {
    final statusColor = DashboardStyle.patientRecordStatusColor(patient.status);
    final statusLabel = DashboardStyle.patientRecordStatusLabel(patient.status);
    final conditions = patient.tags.map(_ConditionAbbreviation.of).join(' + ');

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: statusColor.withValues(alpha: 0.2)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _Avatar(photoUrl: patient.photoUrl, statusColor: statusColor),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        patient.name,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 9,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: statusColor.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(AppRadius.full),
                      ),
                      child: Text(
                        statusLabel,
                        style: TextStyle(
                          fontSize: 10.5,
                          fontWeight: FontWeight.w700,
                          color: statusColor,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  'ID: ${patient.patientCode} · ${patient.gender}${patient.age}yrs'
                  '${conditions.isEmpty ? '' : ' · $conditions'}',
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Text(
            dateLabel,
            textAlign: TextAlign.right,
            style: const TextStyle(fontSize: 11.5, color: AppColors.textTertiary),
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
      width: 46,
      height: 46,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: (photoUrl == null || photoUrl!.isEmpty)
                ? Container(
                    width: 46,
                    height: 46,
                    color: AppColors.rolePatientTint,
                    child: const Icon(
                      LucideIcons.userRound,
                      size: 20,
                      color: AppColors.rolePatient,
                    ),
                  )
                : Image.network(
                    photoUrl!,
                    width: 46,
                    height: 46,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      width: 46,
                      height: 46,
                      color: AppColors.rolePatientTint,
                      child: const Icon(
                        LucideIcons.userRound,
                        size: 20,
                        color: AppColors.rolePatient,
                      ),
                    ),
                  ),
          ),
          Positioned(
            right: -2,
            bottom: -2,
            child: Container(
              width: 14,
              height: 14,
              decoration: BoxDecoration(
                color: statusColor,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
