import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/theme/app_colors.dart';
import '../../domain/models/consultation.dart';
import 'vitals_style.dart';

/// The editable "VITALS ENTRY" card: six recordable measurements as a
/// 2-column grid, each showing its clinical status the moment a value is
/// entered. Controllers are owned by the screen so the debounced autosave
/// and the "N of 6 filled" gate can read them directly.
class VitalsEntrySection extends StatelessWidget {
  final VitalsReading vitals;
  final TextEditingController systolicController;
  final TextEditingController diastolicController;
  final TextEditingController bloodGlucoseController;
  final TextEditingController pulseRateController;
  final TextEditingController weightController;
  final TextEditingController temperatureController;
  final TextEditingController spo2Controller;
  final VoidCallback onChanged;

  const VitalsEntrySection({
    super.key,
    required this.vitals,
    required this.systolicController,
    required this.diastolicController,
    required this.bloodGlucoseController,
    required this.pulseRateController,
    required this.weightController,
    required this.temperatureController,
    required this.spo2Controller,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final bp = VitalsStyle.bloodPressure(vitals.systolicBp, vitals.diastolicBp);
    final glucose = VitalsStyle.bloodGlucose(vitals.bloodGlucose);
    final pulse = VitalsStyle.pulseRate(vitals.pulseRate);
    final temp = VitalsStyle.temperature(vitals.temperatureC);
    final spo2 = VitalsStyle.spo2(vitals.spo2);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Expanded(
                child: Text(
                  'VITALS ENTRY',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.6,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              const Text(
                'Auto-saved',
                style: TextStyle(fontSize: 11, color: AppColors.textTertiary),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: _BloodPressureTile(
                  systolicController: systolicController,
                  diastolicController: diastolicController,
                  statusLabel: bp.$1,
                  statusColor: bp.$2,
                  onChanged: onChanged,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _VitalTile(
                  icon: LucideIcons.droplet,
                  iconColor: AppColors.warning,
                  label: 'Blood Glucose',
                  unit: 'mmol/L',
                  controller: bloodGlucoseController,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  statusLabel: glucose.$1,
                  statusColor: glucose.$2,
                  onChanged: onChanged,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: _VitalTile(
                  icon: LucideIcons.activity,
                  iconColor: const Color(0xFF7C3AED),
                  label: 'Pulse Rate',
                  unit: 'bpm',
                  controller: pulseRateController,
                  keyboardType: TextInputType.number,
                  statusLabel: pulse.$1,
                  statusColor: pulse.$2,
                  onChanged: onChanged,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _VitalTile(
                  icon: LucideIcons.scale,
                  iconColor: AppColors.secondary,
                  label: 'Weight',
                  unit: 'kg',
                  controller: weightController,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  statusLabel: vitals.weightKg == null ? '—' : 'Stable',
                  statusColor: AppColors.textTertiary,
                  onChanged: onChanged,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: _VitalTile(
                  icon: LucideIcons.thermometer,
                  iconColor: AppColors.warning,
                  label: 'Temperature',
                  unit: '°C',
                  controller: temperatureController,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  statusLabel: temp.$1,
                  statusColor: temp.$2,
                  onChanged: onChanged,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _VitalTile(
                  icon: LucideIcons.waves,
                  iconColor: AppColors.primary,
                  label: 'SpO2',
                  unit: '%',
                  controller: spo2Controller,
                  keyboardType: TextInputType.number,
                  statusLabel: spo2.$1,
                  statusColor: spo2.$2,
                  onChanged: onChanged,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _TileShell extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final String statusLabel;
  final Color statusColor;
  final Widget field;

  const _TileShell({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.statusLabel,
    required this.statusColor,
    required this.field,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: iconColor.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 15, color: iconColor),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  label,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          field,
          const SizedBox(height: 4),
          Text(
            statusLabel,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: statusColor,
            ),
          ),
        ],
      ),
    );
  }
}

class _VitalTile extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final String unit;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final String statusLabel;
  final Color statusColor;
  final VoidCallback onChanged;

  const _VitalTile({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.unit,
    required this.controller,
    required this.keyboardType,
    required this.statusLabel,
    required this.statusColor,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return _TileShell(
      icon: icon,
      iconColor: iconColor,
      label: label,
      statusLabel: statusLabel,
      statusColor: statusColor,
      field: Row(
        crossAxisAlignment: CrossAxisAlignment.baseline,
        textBaseline: TextBaseline.alphabetic,
        children: [
          IntrinsicWidth(
            child: TextField(
              controller: controller,
              keyboardType: keyboardType,
              onChanged: (_) => onChanged(),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
              ],
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
              ),
              decoration: const InputDecoration(
                isDense: true,
                border: InputBorder.none,
                contentPadding: EdgeInsets.zero,
                hintText: '—',
              ),
            ),
          ),
          const SizedBox(width: 4),
          Text(
            unit,
            style: const TextStyle(fontSize: 11.5, color: AppColors.textTertiary),
          ),
        ],
      ),
    );
  }
}

class _BloodPressureTile extends StatelessWidget {
  final TextEditingController systolicController;
  final TextEditingController diastolicController;
  final String statusLabel;
  final Color statusColor;
  final VoidCallback onChanged;

  const _BloodPressureTile({
    required this.systolicController,
    required this.diastolicController,
    required this.statusLabel,
    required this.statusColor,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return _TileShell(
      icon: LucideIcons.heartPulse,
      iconColor: AppColors.danger,
      label: 'Blood Pressure',
      statusLabel: statusLabel,
      statusColor: statusColor,
      field: Row(
        crossAxisAlignment: CrossAxisAlignment.baseline,
        textBaseline: TextBaseline.alphabetic,
        children: [
          IntrinsicWidth(
            child: TextField(
              controller: systolicController,
              keyboardType: TextInputType.number,
              onChanged: (_) => onChanged(),
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
              ),
              decoration: const InputDecoration(
                isDense: true,
                border: InputBorder.none,
                contentPadding: EdgeInsets.zero,
                hintText: '—',
              ),
            ),
          ),
          const Text(
            ' / ',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppColors.textTertiary,
            ),
          ),
          IntrinsicWidth(
            child: TextField(
              controller: diastolicController,
              keyboardType: TextInputType.number,
              onChanged: (_) => onChanged(),
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
              ),
              decoration: const InputDecoration(
                isDense: true,
                border: InputBorder.none,
                contentPadding: EdgeInsets.zero,
                hintText: '—',
              ),
            ),
          ),
          const SizedBox(width: 4),
          const Text(
            'mmHg',
            style: TextStyle(fontSize: 11.5, color: AppColors.textTertiary),
          ),
        ],
      ),
    );
  }
}
