import 'package:flutter/material.dart';

import '../../constants/app_constants.dart';

/// Shown while [RouteGuards] resolves the initial redirect. Not a feature —
/// this is app shell chrome, replaced by a real branded splash once design
/// assets exist.
class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text(AppConstants.appName),
          ],
        ),
      ),
    );
  }
}
