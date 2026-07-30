import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';

/// OFFLINE-01's actual UI is the global banner in `app.dart` (visible above
/// every screen already) — there is no separate destination screen for it.
/// This page exists only so the showcase hub has something to push to when
/// its card is tapped, and to explain that to whoever is demoing it.
class OfflineIndicatorInfoPage extends StatelessWidget {
  const OfflineIndicatorInfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Offline Indicator (OFFLINE-01)')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.wifi_off, size: 40, color: AppColors.warning),
            const SizedBox(height: 16),
            const Text(
              'This one is already visible.',
              style: TextStyle(fontSize: 19, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 10),
            const Text(
              'The offline banner is global — it sits above every screen in '
              'the app (see app.dart), not on a separate page. Turn on '
              'Airplane Mode to see the amber "you\'re offline" strip appear '
              'at the top, then turn it back off to see the brief green '
              '"you\'re back online" confirmation.',
              style: TextStyle(fontSize: 14, height: 1.5),
            ),
            const SizedBox(height: 18),
            OutlinedButton.icon(
              onPressed: () => Navigator.of(context).maybePop(),
              icon: const Icon(Icons.arrow_back, size: 16),
              label: const Text('Back to Showcase'),
            ),
          ],
        ),
      ),
    );
  }
}
