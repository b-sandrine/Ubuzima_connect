import 'package:flutter/material.dart';

/// Standard app bar used by feature screens — plain title bar today, and
/// the single place to add a shared offline/sync-status indicator once
/// `offline_sync` exists, instead of every screen wiring its own.
class PrimaryAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final Widget? leading;

  const PrimaryAppBar({
    super.key,
    required this.title,
    this.actions,
    this.leading,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(title: Text(title), actions: actions, leading: leading);
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
