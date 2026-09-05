import 'package:flutter_test/flutter_test.dart';
import 'package:syncopathy/model/json/settings.dart';
import 'package:syncopathy/model/settings_model.dart';
import 'package:syncopathy/player/handy_bluetooth_backend_base.dart';
import 'package:syncopathy/player/reconnect.dart';

/// Covers automatic reconnection after a lost Bluetooth connection: the retry
/// loop the Handy Bluetooth backend drives, and the setting that gates it.
void main() {
  group('retryUntilConnected', () {
    /// Drives the loop with a fake connect that reports success on
    /// [succeedOnAttempt] (never, when null), counting the attempts made.
    Future<({bool reconnected, int attempts, List<int> reported})> run({
      int? succeedOnAttempt,
      int maxAttempts = HandyBluetoothBackendBase.maxReconnectAttempts,
      bool Function(int attempts)? cancelAfter,
    }) async {
      var attempts = 0;
      var connected = false;
      final reported = <int>[];

      final reconnected = await retryUntilConnected(
        connect: () async {
          attempts++;
          if (succeedOnAttempt == attempts) connected = true;
        },
        isConnected: () => connected,
        isCancelled: () => cancelAfter?.call(attempts) ?? false,
        maxAttempts: maxAttempts,
        delay: Duration.zero,
        onAttempt: reported.add,
      );

      return (reconnected: reconnected, attempts: attempts, reported: reported);
    }

    test('spends the whole budget before giving up', () async {
      // A Handy does not only glitch: it gets switched off, put on the charger,
      // carried out of range. Two attempts covered the first case only.
      final result = await run();
      expect(result.attempts, HandyBluetoothBackendBase.maxReconnectAttempts);
      expect(result.reconnected, isFalse);
    });

    test('reports each attempt in order', () async {
      expect((await run()).reported, [1, 2, 3, 4, 5, 6]);
    });

    test('stops as soon as the connection is back', () async {
      final result = await run(succeedOnAttempt: 1);
      expect(result.attempts, 1);
      expect(result.reconnected, isTrue);
    });

    test('still succeeds on the last attempt of the budget', () async {
      final result = await run(succeedOnAttempt: 2);
      expect(result.attempts, 2);
      expect(result.reconnected, isTrue);
    });

    test('honours a larger budget', () async {
      final result = await run(succeedOnAttempt: 3, maxAttempts: 4);
      expect(result.attempts, 3);
      expect(result.reconnected, isTrue);
    });

    test('does not connect at all once cancelled', () async {
      final result = await run(cancelAfter: (_) => true);
      expect(result.attempts, 0);
      expect(result.reconnected, isFalse);
    });

    test('gives up mid-budget when cancelled after an attempt', () async {
      // Disposing the backend (manual disconnect, backend switch, shutdown)
      // must not leave a retry scanning in the background.
      final result = await run(cancelAfter: (attempts) => attempts >= 1);
      expect(result.attempts, 1);
      expect(result.reconnected, isFalse);
    });

    /// Records how long the loop waited before each attempt.
    Future<List<Duration>> waitsBefore({
      required Duration delay,
      Duration? maxDelay,
      int maxAttempts = 5,
    }) async {
      final waits = <Duration>[];
      var last = DateTime.now();
      await retryUntilConnected(
        connect: () async {
          final now = DateTime.now();
          waits.add(now.difference(last));
          last = now;
        },
        isConnected: () => false,
        isCancelled: () => false,
        maxAttempts: maxAttempts,
        delay: delay,
        maxDelay: maxDelay,
      );
      return waits;
    }

    test('waits the same short gap when no ceiling is given', () async {
      final waits = await waitsBefore(
        delay: const Duration(milliseconds: 20),
        maxAttempts: 3,
      );
      for (final wait in waits) {
        expect(wait.inMilliseconds, lessThan(60));
      }
    });

    test('backs off between attempts, up to the ceiling', () async {
      // The early attempts catch a link that merely glitched; the later ones
      // keep watch for a device that is off, without scanning continuously for
      // as long as it stays off.
      final waits = await waitsBefore(
        delay: const Duration(milliseconds: 20),
        maxDelay: const Duration(milliseconds: 80),
      );

      expect(waits.length, 5);
      // 20, 40, 80, then held at the ceiling.
      expect(waits[1], greaterThan(waits[0]));
      expect(waits[2], greaterThan(waits[1]));
      expect(waits[4].inMilliseconds, lessThan(160));
    });
  });

  group('autoReconnect setting', () {
    test('is off by default', () {
      expect(Settings().autoReconnect, isFalse);
      expect(SettingsModel().autoReconnect.value, isFalse);
    });

    test('round-trips through json', () {
      final json = (Settings()..autoReconnect = true).toJson();
      expect(Settings.fromJson(json).autoReconnect, isTrue);
    });

    test('falls back to off when the stored value is missing', () {
      final json = Settings().toJson()..remove('autoReconnect');
      expect(Settings.fromJson(json).autoReconnect, isFalse);
    });
  });
}
