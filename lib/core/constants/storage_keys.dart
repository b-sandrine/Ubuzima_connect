/// Single source of truth for every SharedPreferences / SecureStorage key.
///
/// Never hardcode a key string at a call site — add it here first. This is
/// what prevents two features from silently colliding on the same key.
abstract final class StorageKeys {
  // Secure storage (flutter_secure_storage)
  static const String authToken = 'secure.auth_token';
  static const String refreshToken = 'secure.refresh_token';
  static const String currentUserId = 'secure.current_user_id';

  // Shared preferences (non-sensitive)
  static const String selectedLocale = 'prefs.selected_locale';
  static const String themeMode = 'prefs.theme_mode';
  static const String onboardingComplete = 'prefs.onboarding_complete';
  static const String selectedRole = 'prefs.selected_role';
  static const String lastSyncTimestamp = 'prefs.last_sync_timestamp';

  // Accessibility (Settings — Appearance & Accessibility)
  static const String textScale = 'prefs.text_scale';
  static const String highContrast = 'prefs.high_contrast';
  static const String screenReaderHint = 'prefs.screen_reader_hint';

  // Account preferences (Settings — Account Preferences)
  static const String pushNotificationsEnabled = 'prefs.push_notifications_enabled';
  static const String biometricLoginEnabled = 'prefs.biometric_login_enabled';
  static const String dataSharingEnabled = 'prefs.data_sharing_enabled';

  // Connectivity (Settings — Connectivity)
  static const String offlineModeEnabled = 'prefs.offline_mode_enabled';
  static const String autoSyncEnabled = 'prefs.auto_sync_enabled';
}
