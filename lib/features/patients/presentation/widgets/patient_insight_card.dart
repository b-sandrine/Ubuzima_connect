import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

/// The patient's read of DOC-04's "AI Timeline Analysis" — same visual
/// language (purple gradient, sparkle mark) so the app stays recognisably
/// one product, but reworded: a patient wants to know what their story
/// means and who to ask, not a clinical summary and a print button.
class PatientInsightCard extends StatelessWidget {
  final String summary;
  final String viewLabel;
  final VoidCallback? onAskChw;
  final VoidCallback? onDownload;

  const PatientInsightCard({
    super.key,
    required this.summary,
    required this.viewLabel,
    this.onAskChw,
    this.onDownload,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFF5F3FF), Color(0xFFEDE9FE)],
        ),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFDDD6FE)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: const Color(0xFF7C3AED).withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  LucideIcons.sparkles,
                  size: 18,
                  color: Color(0xFF7C3AED),
                ),
              ),
              const SizedBox(width: 10),
              const Expanded(
                child: Text(
                  'Your Health Story',
                  style: TextStyle(
                    fontSize: 14.5,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF5B21B6),
                  ),
                ),
              ),
              Text(
                viewLabel,
                style: const TextStyle(fontSize: 11, color: Color(0xFF7C6FAE)),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            summary,
            style: const TextStyle(
              fontSize: 13,
              height: 1.5,
              color: Color(0xFF4C1D95),
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Not sure what this means for you? Your community health worker '
            'can walk through it with you at your next visit.',
            style: TextStyle(
              fontSize: 12,
              height: 1.4,
              fontStyle: FontStyle.italic,
              color: Color(0xFF6D28D9),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _Action(
                  icon: LucideIcons.messageCircleQuestion,
                  label: 'Ask My CHW',
                  filled: true,
                  onTap: onAskChw,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _Action(
                  icon: LucideIcons.download,
                  label: 'Download PDF',
                  filled: false,
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

class _Action extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool filled;
  final VoidCallback? onTap;

  const _Action({
    required this.icon,
    required this.label,
    required this.filled,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    const purple = Color(0xFF7C3AED);
    return Material(
      color: filled ? purple : Colors.white,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap ?? () {},
        borderRadius: BorderRadius.circular(12),
        child: Container(
          height: 44,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: filled ? purple : const Color(0xFFDDD6FE),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, size: 16, color: filled ? Colors.white : purple),
                const SizedBox(width: 6),
                Flexible(
                  child: Text(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w700,
                      color: filled ? Colors.white : purple,
                    ),
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
