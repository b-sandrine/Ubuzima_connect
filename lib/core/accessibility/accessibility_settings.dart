/// The Settings screen's "Appearance & Accessibility" preferences that
/// apply app-wide rather than to a single screen — text scale (affects
/// every screen via `MediaQuery`) and high contrast (swaps the active
/// `ThemeData` in `app.dart`).
///
/// Screen Reader has no in-app toggle equivalent (screen readers are an OS
/// accessibility service, not something a Flutter app can switch on for
/// itself) so it's stored as a preference hint only — see the TODO on
/// [AccessibilityCubit.setScreenReaderHint].
class AccessibilitySettings {
  /// Index into [textScaleSteps] — stored as an index rather than the raw
  /// double so persistence only needs `LocalStorageService.setInt`.
  final int textScaleStepIndex;
  final bool highContrast;
  final bool screenReaderHint;

  static const List<double> textScaleSteps = [0.85, 1.0, 1.15, 1.3];

  const AccessibilitySettings({
    this.textScaleStepIndex = 1,
    this.highContrast = false,
    this.screenReaderHint = false,
  });

  double get textScale => textScaleSteps[textScaleStepIndex];

  AccessibilitySettings copyWith({
    int? textScaleStepIndex,
    bool? highContrast,
    bool? screenReaderHint,
  }) {
    return AccessibilitySettings(
      textScaleStepIndex: textScaleStepIndex ?? this.textScaleStepIndex,
      highContrast: highContrast ?? this.highContrast,
      screenReaderHint: screenReaderHint ?? this.screenReaderHint,
    );
  }
}
