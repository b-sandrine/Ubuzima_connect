/// Maps a Rwandan phone number to the synthetic email used for Firebase Auth
/// when CHWs sign in with their phone number instead of an email address.
abstract final class PhoneAuthEmail {
  static String? fromPhone(String? value) {
    if (value == null || value.trim().isEmpty) return null;

    final digits = value.trim().replaceAll(RegExp(r'\s+'), '');
    final normalized = switch (digits) {
      final d when d.startsWith('+250') => d.substring(1),
      final d when d.startsWith('0') => '25${d.substring(1)}',
      final d when d.startsWith('250') => d,
      _ => null,
    };

    if (normalized == null || normalized.length != 12) return null;
    return '$normalized@phone.ubuzima.connect';
  }
}
