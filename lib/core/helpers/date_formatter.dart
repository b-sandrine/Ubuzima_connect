import 'package:intl/intl.dart';

/// Centralized date/time formatting so every screen renders dates
/// consistently regardless of locale.
abstract final class DateFormatter {
  static String toDisplayDate(DateTime date, {String? locale}) =>
      DateFormat.yMMMd(locale).format(date);

  static String toDisplayDateTime(DateTime date, {String? locale}) =>
      DateFormat.yMMMd(locale).add_jm().format(date);

  static String toDisplayTime(DateTime date, {String? locale}) =>
      DateFormat.jm(locale).format(date);

  static String toIso8601(DateTime date) => date.toIso8601String();
}
