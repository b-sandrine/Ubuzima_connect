import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../community_health_workers/presentation/widgets/section_header.dart';

/// The generic form controls shared by every Patient Registration section —
/// styled to match the rounded white fields already established by the
/// referral form (`referral_form_view.dart`), so the intake flow reads as
/// the same design language rather than a one-off.

/// A titled white card: an icon-tile [SectionHeader] above a bordered
/// container holding [children], spaced the same way on every section.
class IntakeSectionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color tint;
  final Color iconColor;
  final Widget? trailing;
  final List<Widget> children;

  const IntakeSectionCard({
    super.key,
    required this.icon,
    required this.title,
    required this.children,
    this.tint = AppColors.roleChwTint,
    this.iconColor = AppColors.roleChw,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          icon: icon,
          label: title,
          tint: tint,
          iconColor: iconColor,
          trailing: trailing,
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: children,
          ),
        ),
      ],
    );
  }
}

/// The small bold field label, with a red asterisk when [required].
class IntakeFieldLabel extends StatelessWidget {
  final String text;
  final bool required;

  const IntakeFieldLabel(this.text, {super.key, this.required = false});

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        text: text,
        style: const TextStyle(
          fontSize: 11.5,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.3,
          color: AppColors.textTertiary,
        ),
        children: [
          if (required)
            const TextSpan(
              text: ' *',
              style: TextStyle(color: AppColors.danger),
            ),
        ],
      ),
    );
  }
}

/// The labelled, rounded white text field every intake section composes
/// instead of a raw `TextFormField`.
class IntakeTextField extends StatelessWidget {
  final String label;
  final String? hint;
  final String value;
  final ValueChanged<String> onChanged;
  final bool required;
  final TextInputType keyboardType;
  final int maxLines;
  final String? prefixText;
  final Widget? suffixIcon;
  final List<TextInputFormatter>? inputFormatters;

  const IntakeTextField({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
    this.hint,
    this.required = false,
    this.keyboardType = TextInputType.text,
    this.maxLines = 1,
    this.prefixText,
    this.suffixIcon,
    this.inputFormatters,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        IntakeFieldLabel(label, required: required),
        const SizedBox(height: 8),
        TextFormField(
          initialValue: value,
          maxLines: maxLines,
          keyboardType: keyboardType,
          inputFormatters: inputFormatters,
          onChanged: onChanged,
          style: const TextStyle(fontSize: 14, color: AppColors.textPrimary),
          decoration: InputDecoration(
            hintText: hint,
            prefixText: prefixText,
            suffixIcon: suffixIcon,
            hintStyle: const TextStyle(
              fontSize: 13.5,
              color: AppColors.textTertiary,
            ),
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 12,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: AppColors.border),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(
                color: AppColors.primary,
                width: 1.6,
              ),
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
      ],
    );
  }
}

/// A labelled dropdown menu styled to match [IntakeTextField]. [items] empty
/// renders a disabled placeholder — used for district/sector before their
/// parent picker is chosen.
class IntakeDropdownField extends StatelessWidget {
  final String label;
  final String hint;
  final String? value;
  final List<String> items;
  final ValueChanged<String?> onChanged;
  final bool required;

  const IntakeDropdownField({
    super.key,
    required this.label,
    required this.hint,
    required this.items,
    required this.onChanged,
    this.value,
    this.required = false,
  });

  @override
  Widget build(BuildContext context) {
    final enabled = items.isNotEmpty;
    final selected = (value != null && items.contains(value)) ? value : null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        IntakeFieldLabel(label, required: required),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          initialValue: selected,
          isExpanded: true,
          icon: const Icon(LucideIcons.chevronDown, size: 18),
          hint: Text(
            hint,
            style: const TextStyle(
              fontSize: 13.5,
              color: AppColors.textTertiary,
            ),
          ),
          onChanged: enabled ? onChanged : null,
          style: const TextStyle(fontSize: 14, color: AppColors.textPrimary),
          decoration: InputDecoration(
            filled: true,
            fillColor: enabled ? Colors.white : const Color(0xFFF1F5F9),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 12,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: AppColors.border),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(
                color: AppColors.primary,
                width: 1.6,
              ),
            ),
          ),
          items: [
            for (final item in items)
              DropdownMenuItem(value: item, child: Text(item)),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
      ],
    );
  }
}

/// A labelled date picker field — tapping opens [showDatePicker].
class IntakeDateField extends StatelessWidget {
  final String label;
  final DateTime? value;
  final ValueChanged<DateTime> onChanged;
  final bool required;

  const IntakeDateField({
    super.key,
    required this.label,
    required this.onChanged,
    this.value,
    this.required = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        IntakeFieldLabel(label, required: required),
        const SizedBox(height: 8),
        InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: () async {
            final now = DateTime.now();
            final picked = await showDatePicker(
              context: context,
              initialDate: value ?? DateTime(now.year - 25),
              firstDate: DateTime(now.year - 120),
              lastDate: now,
            );
            if (picked != null) onChanged(picked);
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    value == null
                        ? 'mm/dd/yyyy'
                        : '${value!.month.toString().padLeft(2, '0')}/'
                              '${value!.day.toString().padLeft(2, '0')}/'
                              '${value!.year}',
                    style: TextStyle(
                      fontSize: 14,
                      color: value == null
                          ? AppColors.textTertiary
                          : AppColors.textPrimary,
                    ),
                  ),
                ),
                const Icon(
                  LucideIcons.calendar,
                  size: 18,
                  color: AppColors.textTertiary,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
      ],
    );
  }
}

/// A read-only pill showing a derived value (e.g. computed age) beside an
/// input of the same row.
class IntakeReadOnlyField extends StatelessWidget {
  final String label;
  final String value;

  const IntakeReadOnlyField({
    super.key,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        IntakeFieldLabel(label),
        const SizedBox(height: 8),
        Container(
          height: 48,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: const Color(0xFFF1F5F9),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.border),
          ),
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: AppColors.textSecondary,
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
      ],
    );
  }
}

/// One selectable option in [IntakeSelectCards].
class IntakeOption<T> {
  final T value;
  final String label;
  final IconData? icon;

  const IntakeOption({required this.value, required this.label, this.icon});
}

/// A row of equal-width selectable cards — used for Gender, Insurance,
/// Pregnancy Status and Vaccination Status, matching the design's icon-card
/// pickers rather than a plain radio list.
class IntakeSelectCards<T> extends StatelessWidget {
  final String label;
  final bool required;
  final List<IntakeOption<T>> options;
  final T? selected;
  final ValueChanged<T> onSelected;
  final Color activeColor;

  const IntakeSelectCards({
    super.key,
    required this.label,
    required this.options,
    required this.onSelected,
    this.selected,
    this.required = false,
    this.activeColor = AppColors.primary,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        IntakeFieldLabel(label, required: required),
        const SizedBox(height: 8),
        Row(
          children: [
            for (final option in options) ...[
              Expanded(child: _buildCard(option)),
              if (option != options.last) const SizedBox(width: 10),
            ],
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
      ],
    );
  }

  Widget _buildCard(IntakeOption<T> option) {
    final isSelected = option.value == selected;
    return Builder(
      builder: (context) => Material(
        color: isSelected ? activeColor.withValues(alpha: 0.1) : Colors.white,
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          onTap: () => onSelected(option.value),
          borderRadius: BorderRadius.circular(14),
          child: Container(
            height: 68,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: isSelected ? activeColor : AppColors.border,
                width: isSelected ? 1.6 : 1,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (option.icon != null) ...[
                  Icon(
                    option.icon,
                    size: 18,
                    color: isSelected ? activeColor : AppColors.textTertiary,
                  ),
                  const SizedBox(height: 4),
                ],
                Text(
                  option.label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w700,
                    color: isSelected ? activeColor : AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Multi-select toggle chips (Reported Symptoms, Chronic Conditions), with
/// [noneLabel] wired to be mutually exclusive with every other chip.
class IntakeToggleChips extends StatelessWidget {
  final String label;
  final String trailing;
  final List<String> options;
  final Set<String> selected;
  final ValueChanged<Set<String>> onChanged;
  final String noneLabel;

  const IntakeToggleChips({
    super.key,
    required this.label,
    required this.options,
    required this.selected,
    required this.onChanged,
    this.trailing = '',
    this.noneLabel = 'None',
  });

  void _toggle(String option) {
    final next = {...selected};
    if (option == noneLabel) {
      next
        ..clear()
        ..add(noneLabel);
    } else {
      next.remove(noneLabel);
      if (next.contains(option)) {
        next.remove(option);
      } else {
        next.add(option);
      }
    }
    onChanged(next);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(child: IntakeFieldLabel(label)),
            if (trailing.isNotEmpty)
              Text(
                trailing,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: AppColors.warning,
                ),
              ),
          ],
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final option in options)
              _Chip(
                label: option,
                isSelected: selected.contains(option),
                onTap: () => _toggle(option),
              ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
      ],
    );
  }
}

class _Chip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _Chip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: isSelected ? AppColors.primary : Colors.white,
      borderRadius: BorderRadius.circular(999),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(999),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(999),
            border: Border.all(
              color: isSelected ? AppColors.primary : AppColors.border,
            ),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12.5,
              fontWeight: FontWeight.w600,
              color: isSelected ? Colors.white : AppColors.textSecondary,
            ),
          ),
        ),
      ),
    );
  }
}

/// The household-size style +/- counter.
class IntakeCounterField extends StatelessWidget {
  final String label;
  final int value;
  final int min;
  final String unitLabel;
  final ValueChanged<int> onChanged;

  const IntakeCounterField({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
    this.min = 1,
    this.unitLabel = 'members',
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        IntakeFieldLabel(label),
        const SizedBox(height: 8),
        Row(
          children: [
            _RoundButton(
              icon: LucideIcons.minus,
              onTap: value > min ? () => onChanged(value - 1) : null,
            ),
            Expanded(
              child: Column(
                children: [
                  Text(
                    '$value',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  Text(
                    unitLabel,
                    style: const TextStyle(
                      fontSize: 11,
                      color: AppColors.textTertiary,
                    ),
                  ),
                ],
              ),
            ),
            _RoundButton(
              icon: LucideIcons.plus,
              filled: true,
              onTap: () => onChanged(value + 1),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
      ],
    );
  }
}

class _RoundButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;
  final bool filled;

  const _RoundButton({required this.icon, this.onTap, this.filled = false});

  @override
  Widget build(BuildContext context) {
    final enabled = onTap != null;
    return Material(
      color: filled
          ? AppColors.primary
          : (enabled ? Colors.white : const Color(0xFFF1F5F9)),
      shape: const CircleBorder(side: BorderSide(color: AppColors.border)),
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: SizedBox(
          width: 40,
          height: 40,
          child: Icon(
            icon,
            size: 18,
            color: filled
                ? Colors.white
                : (enabled ? AppColors.textSecondary : AppColors.textTertiary),
          ),
        ),
      ),
    );
  }
}

/// One row switch tile — used by the Emergency Flags section.
class IntakeSwitchTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  const IntakeSwitchTile({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: AppColors.danger.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(11),
            ),
            child: Icon(icon, size: 18, color: AppColors.danger),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 11.5,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeTrackColor: AppColors.danger,
          ),
        ],
      ),
    );
  }
}

/// A read-only labelled row — used by the Registration Summary card.
class IntakeSummaryRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;

  const IntakeSummaryRow({
    super.key,
    required this.label,
    required this.value,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 13,
                color: AppColors.textSecondary,
              ),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: valueColor ?? AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
