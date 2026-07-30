import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

import '../constants/storage_keys.dart';
import '../storage/local_storage_service.dart';

/// Holds the user's Dark Mode preference from Settings — mirrors
/// [LocaleCubit]'s shape exactly (a persisted, app-wide Cubit sitting above
/// `MaterialApp`) since dark mode is the same kind of whole-app concern as
/// locale, not a per-screen setting.
@lazySingleton
class ThemeCubit extends Cubit<ThemeMode> {
  final LocalStorageService _storage;

  ThemeCubit(this._storage) : super(ThemeMode.system) {
    _restore();
  }

  void _restore() {
    final stored = _storage.getString(StorageKeys.themeMode);
    if (stored != null) emit(_decode(stored));
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    if (state == mode) return;

    emit(mode);
    await _storage.setString(StorageKeys.themeMode, _encode(mode));
  }

  Future<void> toggleDark(bool isDark) =>
      setThemeMode(isDark ? ThemeMode.dark : ThemeMode.light);

  String _encode(ThemeMode mode) => switch (mode) {
    ThemeMode.light => 'light',
    ThemeMode.dark => 'dark',
    ThemeMode.system => 'system',
  };

  ThemeMode _decode(String value) => switch (value) {
    'light' => ThemeMode.light,
    'dark' => ThemeMode.dark,
    _ => ThemeMode.system,
  };
}
