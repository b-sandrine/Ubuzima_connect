import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../core/extensions/string_extensions.dart';

/// Circular avatar for CHWs, Doctors, and Patients — falls back to
/// initials over a themed background when no photo URL is available or
/// while offline (cached_network_image serves the last-cached image
/// automatically once fetched).
class UserAvatar extends StatelessWidget {
  final String? photoUrl;
  final String displayName;
  final double radius;

  const UserAvatar({
    super.key,
    required this.displayName,
    this.photoUrl,
    this.radius = 20,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    if (photoUrl == null || photoUrl!.isEmpty) {
      return CircleAvatar(
        radius: radius,
        backgroundColor: colors.primaryContainer,
        child: Text(
          displayName.initials,
          style: TextStyle(color: colors.onPrimaryContainer),
        ),
      );
    }

    return CircleAvatar(
      radius: radius,
      backgroundColor: colors.primaryContainer,
      foregroundImage: CachedNetworkImageProvider(photoUrl!),
    );
  }
}
