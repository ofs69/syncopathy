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

    test('retries twice before giving up', () async {
      final result = await run();
      expect(result.attempts, 2);
      expect(result.reconnected, isFalse);
    });

    test('reports each attempt in order', () async {
      expect((await run()).reported, [1, 2]);
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
