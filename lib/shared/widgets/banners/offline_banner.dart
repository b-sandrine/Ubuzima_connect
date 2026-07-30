import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../core/connectivity/connectivity_cubit.dart';
import '../../../core/localization/locale_extensions.dart';
import '../../../core/theme/app_colors.dart';

/// OFFLINE-01. Sits once, globally, above every screen (wired in
/// `app.dart`'s `MaterialApp.router(builder: ...)`) rather than being added
/// screen-by-screen — connectivity, like locale, is something every screen
/// cares about equally, so no feature should have to remember to include it.
///
/// Shows a persistent amber strip while offline, and a brief green
/// confirmation strip for a few seconds after reconnecting, then collapses
/// to nothing.
class OfflineBanner extends StatefulWidget {
  const OfflineBanner({super.key});

  @override
  State<OfflineBanner> createState() => _OfflineBannerState();
}

class _OfflineBannerState extends State<OfflineBanner> {
  bool? _lastOnline;
  bool _showReconnected = false;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return BlocListener<ConnectivityCubit, bool>(
      listener: (context, isOnline) {
        final wasOffline = _lastOnline == false;
        _lastOnline = isOnline;
        if (isOnline && wasOffline) {
          setState(() => _showReconnected = true);
          Future.delayed(const Duration(seconds: 3), () {
            if (mounted) setState(() => _showReconnected = false);
          });
        }
      },
      child: BlocBuilder<ConnectivityCubit, bool>(
        builder: (context, isOnline) {
          _lastOnline ??= isOnline;

          final visible = !isOnline || _showReconnected;
          final Color background = !isOnline
              ? AppColors.warning
              : AppColors.success;
          final IconData icon = !isOnline
              ? LucideIcons.wifiOff
              : LucideIcons.wifi;
          final String message = !isOnline
              ? l10n.offlineBannerMessage
              : l10n.backOnlineMessage;

          return AnimatedSize(
            duration: const Duration(milliseconds: 220),
            curve: Curves.easeInOut,
            alignment: Alignment.topCenter,
            child: visible
                ? _Banner(color: background, icon: icon, message: message)
                : const SizedBox(width: double.infinity, height: 0),
          );
        },
      ),
    );
  }
}

class _Banner extends StatelessWidget {
  final Color color;
  final IconData icon;
  final String message;

  const _Banner({required this.color, required this.icon, required this.message});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color,
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 15, color: Colors.white),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  message,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
