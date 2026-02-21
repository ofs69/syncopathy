import 'dart:async';

class Throttler {
  Throttler({required this.milliseconds});

  final int milliseconds;
  Timer? _timer;
  bool _isThrottled = false;

  void run(void Function() action) {
    if (!_isThrottled) {
      action();
      _isThrottled = true;
      _timer = Timer(
        Duration(milliseconds: milliseconds),
        () => _isThrottled = false,
      );
    }
  }

  void dispose() {
    _timer?.cancel();
  }
}
