import 'package:flutter_test/flutter_test.dart';
import 'package:syncopathy/model/auto_home.dart';
import 'package:syncopathy/model/home_target.dart';
import 'package:syncopathy/model/json/settings.dart';
import 'package:syncopathy/model/settings_model.dart';

/// Covers "Home on pause": the ownership rules that decide when playback state
/// may drive Home Mode, plus the two settings behind the feature.
void main() {
  group('AutoHomeController', () {
    late AutoHomeController controller;
    var homeEnabled = false;

    /// Feeds one state change through the controller and applies its answer,
    /// mirroring what the effect in PlayerModel does.
    void update({bool autoHomeOnPause = true, required bool paused}) {
      final next = controller.nextHomeState(
        autoHomeOnPause: autoHomeOnPause,
        paused: paused,
        homeEnabled: homeEnabled,
      );
      if (next != null) homeEnabled = next;
    }

    /// The user reaching for the home button or its shortcut. The effect
    /// tracks the flag, so the controller sees the change on the next run.
    void userToggles({bool autoHomeOnPause = true, required bool paused}) {
      homeEnabled = !homeEnabled;
      update(autoHomeOnPause: autoHomeOnPause, paused: paused);
    }

    setUp(() {
      controller = AutoHomeController();
      homeEnabled = false;
      // The first evaluation only establishes a baseline; start from playing
      // so the tests below describe transitions rather than startup.
      update(paused: false);
    });

    test('leaves Home Mode alone while the setting is off', () {
      update(autoHomeOnPause: false, paused: true);
      expect(homeEnabled, isFalse);
      expect(controller.engaged.value, isFalse);
    });

    test('parks on pause and releases on resume', () {
      update(paused: true);
      expect(homeEnabled, isTrue);
      expect(controller.engaged.value, isTrue);

      update(paused: false);
      expect(homeEnabled, isFalse);
      expect(controller.engaged.value, isFalse);
    });

    test('parks again on the next pause', () {
      update(paused: true);
      update(paused: false);
      update(paused: true);
      expect(homeEnabled, isTrue);
      expect(controller.engaged.value, isTrue);
    });

    test('does not seize the device on the first evaluation', () {
      final fresh = AutoHomeController();
      expect(
        fresh.nextHomeState(
          autoHomeOnPause: true,
          paused: true,
          homeEnabled: false,
        ),
        isNull,
      );
      expect(fresh.engaged.value, isFalse);
    });

    test('parks when the setting is switched on during a pause', () {
      update(autoHomeOnPause: false, paused: true);
      expect(homeEnabled, isFalse);

      update(paused: true);
      expect(homeEnabled, isTrue);
      expect(controller.engaged.value, isTrue);
    });

    test('does not claim a park the user made themselves', () {
      userToggles(paused: false);
      expect(homeEnabled, isTrue);
      expect(controller.engaged.value, isFalse);

      update(paused: true);
      expect(controller.engaged.value, isFalse);

      // Resuming must not undo what the user switched on by hand.
      update(paused: false);
      expect(homeEnabled, isTrue);
    });

    test('keeps a park the user switched on again mid-pause', () {
      update(paused: true);
      expect(controller.engaged.value, isTrue);

      // Off, then on again: the second tap makes the park theirs.
      userToggles(paused: true);
      expect(homeEnabled, isFalse);
      userToggles(paused: true);
      expect(homeEnabled, isTrue);
      expect(controller.engaged.value, isFalse);

      update(paused: false);
      expect(homeEnabled, isTrue);
    });

    test('does not re-park after the user releases it mid-pause', () {
      update(paused: true);
      userToggles(paused: true);
      expect(homeEnabled, isFalse);

      // Nothing else changed, so the release stands.
      update(paused: true);
      expect(homeEnabled, isFalse);
      expect(controller.engaged.value, isFalse);
    });

    test('releases its own park when the setting is switched off', () {
      update(paused: true);
      update(autoHomeOnPause: false, paused: true);
      expect(homeEnabled, isFalse);
      expect(controller.engaged.value, isFalse);
    });

    test('leaves a manual park in place when the setting is switched off', () {
      userToggles(paused: false);
      update(paused: true);
      update(autoHomeOnPause: false, paused: true);
      expect(homeEnabled, isTrue);
    });

    test('re-parking is idempotent while paused', () {
      update(paused: true);
      expect(
        controller.nextHomeState(
          autoHomeOnPause: true,
          paused: true,
          homeEnabled: true,
        ),
        isNull,
      );
      expect(controller.engaged.value, isTrue);
    });
  });

  group('autoHomeOnPause setting', () {
    test('is off by default', () {
      expect(Settings().autoHomeOnPause, isFalse);
      expect(SettingsModel().autoHomeOnPause.value, isFalse);
    });

    test('round-trips through json', () {
      final json = (Settings()..autoHomeOnPause = true).toJson();
      expect(Settings.fromJson(json).autoHomeOnPause, isTrue);
    });

    test('falls back to off when the stored value is missing', () {
      final json = Settings().toJson()..remove('autoHomeOnPause');
      expect(Settings.fromJson(json).autoHomeOnPause, isFalse);
    });
  });

  group('homeMoveDurationMs setting', () {
    test('defaults to the shared park duration', () {
      expect(Settings().homeMoveDurationMs, HomeTarget.defaultMoveDurationMs);
      expect(
        SettingsModel().homeMoveDurationMs.value,
        HomeTarget.defaultMoveDurationMs,
      );
    });

    test('round-trips through json', () {
      final json = (Settings()..homeMoveDurationMs = 1500).toJson();
      expect(Settings.fromJson(json).homeMoveDurationMs, 1500);
    });

    test('falls back to the default when the stored value is missing', () {
      final json = Settings().toJson()..remove('homeMoveDurationMs');
      expect(
        Settings.fromJson(json).homeMoveDurationMs,
        HomeTarget.defaultMoveDurationMs,
      );
    });

    test('the default sits inside the configurable range', () {
      expect(
        HomeTarget.defaultMoveDurationMs,
        inInclusiveRange(
          HomeTarget.minMoveDurationMs,
          HomeTarget.maxMoveDurationMs,
        ),
      );
    });
  });
}
