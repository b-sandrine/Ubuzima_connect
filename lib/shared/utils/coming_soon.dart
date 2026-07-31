import 'package:flutter/material.dart';

/// Shows a lightweight snackbar for taps on features that don't have a
/// screen yet (e.g. the doctor role's "AI Insights" bottom-nav tab), so
/// every tap gives feedback instead of silently doing nothing.
void showComingSoon(BuildContext context, String feature) {
  ScaffoldMessenger.of(
    context,
  ).showSnackBar(SnackBar(content: Text('$feature is coming soon.')));
}
