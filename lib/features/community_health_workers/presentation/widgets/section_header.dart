import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

/// A section title row on the CHW health record: a small tinted icon tile, a
/// bold label, and an optional [trailing] badge (Live, "3 Pending").
class SectionHeader extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color tint;
  final Color iconColor;
  final Widget? trailing;

  const SectionHeader({
    super.key,
    required this.icon,
    required this.label,
    required this.tint,
    required this.iconColor,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            color: tint,
            borderRadius: BorderRadius.circular(9),
          ),
          child: Icon(icon, size: 16, color: iconColor),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
            ),
          ),
        ),
        ?trailing,
      ],
    );
  }
}
