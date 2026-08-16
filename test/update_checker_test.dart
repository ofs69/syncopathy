import 'package:flutter_test/flutter_test.dart';
import 'package:syncopathy/update_checker.dart';

void main() {
  group('UpdateChecker.notifyIfUpdateAvailable', () {
    test('adds an alert when an update is available', () async {
      String? alert;

      await UpdateChecker.notifyIfUpdateAvailable(
        check: () async => 'v2.0.0+1',
        notify: (message) => alert = message,
      );

      expect(alert, 'A new Syncopathy version is available: v2.0.0+1');
    });

    test('stays silent when no update is available', () async {
      String? alert;

      await UpdateChecker.notifyIfUpdateAvailable(
        check: () async => null,
        notify: (message) => alert = message,
      );

      expect(alert, isNull);
    });
  });
}
