import 'package:flutter/material.dart';

/// Healthcare palette: calming teal as the primary (trust, care), a warm
/// coral for urgent/risk states, and neutral surfaces that stay legible in
/// bright field conditions CHWs actually work in.
abstract final class AppColors {
  // Brand
  static const Color primary = Color(0xFF0F766E); // teal 700
  static const Color primaryLight = Color(0xFF14B8A6); // teal 500
  static const Color primaryDark = Color(0xFF115E59); // teal 800
  static const Color secondary = Color(0xFF2563EB); // blue 600

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

  // Neutrals
  static const Color lightBackground = Color(0xFFF8FAFC);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color darkBackground = Color(0xFF0F172A);
  static const Color darkSurface = Color(0xFF1E293B);
  static const Color border = Color(0xFFE2E8F0);
  static const Color borderDark = Color(0xFF334155);
}
