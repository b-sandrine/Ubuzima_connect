import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../core/theme/app_colors.dart';

/// The Ubuzima logo lockup: a round white tile holding the emerald-to-blue
/// water-drop mark, the gradient wordmark, and the "RWANDA HEALTH" kicker.
///
/// [compact] drops the kicker and shrinks the mark for the in-app headers,
/// which show the same lockup at roughly half height.
class UbuzimaWordmark extends StatelessWidget {
  final bool compact;

  const UbuzimaWordmark({super.key, this.compact = false});

  /// Emerald-to-blue sweep shared by the mark and the wordmark text.
  static const LinearGradient _brandSweep = LinearGradient(
    colors: [Color(0xFF10B981), Color(0xFF3B82F6)],
  );

  @override
  Widget build(BuildContext context) {
    final markSize = compact ? 28.0 : 44.0;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: markSize,
          height: markSize,
          decoration: const BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Color(0x1410B981),
                blurRadius: 12,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: ShaderMask(
            shaderCallback: (bounds) => _brandSweep.createShader(bounds),
            child: Icon(
              LucideIcons.droplet,
              size: markSize * 0.46,
              color: Colors.white,
            ),
          ),
        ),
        SizedBox(width: compact ? 8 : 12),
        // Flexible so a cramped header (a wide context pill beside it) makes
        // the wordmark ellipsize rather than overflow the row.
        Flexible(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ShaderMask(
                shaderCallback: (bounds) => _brandSweep.createShader(bounds),
                child: Text(
                  'Ubuzima',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: compact ? 18 : 24,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    height: 1.1,
                  ),
                ),
              ),
              if (!compact)
                const Text(
                  'RWANDA HEALTH',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1.6,
                    color: AppColors.textTertiary,
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
