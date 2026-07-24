import 'package:flutter/material.dart';

/// Healthcare palette taken from the Ubuzima design file: a calm emerald
/// green as the primary (growth, care), a warm coral for urgent/risk
/// states, and near-white surfaces that stay legible in the bright field
/// conditions CHWs actually work in.
abstract final class AppColors {
  // Brand — emerald is the design file's dominant brand hue.
  static const Color primary = Color(0xFF10B981); // emerald 500
  static const Color primaryLight = Color(0xFF34D399); // emerald 400
  static const Color primaryDark = Color(0xFF059669); // emerald 600
  static const Color secondary = Color(0xFF2563EB); // blue 600

  /// The signature emerald sweep the design uses on pill buttons, the app
  /// mark, and patient summary cards — a light-to-deep emerald, not a flat
  /// fill.
  static const List<Color> primaryGradient = [
    Color(0xFF34D399),
    Color(0xFF10B981),
  ];

  /// The soft green-to-blue wash sitting behind every onboarding and
  /// dashboard screen (green-50 → blue-50 in the design).
  static const List<Color> backgroundGradient = [
    Color(0xFFF0FDF4),
    Color(0xFFF0FDFA),
    Color(0xFFEFF6FF),
  ];

  // Semantic / clinical status
  static const Color success = Color(0xFF16A34A);
  static const Color warning = Color(0xFFD97706);
  static const Color danger = Color(0xFFDC2626);
  static const Color info = Color(0xFF0284C7);

  // Risk levels (risk_assessment feature)
  static const Color riskLow = Color(0xFF16A34A);
  static const Color riskMedium = Color(0xFFD97706);
  static const Color riskHigh = Color(0xFFDC2626);
  static const Color riskCritical = Color(0xFF7F1D1D);

  /// Per-role accents. Each role keeps the same hue everywhere it appears —
  /// icon tile, badge, selection ring — so the association is learned once
  /// and reused across the CHW, patient, and doctor surfaces.
  static const Color roleChw = Color(0xFF10B981); // emerald 500
  static const Color roleChwTint = Color(0xFFD1FAE5); // emerald 100
  static const Color rolePatient = Color(0xFF3B82F6); // blue 500
  static const Color rolePatientTint = Color(0xFFDBEAFE); // blue 100
  static const Color roleDoctor = Color(0xFFEA580C); // orange 600
  static const Color roleDoctorTint = Color(0xFFFFEDD5); // orange 100

  // Neutrals
  static const Color lightBackground = Color(0xFFF6FBF8);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color darkBackground = Color(0xFF0F172A);
  static const Color darkSurface = Color(0xFF1E293B);
  static const Color border = Color(0xFFE2E8F0);
  static const Color borderDark = Color(0xFF334155);

  // Type
  static const Color textPrimary = Color(0xFF0F172A);
  static const Color textSecondary = Color(0xFF64748B);
  static const Color textTertiary = Color(0xFF94A3B8);
}
