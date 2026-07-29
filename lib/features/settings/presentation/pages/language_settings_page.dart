import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/localization/locale_cubit.dart';
import '../../../../core/localization/locale_extensions.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/backgrounds/app_gradient_background.dart';
import '../../../../shared/widgets/navigation/app_top_bar.dart';
import '../../../../shared/widgets/navigation/ubuzima_bottom_nav.dart';
import '../widgets/language_option_card.dart';

/// SETTINGS-01 — lets the user pick English, Kinyarwanda, or Français, or
/// fall back to following the device's language.
///
/// This screen carries no business logic of its own: [LocaleCubit] already
/// is the domain+data layer for locale selection (it lives in
/// `core/localization/` because the choice affects the whole app, not just
/// Settings) and it's provided once above `MaterialApp` in `app.dart`, so
/// this page only needs to read its state and call `setLocale`/`clear`.
class LanguageSettingsPage extends StatelessWidget {
  const LanguageSettingsPage({super.key});

  static const _languages = [
    (code: 'en', name: 'English', badge: 'EN', accent: AppColors.secondary),
    (
      code: 'rw',
      name: 'Kinyarwanda',
      badge: 'RW',
      accent: AppColors.primary,
    ),
    (code: 'fr', name: 'Français', badge: 'FR', accent: Color(0xFFEA580C)),
  ];

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Scaffold(
      backgroundColor: Colors.transparent,
      bottomNavigationBar: const UbuzimaBottomNav(
        currentIndex: 4,
        items: [
          BottomNavItem(icon: LucideIcons.house, label: 'Home'),
          BottomNavItem(icon: LucideIcons.folder, label: 'Records'),
          BottomNavItem(icon: LucideIcons.brain, label: 'AI Insights'),
          BottomNavItem(icon: LucideIcons.bell, label: 'Alerts', showDot: true),
          BottomNavItem(icon: LucideIcons.settings, label: 'Settings'),
        ],
      ),
      body: AppGradientBackground(
        child: SafeArea(
          child: BlocConsumer<LocaleCubit, Locale?>(
            listener: (context, locale) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(l10n.languageUpdatedMessage)),
              );
            },
            builder: (context, selectedLocale) {
              final cubit = context.read<LocaleCubit>();

              return ListView(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
                children: [
                  AppTopBar(
                    onBack: () => Navigator.of(context).maybePop(),
                    contextLabel: l10n.languageSettingsTitle.toUpperCase(),
                    contextColor: AppColors.primary,
                    contextIcon: LucideIcons.languages,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    l10n.chooseLanguageHeading,
                    style: const TextStyle(
                      fontSize: 21,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    l10n.chooseLanguageSubtitle,
                    style: const TextStyle(
                      fontSize: 13,
                      height: 1.4,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 20),
                  for (final lang in _languages) ...[
                    LanguageOptionCard(
                      code: lang.code,
                      nativeName: lang.name,
                      badge: lang.badge,
                      accent: lang.accent,
                      isSelected: selectedLocale?.languageCode == lang.code,
                      selectedLabel: l10n.selectedLabel,
                      onTap: () => cubit.setLocale(Locale(lang.code)),
                    ),
                    const SizedBox(height: 10),
                  ],
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 4,
                      vertical: 4,
                    ),
                    child: Row(
                      children: const [
                        Expanded(child: Divider(color: AppColors.border)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Material(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    child: InkWell(
                      onTap: cubit.clear,
                      borderRadius: BorderRadius.circular(16),
                      child: Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: selectedLocale == null
                                ? AppColors.primary
                                : AppColors.border,
                            width: selectedLocale == null ? 1.6 : 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 44,
                              height: 44,
                              decoration: BoxDecoration(
                                color: AppColors.textTertiary.withValues(
                                  alpha: 0.14,
                                ),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              alignment: Alignment.center,
                              child: const Icon(
                                LucideIcons.smartphone,
                                size: 20,
                                color: AppColors.textSecondary,
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    l10n.useDeviceLanguage,
                                    style: const TextStyle(
                                      fontSize: 15.5,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    l10n.useDeviceLanguageSubtitle,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            if (selectedLocale == null)
                              Container(
                                width: 26,
                                height: 26,
                                decoration: const BoxDecoration(
                                  color: AppColors.primary,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  LucideIcons.check,
                                  size: 15,
                                  color: Colors.white,
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
