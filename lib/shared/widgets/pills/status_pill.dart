import 'package:flutter/material.dart';

/// A small rounded label chip — the design's single most reused element.
/// It appears as a status badge (Urgent, Pending, Completed), a category
/// tag (Hypertension, Diabetes), and an instruction hint (With food).
///
/// [color] drives both the text and, tinted, the fill. Pass [filled] false
/// for the bordered-only variant used by the routing chips on DOC-06.
class StatusPill extends StatelessWidget {
  final String label;
  final Color color;
  final IconData? icon;
  final bool filled;
  final double fontSize;

  const StatusPill({
    super.key,
    required this.label,
    required this.color,
    this.icon,
    this.filled = true,
    this.fontSize = 11.5,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: filled ? color.withValues(alpha: 0.12) : Colors.transparent,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: color.withValues(alpha: filled ? 0.0 : 0.4)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: fontSize + 1.5, color: color),
            const SizedBox(width: 4),
          ],
          Text(
            label,
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.w700,
              color: color,
              height: 1.1,
            ),
          ),
        ],
      ),
    );
  }
}
