import 'dart:async';

class Throttler {
  final int defaultMilliseconds;
  Timer? _timer;
  bool _isThrottled = false;
  void Function()? _pendingAction;

  Throttler({required int milliseconds}) : defaultMilliseconds = milliseconds;

  void run(void Function() action, {int? throttleTime}) {
    if (_isThrottled) {
      // If we are throttled, save this as the "latest" action to run later.
      _pendingAction = action;
      return;
    }

    // Execute immediately (Leading edge)
    _execute(action, throttleTime);
  }

  void _execute(void Function() action, int? throttleTime) {
    action();
    _isThrottled = true;
    _pendingAction = null;

    _startTimer(throttleTime);
  }

  void _startTimer(int? throttleTime) {
    _timer?.cancel();

    final duration = Duration(
      milliseconds: throttleTime ?? defaultMilliseconds,
    );

    _timer = Timer(duration, () {
      _isThrottled = false;

      // Trailing edge: If an action was attempted during the cooldown,
      // run it now and restart the throttle period.
      if (_pendingAction != null) {
        _execute(_pendingAction!, throttleTime);
      }
    });
  }

  void dispose() {
    _timer?.cancel();
    _pendingAction = null;
    _isThrottled = false;
  }
}
