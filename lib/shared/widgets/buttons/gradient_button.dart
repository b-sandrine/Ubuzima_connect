import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

/// The full-width green pill used for the primary action on every screen in
/// the design (Sign In, Accept, New Visit).
///
/// Disabled state desaturates to a flat grey rather than a faded gradient,
/// which reads as "not available" instead of "still loading".
class GradientButton extends StatelessWidget {
  final String label;
  final IconData? icon;
  final VoidCallback? onPressed;
  final bool isLoading;

  const GradientButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final isEnabled = onPressed != null && !isLoading;

    return Semantics(
      button: true,
      enabled: isEnabled,
      label: label,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: isEnabled
              ? const LinearGradient(colors: AppColors.primaryGradient)
              : null,
          color: isEnabled ? null : const Color(0xFFCBD5E1),
          borderRadius: BorderRadius.circular(16),
          boxShadow: isEnabled
              ? const [
                  BoxShadow(
                    color: Color(0x3316A34A),
                    blurRadius: 16,
                    offset: Offset(0, 6),
                  ),
                ]
              : null,
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: isEnabled ? onPressed : null,
            borderRadius: BorderRadius.circular(16),
            child: SizedBox(
              height: 56,
              width: double.infinity,
              child: Center(
                child: isLoading
                    ? const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.5,
                          valueColor: AlwaysStoppedAnimation(Colors.white),
                        ),
                      )
                    : Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (icon != null) ...[
                            Icon(icon, size: 20, color: Colors.white),
                            const SizedBox(width: 10),
                          ],
                          Text(
                            label,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// The white counterpart sitting directly under [GradientButton] — same
/// footprint, secondary weight (Create Account, Decline).
class OutlinedPillButton extends StatelessWidget {
  final String label;
  final IconData? icon;
  final VoidCallback? onPressed;
  final Color? foreground;

  const OutlinedPillButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.foreground,
  });

  @override
  Widget build(BuildContext context) {
    final color = foreground ?? AppColors.textPrimary;

    return Semantics(
      button: true,
      enabled: onPressed != null,
      label: label,
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            height: 56,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.border),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x0A0F172A),
                  blurRadius: 8,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (icon != null) ...[
                    Icon(icon, size: 20, color: color),
                    const SizedBox(width: 10),
                  ],
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: color,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
