import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/network/network_info.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';

/// The informational "Network Status" row inside Connectivity — the only
/// row driven by live device state rather than a stored preference, via
/// the existing [NetworkInfo] service (no new connectivity plumbing).
class NetworkStatusTile extends StatefulWidget {
  const NetworkStatusTile({super.key});

  @override
  State<NetworkStatusTile> createState() => _NetworkStatusTileState();
}

class _NetworkStatusTileState extends State<NetworkStatusTile> {
  final NetworkInfo _networkInfo = getIt<NetworkInfo>();
  late Future<bool> _initialStatus;

  @override
  void initState() {
    super.initState();
    _initialStatus = _networkInfo.isConnected;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _initialStatus,
      builder: (context, snapshot) {
        return StreamBuilder<bool>(
          stream: _networkInfo.onConnectivityChanged,
          initialData: snapshot.data,
          builder: (context, streamSnapshot) {
            final isConnected = streamSnapshot.data ?? false;
            final color = isConnected ? AppColors.success : AppColors.danger;

            return Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.sm + 4,
                vertical: AppSpacing.sm + 4,
              ),
              child: Row(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    margin: const EdgeInsets.only(left: 4, right: 12),
                    decoration: BoxDecoration(color: color, shape: BoxShape.circle),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Network Status',
                          style: TextStyle(
                            fontSize: 14.5,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          isConnected
                              ? 'Connected via Mobile Data'
                              : 'No connection — working offline',
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    isConnected ? LucideIcons.wifi : LucideIcons.wifiOff,
                    size: 16,
                    color: color,
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
