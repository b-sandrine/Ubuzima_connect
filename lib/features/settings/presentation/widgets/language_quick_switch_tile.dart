import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/localization/locale_cubit.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';

/// The Language row inside "Appearance & Accessibility" — unlike the other
/// rows this isn't a toggle or a nav chevron, it's an inline EN/RW/FR quick
/// switcher. It reads/writes [LocaleCubit] directly (the same cubit that
/// backs the full Language Settings page) so picking a language here and
/// on that page can never disagree.
class LanguageQuickSwitchTile extends StatelessWidget {
  const LanguageQuickSwitchTile({super.key});

  static const _languages = [
    (code: 'rw', label: 'Kinyarwanda'),
    (code: 'en', label: 'English'),
    (code: 'fr', label: 'Français'),
  ];

  @override
  Widget build(BuildContext context) {
    final selectedCode = context.select<LocaleCubit, String?>(
      (cubit) => cubit.state?.languageCode,
    );

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm + 4,
        vertical: AppSpacing.sm + 4,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: AppColors.warning.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(AppRadius.md + 2),
                ),
                child: const Icon(
                  LucideIcons.languages,
                  size: 18,
                  color: AppColors.warning,
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Language',
                      style: TextStyle(
                        fontSize: 14.5,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'App display language',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final language in _languages)
                _LanguagePill(
                  label: language.label,
                  isSelected: selectedCode == language.code,
                  onTap: () => context.read<LocaleCubit>().setLocale(
                    Locale(language.code),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _LanguagePill extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _LanguagePill({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: isSelected ? AppColors.primary : Colors.white,
      borderRadius: BorderRadius.circular(AppRadius.full),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.full),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppRadius.full),
            border: Border.all(
              color: isSelected ? AppColors.primary : AppColors.border,
            ),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12.5,
              fontWeight: FontWeight.w700,
              color: isSelected ? Colors.white : AppColors.textSecondary,
            ),
          ),
        ),
      ),
    );
  }
}
