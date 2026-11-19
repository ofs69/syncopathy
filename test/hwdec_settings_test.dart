import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:syncopathy/ioc.dart';
import 'package:syncopathy/model/json/settings.dart';
import 'package:syncopathy/model/settings_model.dart';
import 'package:syncopathy/player/hwdec_mode.dart';

/// Covers the hardware decoding setting: the values handed to mpv, how the
/// choice persists, and how a `--hwdec=` command line argument overrides it.
void main() {
  // A global, so it must not leak between tests.
  tearDown(() => hwdecOverride = null);

  group('HwdecMode', () {
    test('carries the literal values mpv expects', () {
      expect(HwdecMode.autoCopy.mpvValue, 'auto-copy');
      expect(HwdecMode.autoSafe.mpvValue, 'auto-safe');
      expect(HwdecMode.none.mpvValue, 'no');
    });
  });

  group('persistence', () {
    for (final (platform, expected) in [
      (TargetPlatform.windows, HwdecMode.autoSafe),
      (TargetPlatform.linux, HwdecMode.autoCopy),
      (TargetPlatform.macOS, HwdecMode.autoCopy),
    ]) {
      test(
        'uses the platform default for missing settings on ${platform.name}',
        () {
          debugDefaultTargetPlatformOverride = platform;
          addTearDown(() => debugDefaultTargetPlatformOverride = null);
          expect(Settings().hwdecMode, expected);
          expect(SettingsModel().effectiveHwdec.value, expected.mpvValue);
          final json = Settings(offsetMs: 123).toJson()..remove('hwdecMode');
          final restored = Settings.fromJson(json);
          expect(restored.hwdecMode, expected);
          expect(restored.offsetMs, 123);
          json['hwdecMode'] = 'autoCopy';
          expect(Settings.fromJson(json).hwdecMode, HwdecMode.autoCopy);
        },
      );
    }

    test('round-trips through json', () {
      final json = (Settings()..hwdecMode = HwdecMode.autoSafe).toJson();
      expect(Settings.fromJson(json).hwdecMode, HwdecMode.autoSafe);
    });

    test('falls back to copy-back for an unknown stored value', () {
      final json = Settings().toJson()..['hwdecMode'] = 'aRemovedMode';
      expect(Settings.fromJson(json).hwdecMode, HwdecMode.autoCopy);
    });
  });

  group('effectiveHwdec', () {
    test('follows the setting when no override is given', () {
      hwdecOverride = null;
      final settings = SettingsModel();

      expect(settings.effectiveHwdec.value, HwdecMode.recommended.mpvValue);

      settings.hwdecMode.value = HwdecMode.none;
      expect(settings.effectiveHwdec.value, 'no');
    });

    test('a command line override wins over the setting', () {
      hwdecOverride = 'vaapi';
      final settings = SettingsModel();
      settings.hwdecMode.value = HwdecMode.none;

      expect(settings.effectiveHwdec.value, 'vaapi');
    });
  });
}
