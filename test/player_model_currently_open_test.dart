import 'package:flutter_test/flutter_test.dart';
import 'package:syncopathy/ioc.dart';
import 'package:syncopathy/model/battery_model.dart';
import 'package:syncopathy/model/funscript.dart';
import 'package:syncopathy/model/json/funscript_json.dart';
import 'package:syncopathy/model/player_model.dart';
import 'package:syncopathy/model/settings_model.dart';
import 'package:syncopathy/model/timesource_model.dart';
import 'package:syncopathy/persistence/entities/media_file.dart';
import 'package:syncopathy/player/playback_session.dart';

import 'support/fake_playback_session.dart';

MediaFile _media(String name) => MediaFile(
  name: name,
  mediaPath: 'Q:/media/$name.mp4',
  fileHash: name,
  playCount: 0,
  fileNotFound: false,
);

Funscript _script(String path) => Funscript(
  json: FunscriptJson(
    actions: [
      FunscriptAction(at: 0, pos: 0),
      FunscriptAction(at: 500, pos: 100),
      FunscriptAction(at: 1000, pos: 0),
    ],
  ),
  filePath: path,
);

/// [PlayerModel.currentlyOpen] used to be a computed that read the session's
/// media untracked, so it only ever recomputed when the funscript signal
/// changed. Media that changed underneath a reused script never reached it, and
/// everything downstream — the app bar, the library's "now playing" marker, view
/// counting — went on naming the previous entry.
void main() {
  late PlayerModel model;
  late FakePlaybackSession session;

  setUp(() {
    syncopathySimpleMode = true;
    session = FakePlaybackSession();
    final active = ActivePlaybackSession(session);
    model = PlayerModel(
      SettingsModel(),
      TimesourceModel.fromSession(active.session),
      active.session,
      BatteryModel(),
    );
    session.duration.value = 120.0;
  });

  tearDown(() {
    model.dispose();
    syncopathySimpleMode = false;
  });

  test('pairs the open media with its script', () async {
    model.simpleModeFunscript.value = _script('a.funscript');
    session.currentMedia.value = _media('a');
    await Future<void>.delayed(Duration.zero);

    expect(model.currentlyOpen.value?.media.name, 'a');
    expect(model.currentlyOpen.value?.funscript.filePath, 'a.funscript');
  });

  test('follows the session onto new media, script instance unchanged', () async {
    final script = _script('shared.funscript');
    model.simpleModeFunscript.value = script;
    session.currentMedia.value = _media('a');
    await Future<void>.delayed(Duration.zero);
    expect(model.currentlyOpen.value?.media.name, 'a');

    // The regression: the same script instance stays put, so the funscript
    // signal never notifies. Only the media moved.
    session.currentMedia.value = _media('b');
    await Future<void>.delayed(Duration.zero);

    expect(
      model.currentlyOpen.value?.media.name,
      'b',
      reason: 'currentlyOpen kept the media it was first built with',
    );
    expect(model.currentlyOpen.value?.funscript, same(script));
  });

  test('clears when the session closes its media', () async {
    model.simpleModeFunscript.value = _script('a.funscript');
    session.currentMedia.value = _media('a');
    await Future<void>.delayed(Duration.zero);
    expect(model.currentlyOpen.value, isNotNull);

    session.currentMedia.value = null;
    await Future<void>.delayed(Duration.zero);

    expect(model.currentlyOpen.value, isNull);
  });

  test('never pairs media with a script belonging to nothing', () async {
    session.currentMedia.value = _media('a');
    await Future<void>.delayed(Duration.zero);

    // Media is open but no script has been chosen for it yet.
    expect(model.currentlyOpen.value, isNull);
  });
}
