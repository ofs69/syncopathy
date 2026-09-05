/// Retries [connect] until the connection is back or the attempts run out.
///
/// Waits before every attempt — including the first — so the BLE stack can
/// finish tearing the dropped link down and the device can start advertising
/// again. The wait starts at [delay] and, when [maxDelay] is given, doubles
/// after each failure up to it: the early attempts catch a link that merely
/// glitched, and the later ones keep watch for a device that was switched off
/// without scanning continuously for as long as it stays off.
///
/// [isCancelled] is checked around each await: a connect attempt can take tens
/// of seconds, and the backend may be disposed (backend switch, manual
/// disconnect, shutdown) while one is in flight.
///
/// Returns true if [isConnected] reports a connection, false if the attempts
/// were spent or the retry was cancelled.
Future<bool> retryUntilConnected({
  required Future<void> Function() connect,
  required bool Function() isConnected,
  required bool Function() isCancelled,
  required int maxAttempts,
  required Duration delay,
  Duration? maxDelay,
  void Function(int attempt)? onAttempt,
}) async {
  var wait = delay;
  for (var attempt = 1; attempt <= maxAttempts; attempt++) {
    if (isCancelled() || isConnected()) break;

    onAttempt?.call(attempt);
    await Future.delayed(wait);
    if (isCancelled()) return false;

    await connect();
    if (isCancelled()) return false;
    if (isConnected()) return true;

    if (maxDelay != null) {
      final next = wait * 2;
      wait = next > maxDelay ? maxDelay : next;
    }
  }
  return !isCancelled() && isConnected();
}
