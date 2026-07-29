import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';

/// The search bar at the top of Medical Records: a text field plus a
/// circular "advanced filter" action, matching the design's rounded-search
/// + circular-filter-button pairing.
class RecordsSearchField extends StatelessWidget {
  final ValueChanged<String>? onChanged;
  final VoidCallback? onFilterTap;

  const RecordsSearchField({super.key, this.onChanged, this.onFilterTap});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(AppRadius.lg),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x0A0F172A),
                  blurRadius: 12,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: TextField(
              onChanged: onChanged,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.textPrimary,
              ),
              decoration: const InputDecoration(
                isDense: true,
                filled: false,
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: 14,
                ),
                hintText: 'Search records, labs, prescriptions...',
                hintStyle: TextStyle(
                  fontSize: 13.5,
                  color: AppColors.textTertiary,
                ),
                prefixIcon: Icon(
                  LucideIcons.search,
                  size: 19,
                  color: AppColors.textTertiary,
                ),
                prefixIconConstraints: BoxConstraints(minWidth: 44),
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Material(
          color: AppColors.primary,
          shape: const CircleBorder(),
          child: InkWell(
            onTap: onFilterTap,
            customBorder: const CircleBorder(),
            child: const Padding(
              padding: EdgeInsets.all(13),
              child: Icon(
                LucideIcons.slidersHorizontal,
                size: 18,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
