import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

class OnboardingSlideData {
  final IconData icon;
  final String title;
  final String body;
  final Color accent;

  const OnboardingSlideData({
    required this.icon,
    required this.title,
    required this.body,
    required this.accent,
  });
}

class OnboardingSlideView extends StatelessWidget {
  final OnboardingSlideData data;

  const OnboardingSlideView({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 132,
            height: 132,
            decoration: BoxDecoration(
              color: data.accent.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Container(
              width: 88,
              height: 88,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [data.accent, data.accent.withValues(alpha: 0.75)],
                ),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: data.accent.withValues(alpha: 0.35),
                    blurRadius: 24,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Icon(data.icon, color: Colors.white, size: 40),
            ),
          ),
          const SizedBox(height: 40),
          Text(
            data.title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
              height: 1.25,
            ),
          ),
          const SizedBox(height: 14),
          Text(
            data.body,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 14.5,
              height: 1.55,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
