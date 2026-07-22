import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Thin wrapper around SharedPreferences for non-sensitive key/value data
/// (locale choice, theme mode, onboarding flags). Tokens and anything
/// sensitive belong in [SecureStorageService] instead.
abstract interface class LocalStorageService {
  Future<bool> setString(String key, String value);
  String? getString(String key);

  Future<bool> setBool(String key, bool value);
  bool? getBool(String key);

  Future<bool> setInt(String key, int value);
  int? getInt(String key);

  Future<bool> remove(String key);
}

@LazySingleton(as: LocalStorageService)
class LocalStorageServiceImpl implements LocalStorageService {
  final SharedPreferences _preferences;

  LocalStorageServiceImpl(this._preferences);

  @override
  Future<bool> setString(String key, String value) =>
      _preferences.setString(key, value);

  @override
  String? getString(String key) => _preferences.getString(key);

  @override
  Future<bool> setBool(String key, bool value) =>
      _preferences.setBool(key, value);

  @override
  bool? getBool(String key) => _preferences.getBool(key);

  @override
  Future<bool> setInt(String key, int value) => _preferences.setInt(key, value);

  @override
  int? getInt(String key) => _preferences.getInt(key);

  @override
  Future<bool> remove(String key) => _preferences.remove(key);
}
