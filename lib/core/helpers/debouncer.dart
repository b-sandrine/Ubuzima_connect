import 'dart:async';

/// Delays invoking [action] until no new call has arrived for [duration] —
/// used for search-as-you-type fields across feature forms.
class Debouncer {
  final Duration duration;
  Timer? _timer;

  Debouncer({this.duration = const Duration(milliseconds: 400)});

  void run(void Function() action) {
    _timer?.cancel();
    _timer = Timer(duration, action);
  }

  void dispose() => _timer?.cancel();
}
