import 'package:flutter/material.dart';

class BarChartEntry {
  final String label;
  final double value;

  const BarChartEntry({required this.label, required this.value});
}

/// Minimal dependency-free bar chart for foundation-stage trend displays
/// (e.g. weekly patient visit counts, risk-score history). Swap for a
/// full charting package (e.g. `fl_chart`) once real chart requirements
/// (zoom, tooltips, multi-series) are defined — kept dependency-free for
/// now since none was requested in the tech stack.
class SimpleBarChart extends StatelessWidget {
  final List<BarChartEntry> entries;
  final double height;

  const SimpleBarChart({super.key, required this.entries, this.height = 120});

  @override
  Widget build(BuildContext context) {
    final maxValue = entries
        .map((e) => e.value)
        .fold<double>(0, (a, b) => a > b ? a : b);
    final colors = Theme.of(context).colorScheme;

    return SizedBox(
      height: height,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          for (final entry in entries)
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Expanded(
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: FractionallySizedBox(
                          heightFactor: maxValue == 0
                              ? 0
                              : entry.value / maxValue,
                          child: Container(
                            decoration: BoxDecoration(
                              color: colors.primary,
                              borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(4),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      entry.label,
                      style: Theme.of(context).textTheme.labelSmall,
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
