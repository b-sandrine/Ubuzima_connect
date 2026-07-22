import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/localization/locale_cubit.dart';
import '../../../core/theme/app_colors.dart';

/// The EN / RW / FR pill in the top-right of the onboarding screens.
///
/// Switching here rebuilds the whole app through [LocaleCubit] rather than
/// just this screen, so the choice a user makes before signing in still
/// holds once they are inside the app.
class LanguageSwitcher extends StatelessWidget {
  const LanguageSwitcher({super.key});

  static const List<({String code, String label})> _languages = [
    (code: 'en', label: 'EN'),
    (code: 'rw', label: 'RW'),
    (code: 'fr', label: 'FR'),
  ];

  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<LocaleCubit>();
    final active =
        cubit.state?.languageCode ?? Localizations.localeOf(context).languageCode;

    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: AppColors.border),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0F0F172A),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (final language in _languages)
            _LanguagePill(
              label: language.label,
              isActive: language.code == active,
              onTap: () => cubit.setLocale(Locale(language.code)),
            ),
        ],
      ),
    );
  }
}

class _LanguagePill extends StatelessWidget {
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _LanguagePill({
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: isActive,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(999),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
          decoration: BoxDecoration(
            color: isActive ? AppColors.roleChwTint : Colors.transparent,
            borderRadius: BorderRadius.circular(999),
            border: Border.all(
              color: isActive ? AppColors.primary : Colors.transparent,
            ),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: isActive ? AppColors.primary : AppColors.textSecondary,
            ),
          ),
        ),
      ),
    );
  }
}
