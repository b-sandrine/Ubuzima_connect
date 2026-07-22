import 'package:bloc/bloc.dart';
import 'package:flutter/widgets.dart';
import 'package:injectable/injectable.dart';

import '../constants/storage_keys.dart';
import '../storage/local_storage_service.dart';

/// Holds the language the user picked from the EN / RW / FR switcher.
///
/// A `null` state means "follow the device locale" — the app ships that way
/// so a Kinyarwanda phone opens in Kinyarwanda without anyone touching the
/// switcher first. Once a language is chosen explicitly it is persisted and
/// wins over the device setting from then on.
@lazySingleton
class LocaleCubit extends Cubit<Locale?> {
  final LocalStorageService _storage;

  LocaleCubit(this._storage) : super(null) {
    _restore();
  }

  void _restore() {
    final code = _storage.getString(StorageKeys.selectedLocale);
    if (code != null && code.isNotEmpty) {
      emit(Locale(code));
    }
  }

  Future<void> setLocale(Locale locale) async {
    if (state?.languageCode == locale.languageCode) return;

    emit(locale);
    await _storage.setString(StorageKeys.selectedLocale, locale.languageCode);
  }

  /// Drops the override and goes back to following the device locale.
  Future<void> clear() async {
    emit(null);
    await _storage.remove(StorageKeys.selectedLocale);
  }
}
