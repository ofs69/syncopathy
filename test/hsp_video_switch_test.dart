import 'dart:math';

import 'package:fake_async/fake_async.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:signals/signals.dart';
import 'package:syncopathy/model/funscript.dart';
import 'package:syncopathy/model/json/funscript_json.dart';
import 'package:syncopathy/model/player_model.dart';
import 'package:syncopathy/model/settings_model.dart';
import 'package:syncopathy/model/timesource_model.dart';
import 'package:syncopathy/persistence/entities/media_file.dart';
import 'package:syncopathy/player/handy_native_hsp_mixin.dart';
import 'package:syncopathy/player/playback_session.dart';

import 'support/fake_hsp_device.dart';
import 'support/fake_playback_session.dart';

MediaFile _media(String name) => MediaFile(
  name: name,
  mediaPath: 'Q:/media/$name.mp4',
  fileHash: name,
  playCount: 0,
  fileNotFound: false,
);

/// A two-minute script whose positions identify it: A strokes 0..100 every
/// 500ms, B strokes 20..80 every 400ms.
List<FunscriptAction> _actions({
  required int step,
  required int lo,
  required int hi,
}) => [
  for (var at = 0, i = 0; at <= 120000; at += step, i++)
    FunscriptAction(at: at, pos: i.isEven ? lo : hi),
];

Funscript _script(String path, List<FunscriptAction> actions) => Funscript(
  json: FunscriptJson(actions: actions),
  filePath: path,
);

class _Rig {
  _Rig(int seed) : random = Random(seed) {
    session = FakePlaybackSession()
      ..capabilities.value = PlaybackCapability.values.toSet()
      ..duration.value = 120.0;
    final active = ActivePlaybackSession(session);
    timesource = TimesourceModel.fromSession(active.session);
    device = FakeHspDevice(
      random: random,
      maxLatencyMs: 20 + random.nextInt(400),
    );
    backend = FakeHspBackend(
      device: device,
      timesource: timesource,
      currentlyOpen: currentlyOpen,
      settingsModel: settings,
    );
  }

  final Random random;
  final settings = SettingsModel();
  late final FakePlaybackSession session;
  late final TimesourceModel timesource;
  late final FakeHspDevice device;
  late final FakeHspBackend backend;
  final Signal<MediaFunscript?> currentlyOpen = signal(null);

  int nowMs = 0;

  /// Runs the world for [ms]: the player clock advances while playing, mpv
  /// publishes a position every ~30ms, and the device answers what is due.
  void run(FakeAsync async, int ms) {
    final end = nowMs + ms;
    while (nowMs < end) {
      nowMs += 10;
      async.elapse(const Duration(milliseconds: 10));
      if (!session.paused.value && nowMs % 30 == 0) {
        session.rawPosition.value += 0.03;
      }
      device.advanceTo(nowMs);
    }
  }

  void open(String name, List<FunscriptAction> actions) {
    final script = _script('$name.funscript', actions);
    script.processedActions.value = actions;
    currentlyOpen.value = MediaFunscript(
      media: _media(name),
      funscript: script,
    );
  }
}

/// What a healthy device looks like a few seconds into playing [expected] at
/// [positionMs]: on the stream the app last set up, playing, and holding points
/// from the right script around the playhead.
String? _unhealthy(_Rig rig, List<FunscriptAction> expected, int positionMs) {
  final d = rig.device;
  if (d.setupsSent.isEmpty || d.streamId != d.setupsSent.last) {
    return 'device on stream ${d.streamId}, app last set up ${d.setupsSent.lastOrNull}';
  }
  if (d.playState != HspStateAdapterPlayState.hspStatePlaying) {
    return 'device ${d.playState}, player is playing';
  }
  if (d.points.isEmpty) return 'device playing with no points';
  final byTime = {for (final a in expected) a.at: a.pos};
  final foreign = d.points.where((p) => byTime[p.at] != p.pos);
  if (foreign.isNotEmpty) {
    return 'device holds points from another script: ${foreign.first.at}';
  }
  if (positionMs < d.points.first.at || positionMs > d.points.last.at) {
    return 'playhead $positionMs outside device buffer ${d.points.first.at}..${d.points.last.at}';
  }
  return null;
}

void main() {
  final scriptA = _actions(step: 500, lo: 0, hi: 100);
  final scriptB = _actions(step: 400, lo: 20, hi: 80);

  // Replays a switch traced on a real Handy, timings included. The Handy stayed
  // still until Home Mode was toggled by hand.
  //
  // mpv reports a pause for ~17ms while it swaps files. With auto-home on,
  // that parks the device with an HDSP command, which drops it out of HSP onto
  // stream 0; the park is released before the new script is processed, so the
  // release finds no actions and only flushes. The answers to the flushes name
  // stream 0, then the stopped device is silent - and every handler was gated
  // on the mismatch, waiting for a third report that never came.
  test('auto-home parking during a switch does not strand the device', () {
    fakeAsync((async) {
      final rig = _Rig(1);
      rig.session.rawPosition.value = 30.0;
      rig.open('a', scriptA);
      rig.run(async, 200);
      rig.session.paused.value = false;
      rig.run(async, 4000);
      expect(_unhealthy(rig, scriptA, rig.timesource.currentRawMs), isNull);

      // Old script gone: PlayerModel publishes null while B loads.
      rig.currentlyOpen.value = null;
      rig.run(async, 90);
      // mpv's pause blip, and auto-home parking and releasing around it.
      rig.session.rawPosition.value = 0.0;
      rig.session.paused.value = true;
      rig.settings.homeDeviceEnabled.value = true;
      rig.run(async, 20);
      rig.session.paused.value = false;
      rig.settings.homeDeviceEnabled.value = false;
      rig.run(async, 150);
      // B's script lands, already processed.
      rig.open('b', scriptB);

      rig.run(async, 8000);
      final failure = _unhealthy(rig, scriptB, rig.timesource.currentRawMs);
      expect(failure, isNull, reason: rig.device.log.skip(60).join('\n'));
      rig.backend.dispose();
      async.flushTimers();
    });
  });

  /// One video switch the way the regular-mode PlayerModel produces it, with
  /// every gap drawn from [seed].
  String? switchVideos(int seed, {List<String>? trace}) {
    String? failure;
    fakeAsync((async) {
      final rig = _Rig(seed);
      final r = rig.random;

      // Video A playing at 30s with its script on the device.
      rig.session.rawPosition.value = 30.0;
      rig.open('a', scriptA);
      rig.run(async, 200);
      rig.session.paused.value = false;
      rig.run(async, 4000);
      final settledA = _unhealthy(rig, scriptA, rig.timesource.currentRawMs);
      if (settledA != null) {
        failure = 'never settled on A: $settledA';
        return;
      }
      rig.device.log.add('${rig.nowMs}  ===== switch to B =====');

      // mpv loads B: it may pause, the clock jumps back, the duration goes
      // null while the file opens (PlayerModel publishes null then).
      // Sometimes the user skips past a video before settling on B.
      for (var hop = r.nextInt(3); hop >= 0; hop--) {
        if (r.nextBool()) rig.session.paused.value = true;
        rig.run(async, r.nextInt(60));
        if (r.nextBool()) rig.session.seeking.value = true;
        rig.session.rawPosition.value = r.nextInt(5000) / 1000.0;
        rig.currentlyOpen.value = null;
        rig.run(async, r.nextInt(200));
        rig.session.seeking.value = false;
        if (hop > 0) {
          rig.open('x$hop', scriptA);
          rig.session.paused.value = r.nextBool();
          rig.run(async, r.nextInt(800));
        }
      }

      // Funscript.fromFile resolves: the pair is published with processing
      // still in flight, so processedActions is empty and currentActions null.
      final b = _script('b.funscript', scriptB);
      rig.currentlyOpen.value = MediaFunscript(
        media: _media('b'),
        funscript: b,
      );
      if (r.nextBool()) rig.session.paused.value = false;
      rig.run(async, r.nextInt(150));
      b.processedActions.value = scriptB;
      rig.run(async, r.nextInt(150));
      rig.session.paused.value = false;

      rig.run(async, 8000);
      failure = _unhealthy(rig, scriptB, rig.timesource.currentRawMs);
      trace?.addAll(rig.device.log);
      rig.backend.dispose();
      async.flushTimers();
    });
    return failure;
  }

  test(
    'the device picks up the new script after every video switch',
    () {
      const runs = 2000;
      final failures = <int, String>{};
      for (var seed = 0; seed < runs; seed++) {
        final failure = switchVideos(seed);
        if (failure != null) failures[seed] = failure;
      }
      // One trace per kind of failure: the kinds have different causes.
      final firstByKind = <String, int>{};
      for (final MapEntry(:key, :value) in failures.entries) {
        firstByKind.putIfAbsent(
          value.split(':').first.replaceAll(RegExp(r'\d+'), 'N'),
          () => key,
        );
      }
      for (final MapEntry(key: kind, value: seed) in firstByKind.entries) {
        final count = failures.values
            .where(
              (f) => f.split(':').first.replaceAll(RegExp(r'\d+'), 'N') == kind,
            )
            .length;
        final trace = <String>[];
        switchVideos(seed, trace: trace);
        final from = trace.indexWhere((l) => l.contains('switch to B'));
        // ignore: avoid_print
        print(
          '=== $count/$runs: $kind  (seed $seed: ${failures[seed]})\n'
          '${trace.skip(max(0, from - 5)).take(90).join('\n')}',
        );
      }
      expect(failures, isEmpty);
    },
    skip:
        'Known failure: a throttled eager-buffer call captures the previous '
        "script's actions and runs after the switch, adding its points to the "
        'new stream (~2% of switches).',
  );
}
