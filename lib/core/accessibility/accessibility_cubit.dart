import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';

import '../constants/storage_keys.dart';
import '../storage/local_storage_service.dart';
import 'accessibility_settings.dart';

/// Holds the Settings screen's Text Size / High Contrast / Screen Reader
/// preferences — an app-wide Cubit (sits above `MaterialApp` alongside
/// [ThemeCubit] and `LocaleCubit`) since text scale and high contrast both
/// need to affect every screen, not just Settings itself.
@lazySingleton
class AccessibilityCubit extends Cubit<AccessibilitySettings> {
  final LocalStorageService _storage;

  AccessibilityCubit(this._storage) : super(const AccessibilitySettings()) {
    _restore();
  }

  void _restore() {
    final stepIndex = _storage.getInt(StorageKeys.textScale);
    final highContrast = _storage.getBool(StorageKeys.highContrast);
    final screenReaderHint = _storage.getBool(StorageKeys.screenReaderHint);

    emit(
      AccessibilitySettings(
        textScaleStepIndex: (stepIndex != null &&
                stepIndex >= 0 &&
                stepIndex < AccessibilitySettings.textScaleSteps.length)
            ? stepIndex
            : state.textScaleStepIndex,
        highContrast: highContrast ?? state.highContrast,
        screenReaderHint: screenReaderHint ?? state.screenReaderHint,
      ),
    );
  }

  Future<void> increaseTextSize() => _setTextScaleStep(
    state.textScaleStepIndex + 1,
  );

  Future<void> decreaseTextSize() => _setTextScaleStep(
    state.textScaleStepIndex - 1,
  );

  Future<void> _setTextScaleStep(int index) async {
    final clamped = index.clamp(
      0,
      AccessibilitySettings.textScaleSteps.length - 1,
    );
    if (clamped == state.textScaleStepIndex) return;

    emit(state.copyWith(textScaleStepIndex: clamped));
    await _storage.setInt(StorageKeys.textScale, clamped);
  }

  Future<void> setHighContrast(bool enabled) async {
    if (enabled == state.highContrast) return;

    emit(state.copyWith(highContrast: enabled));
    await _storage.setBool(StorageKeys.highContrast, enabled);
  }

  /// Persists the user's request, but a Flutter app cannot itself turn on
  /// the OS screen reader (TalkBack / VoiceOver) — that toggle lives in
  /// the device's own accessibility settings.
  /// TODO: once a real need is identified (e.g. extra semantic labels
  /// behind this flag), read [AccessibilitySettings.screenReaderHint] from
  /// wherever that behavior should change.
  Future<void> setScreenReaderHint(bool enabled) async {
    if (enabled == state.screenReaderHint) return;

    emit(state.copyWith(screenReaderHint: enabled));
    await _storage.setBool(StorageKeys.screenReaderHint, enabled);
  }
}
