import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

/// The Ubuzima logo lockup: a rounded white tile holding the water-drop
/// mark, the wordmark, and the "RWANDA HEALTH" kicker underneath.
///
/// [compact] drops the kicker and shrinks the mark for the in-app headers,
/// which show the same lockup at roughly half height.
class UbuzimaWordmark extends StatelessWidget {
  final bool compact;

  const UbuzimaWordmark({super.key, this.compact = false});

  @override
  Widget build(BuildContext context) {
    final markSize = compact ? 28.0 : 44.0;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: markSize,
          height: markSize,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(markSize / 3),
            boxShadow: const [
              BoxShadow(
                color: Color(0x1A16A34A),
                blurRadius: 12,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Icon(
            Icons.water_drop,
            size: markSize * 0.5,
            color: AppColors.primary,
          ),
        ),
        SizedBox(width: compact ? 8 : 12),
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Ubuzima',
              style: TextStyle(
                fontSize: compact ? 18 : 24,
                fontWeight: FontWeight.w700,
                color: AppColors.primary,
                height: 1.1,
              ),
            ),
            if (!compact)
              const Text(
                'RWANDA HEALTH',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.6,
                  color: AppColors.textTertiary,
                ),
              ),
          ],
        ),
      ],
    );
  }
}
