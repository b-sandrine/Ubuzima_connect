import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

/// Clinical-range → (label, colour) lookups for each vital, so the Vitals
/// Entry tiles and any future summary card read the same thresholds.
abstract final class VitalsStyle {
  static (String, Color) bloodPressure(int? systolic, int? diastolic) {
    if (systolic == null || diastolic == null) return ('—', AppColors.textTertiary);
    if (systolic >= 140 || diastolic >= 90) return ('High', AppColors.danger);
    if (systolic < 90 || diastolic < 60) return ('Low', AppColors.warning);
    return ('Normal', AppColors.success);
  }

  static (String, Color) bloodGlucose(double? value) {
    if (value == null) return ('—', AppColors.textTertiary);
    if (value >= 11.1) return ('High', AppColors.danger);
    if (value > 7.8) return ('Elevated', AppColors.warning);
    return ('Normal', AppColors.success);
  }

  static (String, Color) pulseRate(int? value) {
    if (value == null) return ('—', AppColors.textTertiary);
    if (value > 100) return ('High', AppColors.danger);
    if (value < 60) return ('Low', AppColors.warning);
    return ('Normal', AppColors.success);
  }

  static (String, Color) temperature(double? value) {
    if (value == null) return ('—', AppColors.textTertiary);
    if (value > 37.2) return ('Fever', AppColors.danger);
    if (value < 36.1) return ('Low', AppColors.warning);
    return ('Normal', AppColors.success);
  }

  static (String, Color) spo2(int? value) {
    if (value == null) return ('—', AppColors.textTertiary);
    if (value < 90) return ('Critical', AppColors.danger);
    if (value < 95) return ('Low', AppColors.warning);
    return ('Normal', AppColors.success);
  }
}
