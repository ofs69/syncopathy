import 'dart:async';
import 'dart:io';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:libmpv_dart/libmpv.dart';
import 'package:path_provider/path_provider.dart';
import 'package:signals/signals_flutter.dart';
import 'package:syncopathy/events/event_bus.dart';
import 'package:syncopathy/events/event_subscriber_mixin.dart';
import 'package:syncopathy/events/player_event.dart';
import 'package:syncopathy/funscript_algo.dart';
import 'package:syncopathy/helper/effect_dispose_mixin.dart';
import 'package:syncopathy/model/playlist_model.dart';
import 'package:syncopathy/sqlite/models/video_model.dart';
import 'package:path/path.dart' as p;

class SmoothVideoSignals with EffectDispose {
  final ReadonlySignal<double> rawPosition;
  final ReadonlySignal<bool> isPaused;
  final ReadonlySignal<double> playbackSpeed;

  final _frameTick = signal(DateTime.now());
  late final Ticker _ticker;
  DateTime _lastUpdateWallClock = DateTime.now();

  late final ReadonlySignal<double> smoothPosition;

  SmoothVideoSignals(this.rawPosition, this.isPaused, this.playbackSpeed) {
    _ticker = Ticker((_) => _frameTick.value = DateTime.now());

    smoothPosition = computed(() {
      final pos = rawPosition.value;
      final playing = !isPaused.value;
      final speed = playbackSpeed.value;
      final now = _frameTick.value;

      if (!playing) return pos;

      // Calculate real-world time passed
      final wallClockDrift =
          now.difference(_lastUpdateWallClock).inMilliseconds / 1000.0;

      // Adjust drift based on playback speed
      final adjustedDrift = wallClockDrift * speed;
      final smoothTime = pos + adjustedDrift;
      if (smoothTime < 0.0) {
        return pos;
      }
      return smoothTime;
    });

    effectAdd([
      effect(() {
        update(rawPosition.value, !isPaused.value, playbackSpeed.value);
      }),
    ]);
  }

  void dispose() {
    effectDispose();
    _ticker.dispose();
  }

  // Update this from your VideoPlayerController listener
  void update(double newPos, bool playing, double speed) {
    _lastUpdateWallClock = DateTime.now();

    if (playing && !_ticker.isTicking) _ticker.start();
    if (!playing && _ticker.isTicking) _ticker.stop();
  }
}

class MpvVideoplayer with EventSubscriber, EffectDispose {
  late Player _player;

  late final ReadonlySignal<int> textureId;
  late final ReadonlySignal<double> volume;
  late final ReadonlySignal<double> duration;
  late final ReadonlySignal<double> playbackSpeed;
  late final ReadonlySignal<bool> paused;

  late final SmoothVideoSignals _smoothVideoSignals;
  ReadonlySignal<double> get smoothPosition =>
      _smoothVideoSignals.smoothPosition;
  ReadonlySignal<double> get rawPosition => _smoothVideoSignals.rawPosition;

  late final ReadonlySignal<VideoParams> videoParams;
  late final ReadonlySignal<bool> loopFile;
  late final ReadonlySignal<String> loadedPath;
  late final ReadonlySignal<String> playlist;

  late final ReadonlySignal<PlaylistModel> currentPlaylist;
  final Signal<bool> _playlistShuffled = signal(false);
  ReadonlySignal<bool> get playlistShuffled => _playlistShuffled;

  // TODO: remove _previouslyLoadedVideos and find a better way to resolve the filename from the playlist back to a video
  final Signal<List<Video>> _previouslyLoadedVideos = listSignal([]);
  late final ReadonlySignal<Video?> currentVideo;

  MpvVideoplayer({required bool videoOutput}) {
    _player = Player(
      {
        'config': 'yes',
        'config-dir': '',
        'input-default-bindings': 'yes',
        'vo': 'gpu-next',
        'osc': 'yes',
        'hwdec': 'auto-safe',
        'border': 'yes',
        'geometry': "1280x720",
        'idle': 'yes',
        'force-window': 'yes',
      },
      videoOutput: videoOutput,
      initialize: true,
    );

    _player.setPropertyString('keep-open', 'yes');
    _player.setPropertyString('loop-file', 'no');
    _player.setPropertyString('loop-playlist', 'inf');
    _player.setPropertyString("pause", 'yes');
    _player.setPropertyDouble("volume", 100.0);

    _player.command(["keybind", "CLOSE_WIN", "ignore"]);
    _player.command(["keybind", "q", "ignore"]);

    textureId = _player.id.toSignal();
    volume = _player.volume.toSignal();
    duration = _player.duration.toSignal();
    playbackSpeed = _player.speed.toSignal();
    paused = _player.paused.toSignal();
    videoParams = _player.videoParams.toSignal();
    loopFile = _player.loopFile.toSignal();
    loadedPath = _player.path.toSignal();
    playlist = _player.playlist.toSignal();
    currentPlaylist = computed(() => PlaylistModel.fromJson(playlist.value));
    currentVideo = computed(() {
      final playlist = currentPlaylist.value;
      final entry = playlist.currentPlaylistItem.value;
      final filename = entry?.filename;
      final video = _previouslyLoadedVideos.value.firstWhereOrNull(
        (v) => v.videoPath == filename,
      );
      return video;
    });

    _smoothVideoSignals = SmoothVideoSignals(
      _player.position.toSignal(),
      paused,
      playbackSpeed,
    );

    eventSubs([
      Events.on<OpenVideoEvent>().listen((ev) async {
        // If a playlist is currently open try to find the video and set the index
        final playlist = currentPlaylist.value;
        final video = ev.video;
        final index = playlist.getIndexForVideo(video);
        if (index >= 0 && index < playlist.entries.length) {
          _player.setPropertyInt64('playlist-pos', index);
          return;
        }

        // Open video as a playlist with one video
        Events.emit(OpenPlaylistEvent([ev.video]));
      }),
      Events.on<CloseMediaEvent>().listen((_) async {
        await _closeFile();
      }),
      Events.on<OpenPlaylistEvent>().listen(_onOpenPlaylist),
      Events.on<PlaylistPreviousEvent>().listen(_onPlaylistPrevious),
      Events.on<PlaylistNextEvent>().listen(_onPlaylistNext),
      Events.on<PlaylistSetShuffleEvent>().listen(_onPlaylistShuffle),
      loadedPath.toStream().listen(_onPathChange),
    ]);
  }

  void _onPathChange(String newPath) {
    debugPrint(newPath);
  }

  Future<void> _onOpenPlaylist(OpenPlaylistEvent event) async {
    if (event.videos.isEmpty) return;
    _previouslyLoadedVideos.value = event.videos;
    final playlistFile = await _createPlaylistM3U(event.videos);
    if (playlistFile != null) _loadList(playlistFile, 'replace');
  }

  void _onPlaylistPrevious(PlaylistPreviousEvent event) {
    final playlist = currentPlaylist.value;
    final newIndex = (playlist.currentIndex.value - 1).clamp(
      0,
      playlist.entries.length - 1,
    );

    if (newIndex != playlist.currentIndex.value) {
      _player.setPropertyInt64('playlist-pos', newIndex);
    }
  }

  void _onPlaylistNext(PlaylistNextEvent event) {
    final playlist = currentPlaylist.value;
    final newIndex = (playlist.currentIndex.value + 1).clamp(
      0,
      playlist.entries.length - 1,
    );

    if (newIndex != playlist.currentIndex.value) {
      _player.setPropertyInt64('playlist-pos', newIndex);
    }
  }

  Future<String?> _createPlaylistM3U(List<Video> videos) async {
    final directory = await getApplicationSupportDirectory();
    final file = File(p.join(directory.path, 'playlist.m3u'));
    final sink = file.openWrite(mode: FileMode.write);

    try {
      // Write the header
      sink.writeln('#EXTM3U');
      for (var v in videos) {
        sink.writeln(v.videoPath);
      }
    } catch (e) {
      return null;
    } finally {
      await sink.close();
    }

    return file.path;
  }

  void _loadList(String playlistFile, String mode) {
    final _ = _player.command(["loadlist", playlistFile, mode]);
    _playlistShuffled.value = false;
  }

  Future<bool> _loadFile(String filepath, String mode) async {
    final _ = _player.command(["loadfile", filepath, mode]);
    return true;
  }

  Future<void> _closeFile() async {
    _player.command(["stop"]);
    _player.path.value = "";
    _player.duration.value = 0.0;
    _playlistShuffled.value = false;
  }

  void dispose() {
    eventDispose();
    effectDispose();
    _player.destroy();
    _smoothVideoSignals.dispose();
  }

  // void bringToFront() async {
  //   _player.setPropertyString("ontop", "yes");
  //   await Future.delayed(Duration(microseconds: 100));
  //   _player.setPropertyString("ontop", "no");
  // }

  void toggleLooping() =>
      _player.setPropertyString('loop-file', loopFile.value ? 'no' : 'inf');

  void setSizeAndPosition(int width, int height, int x, int y) =>
      _player.setPropertyString("geometry", "${width}x$height+$x+$y");

  void _seekToRelative(double positionPercent) => _player.command([
    "seek",
    (positionPercent * 100.0).toString(),
    "absolute-percent+exact",
  ]);

  void seekTo(Duration seek) => _seekToRelative(
    ((seek.inMilliseconds.toDouble() / 1000.0) / duration.value).clamp(
      0.0,
      1.0,
    ),
  );

  void setSpeed(double speed) => _player.command([
    "set",
    "speed",
    speed.clamp(0.5, 2.0).toStringAsPrecision(3),
  ]);

  void setVolume(double volume) =>
      _player.setPropertyDouble('volume', volume.clamp(0, 130));

  void togglePause() => _player.setPropertyFlag('pause', !paused.value);

  void _onPlaylistShuffle(PlaylistSetShuffleEvent event) {
    if (playlistShuffled.value != event.shuffle) {
      if (event.shuffle) {
        _player.command(['playlist-shuffle']);
      } else {
        _player.command(['playlist-unshuffle']);
      }
      _playlistShuffled.value = event.shuffle;
    }
  }
}
