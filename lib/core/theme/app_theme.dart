import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_spacing.dart';
import 'app_text_styles.dart';

/// Material 3 light/dark themes. Every feature screen should read colors
/// and text styles from `Theme.of(context)` (or the `context.theme` /
/// `context.colors` extensions) — never hardcode an `AppColors` value
/// directly in a widget.
abstract final class AppTheme {
  static ThemeData get light {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      brightness: Brightness.light,
      primary: AppColors.primary,
      secondary: AppColors.secondary,
      error: AppColors.danger,
      surface: AppColors.lightSurface,
    );

    return _base(colorScheme, AppColors.lightBackground);
  }

  static ThemeData get dark {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: AppColors.primaryLight,
      brightness: Brightness.dark,
      primary: AppColors.primaryLight,
      secondary: AppColors.secondary,
      error: AppColors.danger,
      surface: AppColors.darkSurface,
    );

    return _base(colorScheme, AppColors.darkBackground);
  }

  /// High-contrast counterpart to [light] — same seed colors, pushed to
  /// Material 3's maximum `contrastLevel` so text/surface pairs meet a
  /// higher contrast ratio, plus a visible card border since elevation
  /// alone reads poorly for low-vision users.
  static ThemeData get highContrastLight {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      brightness: Brightness.light,
      primary: AppColors.primary,
      secondary: AppColors.secondary,
      error: AppColors.danger,
      surface: AppColors.lightSurface,
      contrastLevel: 1.0,
    );

    return _base(
      colorScheme,
      AppColors.lightBackground,
      highContrast: true,
    );
  }

  /// High-contrast counterpart to [dark].
  static ThemeData get highContrastDark {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: AppColors.primaryLight,
      brightness: Brightness.dark,
      primary: AppColors.primaryLight,
      secondary: AppColors.secondary,
      error: AppColors.danger,
      surface: AppColors.darkSurface,
      contrastLevel: 1.0,
    );

    return _base(
      colorScheme,
      AppColors.darkBackground,
      highContrast: true,
    );
  }

  static ThemeData _base(
    ColorScheme colorScheme,
    Color scaffoldBackground, {
    bool highContrast = false,
  }) {
    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: scaffoldBackground,
      // Inter is the design file's typeface; bundled in assets/fonts so the
      // app matches the mockups offline.
      fontFamily: 'Inter',
      textTheme: AppTextStyles.textTheme.apply(
        bodyColor: colorScheme.onSurface,
        displayColor: colorScheme.onSurface,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        elevation: 0,
        centerTitle: false,
      ),
      cardTheme: CardThemeData(
        color: colorScheme.surface,
        elevation: highContrast ? 0 : 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          side: highContrast
              ? BorderSide(color: colorScheme.outline, width: 1.5)
              : BorderSide.none,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.sm,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.md),
          ),
        ),
      ),
      chipTheme: ChipThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.full),
        ),
      ),
    );
  }
}
