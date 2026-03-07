import 'dart:async';

class Throttler {
  final int defaultMilliseconds;
  Timer? _timer;
  bool _isThrottled = false;

  Throttler({required int milliseconds}) : defaultMilliseconds = milliseconds;

  void run(
    void Function() action, {
    int? throttleTime,
    bool immediate = false,
  }) {
    // If 'immediate' is true, we bypass the throttle check and reset the timer.
    if (immediate) {
      _execute(action, throttleTime);
      return;
    }

    // Standard throttle check: if we are in the cooldown period, do nothing.
    if (_isThrottled) return;

    _execute(action, throttleTime);
  }

  void _execute(void Function() action, int? throttleTime) {
    // 1. Run the action
    action();
    _isThrottled = true;

    // 2. Clear any existing cooldown timer
    _timer?.cancel();

    // 3. Start a new cooldown period
    final duration = Duration(
      milliseconds: throttleTime ?? defaultMilliseconds,
    );
    _timer = Timer(duration, () {
      _isThrottled = false;
    });
  }

  void dispose() {
    _timer?.cancel();
    _isThrottled = false;
  }
}
