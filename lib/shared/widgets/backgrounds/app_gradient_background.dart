import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

/// The soft mint-to-white wash that sits behind the onboarding and
/// dashboard screens in the design.
///
/// Only applied in light mode — in dark mode the wash would fight the dark
/// surfaces, so the scaffold colour is left to show through instead.
class AppGradientBackground extends StatelessWidget {
  final Widget child;

  const AppGradientBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    if (isDark) return child;

    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: AppColors.backgroundGradient,
          stops: [0.0, 0.45, 1.0],
        ),
      ),
      child: child,
    );
  }
}
