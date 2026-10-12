import 'dart:async';
import 'package:flutter/foundation.dart'; // For VoidCallback

class Debouncer {
  final int milliseconds;
  Timer? _timer;
  bool _isWaiting = false;

  Debouncer({required this.milliseconds});

  void run(VoidCallback action, {bool leading = false}) {
    // If leading is true and we aren't in a waiting period, execute immediately
    if (leading && !_isWaiting) {
      action();
      _isWaiting = true;

      // Start a guard timer to reset the leading edge state
      _timer?.cancel();
      _timer = Timer(Duration(milliseconds: milliseconds), () {
        _isWaiting = false;
      });
      return;
    }

    // Standard trailing edge behavior
    _timer?.cancel();
    _timer = Timer(Duration(milliseconds: milliseconds), () {
      action();
      _isWaiting = false;
    });
  }

  /// Drops a pending trailing call, so a value it captured cannot be acted on
  /// after it stopped being true.
  void cancel() {
    _timer?.cancel();
    _timer = null;
    _isWaiting = false;
  }

  void dispose() => cancel();
}
