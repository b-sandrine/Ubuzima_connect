abstract final class RequiredValidator {
  /// Returns a validation error message, or `null` when [value] is present.
  static String? validate(String? value, {String fieldName = 'This field'}) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }
}
