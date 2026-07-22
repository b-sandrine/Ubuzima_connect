import 'package:flutter/material.dart';

import '../../../core/theme/app_spacing.dart';

/// Groups related fields under a titled section — patient-intake, referral,
/// and risk-assessment forms all tend to be long, and this keeps them
/// visually chunked instead of one undifferentiated column of fields.
class FormSection extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const FormSection({super.key, required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: AppSpacing.sm),
        ...children.expand(
          (child) => [child, const SizedBox(height: AppSpacing.sm)],
        ),
      ],
    );
  }
}
