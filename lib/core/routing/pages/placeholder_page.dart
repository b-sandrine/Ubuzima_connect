import 'package:flutter/material.dart';

/// Stand-in for `/login` and `/home` until `features/authentication` and the
/// role-specific home shells land. Exists purely so routing, theming, and
/// localization can be verified end-to-end at foundation stage.
class PlaceholderPage extends StatelessWidget {
  final String title;

  const PlaceholderPage({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(child: Text('$title — feature pending')),
    );
  }
}
