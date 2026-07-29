import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/theme/app_spacing.dart';

/// The compact lavender "AI:" banner used on list/detail screens (Patient
/// Search, Patient Details) — a one-line nudge rather than the dashboard's
/// full gradient card.
class AiInsightBanner extends StatelessWidget {
  final String message;
  final String prefixLabel;
  final bool showChevron;
  final VoidCallback? onTap;

  const AiInsightBanner({
    super.key,
    required this.message,
    this.prefixLabel = 'AI: ',
    this.showChevron = true,
    this.onTap,
  });

  static const _purple = Color(0xFF7C3AED);
  static const _tint = Color(0xFFEDE9FE);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: _tint,
      borderRadius: BorderRadius.circular(AppRadius.lg),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.sm + 4),
          child: Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(AppRadius.md),
                ),
                child: const Icon(
                  LucideIcons.sparkles,
                  size: 16,
                  color: _purple,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text.rich(
                  TextSpan(
                    style: const TextStyle(
                      fontSize: 13,
                      height: 1.35,
                      color: Color(0xFF4C1D95),
                    ),
                    children: [
                      TextSpan(
                        text: prefixLabel,
                        style: const TextStyle(fontWeight: FontWeight.w800),
                      ),
                      TextSpan(text: message),
                    ],
                  ),
                ),
              ),
              if (showChevron) ...[
                const SizedBox(width: 8),
                const Icon(LucideIcons.chevronRight, size: 18, color: _purple),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
