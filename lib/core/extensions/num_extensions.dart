extension NumExtensions on num {
  /// Formats a distance in meters as a human-readable string, e.g. `"850 m"`
  /// or `"3.2 km"` — used by the Location module's pharmacy/medicine locator.
  String get asDistanceLabel {
    if (this < 1000) return '${round()} m';
    return '${(this / 1000).toStringAsFixed(1)} km';
  }
}
