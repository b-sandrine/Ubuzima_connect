import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/pills/status_pill.dart';
import '../../domain/entities/timeline_event.dart';
import 'event_category_style.dart';

/// One event on the DOC-04 timeline: a coloured node on the spine, then a
/// card carrying the category badge, date, title and clinical detail. The
/// connector rail runs down the left behind the card via a [Stack], so the
/// card's own height drives the rail length without an intrinsic-height pass.
class TimelineEventCard extends StatelessWidget {
  final TimelineEvent event;

  /// Whether this is the last card under its year group, so the connector
  /// rail below the node can be omitted.
  final bool isLast;

  const TimelineEventCard({
    super.key,
    required this.event,
    this.isLast = false,
  });

  static const double _nodeSize = 36;
  static const double _railX = _nodeSize / 2 - 1; // centre the 2px rail

  @override
  Widget build(BuildContext context) {
    final style = EventCategoryStyle.of(event.category);

    return Stack(
      children: [
        if (!isLast)
          Positioned(
            left: _railX,
            top: _nodeSize,
            bottom: 0,
            child: Container(width: 2, color: AppColors.border),
          ),
        Padding(
          padding: const EdgeInsets.only(left: _nodeSize + 12, bottom: 16),
          child: _Card(event: event, style: style),
        ),
        Positioned(
          left: 0,
          top: 0,
          child: _Node(color: style.color, icon: style.icon),
        ),
      ],
    );
  }
}

class _Node extends StatelessWidget {
  final Color color;
  final IconData icon;

  const _Node({required this.color, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: TimelineEventCard._nodeSize,
      height: TimelineEventCard._nodeSize,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.14),
        shape: BoxShape.circle,
        border: Border.all(color: color.withValues(alpha: 0.4)),
      ),
      child: Icon(icon, size: 18, color: color),
    );
  }
}

class _Card extends StatelessWidget {
  final TimelineEvent event;
  final EventCategoryStyle style;

  const _Card({required this.event, required this.style});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A0F172A),
            blurRadius: 10,
            offset: Offset(0, 3),
          ),
        ],
      ),
      // ClipRRect keeps the coloured accent bar's square corners inside the
      // card's rounded ones, and a Stack (not an IntrinsicHeight row) stretches
      // the bar to the content height without an intrinsic-width pass — which
      // an inner Expanded would otherwise break.
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          children: [
            Positioned(
              left: 0,
              top: 0,
              bottom: 0,
              child: Container(width: 3, color: style.color),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(17, 14, 14, 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      StatusPill(
                        label: style.label,
                        color: style.color,
                        fontSize: 10.5,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          event.dateLabel,
                          style: const TextStyle(
                            fontSize: 11.5,
                            color: AppColors.textTertiary,
                          ),
                        ),
                      ),
                      const Icon(
                        Icons.expand_more,
                        size: 18,
                        color: AppColors.textTertiary,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    event.title,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    event.detail,
                    style: const TextStyle(
                      fontSize: 12.5,
                      height: 1.4,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
