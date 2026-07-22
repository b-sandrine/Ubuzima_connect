abstract final class EmailValidator {
  static final RegExp _pattern = RegExp(r'^[\w.+-]+@[\w-]+\.[a-zA-Z]{2,}$');

  /// Returns a validation error message, or `null` when [value] is valid.
  static String? validate(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email is required';
    }
    if (!_pattern.hasMatch(value.trim())) {
      return 'Enter a valid email address';
    }
    return null;
  }
}
