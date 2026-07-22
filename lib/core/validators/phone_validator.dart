abstract final class PhoneValidator {
  /// Matches Rwandan mobile numbers: `+2507XXXXXXXX` or local `07XXXXXXXX`.
  static final RegExp _pattern = RegExp(r'^(\+250|0)7[0-9]{8}$');

  /// Returns a validation error message, or `null` when [value] is valid.
  static String? validate(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Phone number is required';
    }
    final normalized = value.trim().replaceAll(' ', '');
    if (!_pattern.hasMatch(normalized)) {
      return 'Enter a valid Rwandan phone number';
    }
    return null;
  }
}
