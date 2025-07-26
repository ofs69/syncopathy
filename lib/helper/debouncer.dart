import 'dart:async';
import 'package:flutter/foundation.dart'; // For VoidCallback

class Debouncer {
  final int milliseconds;
  Timer? _timer;

  Debouncer({required this.milliseconds});

  // The 'action' is the function you want to run after the delay.
  void run(VoidCallback action) {
    // If a timer is already active, cancel it.
    _timer?.cancel();
    // Start a new timer. The action will be executed after the specified duration.
    _timer = Timer(Duration(milliseconds: milliseconds), action);
  }

  // It's a good practice to dispose of the timer when it's no longer needed.
  void dispose() {
    _timer?.cancel();
  }
}
