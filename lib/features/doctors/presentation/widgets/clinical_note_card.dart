import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../domain/models/clinical_note.dart';

/// One entry in Recent Clinical Notes: author + role + time, the note body,
/// and its tags, set off by a coloured accent bar.
class ClinicalNoteCard extends StatelessWidget {
  final ClinicalNote note;

  /// Cycled by list position rather than note meaning — the design varies
  /// the accent purely for visual rhythm.
  final Color accentColor;

  const ClinicalNoteCard({
    super.key,
    required this.note,
    required this.accentColor,
  });

  static const _tagPalette = [Color(0xFF7C3AED), AppColors.secondary];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border(left: BorderSide(color: accentColor, width: 3)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A0F172A),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(AppSpacing.sm + 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _Avatar(photoUrl: note.authorPhotoUrl),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      note.authorName,
                      style: const TextStyle(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    Text(
                      note.authorRole,
                      style: const TextStyle(
                        fontSize: 11.5,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                note.timeLabel,
                style: const TextStyle(
                  fontSize: 11.5,
                  color: AppColors.textTertiary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            note.note,
            style: const TextStyle(
              fontSize: 12.5,
              height: 1.45,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: [
              for (var i = 0; i < note.tags.length; i++)
                _Tag(
                  label: note.tags[i],
                  color: _tagPalette[i % _tagPalette.length],
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Avatar extends StatelessWidget {
  final String? photoUrl;

  const _Avatar({this.photoUrl});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: (photoUrl == null || photoUrl!.isEmpty)
          ? Container(
              width: 34,
              height: 34,
              color: AppColors.roleDoctorTint,
              child: const Icon(
                LucideIcons.userRound,
                size: 16,
                color: AppColors.roleDoctor,
              ),
            )
          : Image.network(
              photoUrl!,
              width: 34,
              height: 34,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                width: 34,
                height: 34,
                color: AppColors.roleDoctorTint,
                child: const Icon(
                  LucideIcons.userRound,
                  size: 16,
                  color: AppColors.roleDoctor,
                ),
              ),
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
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(AppRadius.full),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 10.5,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }
}
