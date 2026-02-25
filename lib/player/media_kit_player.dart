import 'dart:async';
import 'dart:io';

import 'package:collection/collection.dart';
import 'package:flutter/scheduler.dart';
import 'package:media_kit/media_kit.dart';
import 'package:path_provider/path_provider.dart';
import 'package:signals/signals_flutter.dart';
import 'package:syncopathy/events/event_bus.dart';
import 'package:syncopathy/events/event_subscriber_mixin.dart';
import 'package:syncopathy/events/player_event.dart';
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

class MediaKitPlayer with EventSubscriber, EffectDispose {
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
  late final ReadonlySignal<Playlist> playlist;

  late final ReadonlySignal<PlaylistModel> currentPlaylist;
  final Signal<bool> _playlistShuffled = signal(false);
  ReadonlySignal<bool> get playlistShuffled => _playlistShuffled;

  // TODO: remove _previouslyLoadedVideos and find a better way to resolve the filename from the playlist back to a video
  final Signal<List<Video>> _previouslyLoadedVideos = listSignal([]);
  late final ReadonlySignal<Video?> currentVideo;

  MediaKitPlayer({required bool videoOutput}) {
    _player = Player(
      configuration: const PlayerConfiguration(
        // This tells libmpv to handle its own windowing
        osc: true,
        vo: 'gpu-next'
      ),
    );

    NativePlayer? nativePlayer;
    if (_player.platform is NativePlayer) {
      nativePlayer = _player.platform as NativePlayer;
    }

    // _player = Player(
    //   {
    //     'config': 'yes',
    //     'config-dir': '',
    //     'input-default-bindings': 'yes',
    //     'vo': 'gpu-next',
    //     'osc': 'yes',
    //     'hwdec': 'auto-safe',
    //     'border': 'yes',
    //     'geometry': "1280x720",
    //     'idle': 'yes',
    //     'force-window': 'yes',
    //   },
    //   videoOutput: videoOutput,
    //   initialize: true,
    // );

    nativePlayer?.setProperty('keep-open', 'yes');
    nativePlayer?.setProperty('loop-file', 'no');
    nativePlayer?.setProperty('loop-playlist', 'inf');
    nativePlayer?.setProperty("pause", 'yes');
    nativePlayer?.setProperty("volume", "100.0");

    nativePlayer?.command(["keybind", "CLOSE_WIN", "ignore"]);
    nativePlayer?.command(["keybind", "q", "ignore"]);
    textureId = signal(0); //_player.id.toSignal();
    volume = _player.stream.volume.toSyncSignal(100);
    duration = _player.stream.duration
        .map((d) => d.inMilliseconds / 1000.0)
        .toSyncSignal(0);
    playbackSpeed = _player.stream.rate.toSyncSignal(1);
    paused = _player.stream.playing
        .map((p) => !p)
        .toSyncSignal(!_player.state.playing);
    videoParams = _player.stream.videoParams.toSyncSignal(
      _player.state.videoParams,
    );
    loopFile = _player.stream.playlistMode
        .map((mode) => mode == PlaylistMode.single)
        .toSyncSignal(_player.state.playlistMode == PlaylistMode.single);

    playlist = _player.stream.playlist.toSyncSignal(_player.state.playlist);
    loadedPath = computed(() {
      final currentPlaylist = playlist.value;
      final index = currentPlaylist.index;
      if (index >= 0 && currentPlaylist.medias.length < index) {
        return currentPlaylist.medias[index].uri;
      }
      return "";
    });
    currentPlaylist = computed(() {
      final currentPlaylist = playlist.value;
      final currentIndex = currentPlaylist.index;
      int counter = 0;
      final entries = currentPlaylist.medias.map((media) {
        final item = PlaylistItem(counter, media.uri, currentIndex == counter);
        counter += 1;
        return item;
      }).toList();
      return PlaylistModel(entries);
    });
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
      _player.stream.position
          .map((d) => d.inMilliseconds / 1000.0)
          .toSyncSignal(_player.state.position.inMilliseconds / 1000.0),
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
          _player.jump(index);
          //_player.setPropertyInt64('playlist-pos', index);
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
    // debugPrint(newPath);
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
      _player.jump(newIndex);
    }
  }

  void _onPlaylistNext(PlaylistNextEvent event) {
    final playlist = currentPlaylist.value;
    final newIndex = (playlist.currentIndex.value + 1).clamp(
      0,
      playlist.entries.length - 1,
    );

    if (newIndex != playlist.currentIndex.value) {
      _player.jump(newIndex);
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
    //final _ = _player.command(["loadlist", playlistFile, mode]);
    _player.open(Media(playlistFile));
    _playlistShuffled.value = false;
  }

  // ignore: unused_element
  Future<bool> _loadFile(String filepath, String mode) async {
    //final _ = _player.command(["loadfile", filepath, mode]);
    return true;
  }

  Future<void> _closeFile() async {
    await _player.stop();
    // _player.command(["stop"]);
    // _player.path.value = "";
    // _player.duration.value = 0.0;
    _playlistShuffled.value = false;
  }

  void dispose() async {
    eventDispose();
    effectDispose();
    await _player.dispose();
    _smoothVideoSignals.dispose();
  }

  // void bringToFront() async {
  //   _player.setPropertyString("ontop", "yes");
  //   await Future.delayed(Duration(microseconds: 100));
  //   _player.setPropertyString("ontop", "no");
  // }

  void screenshot(String path) async {
    //_player.command(["screenshot-to-file", path, "video"]);
    final buffer = await _player.screenshot();
    if (buffer != null) {
      File(path).writeAsBytesSync(buffer.toList());
    }
  }

  void toggleLooping() {
    if (_player.state.playlistMode == PlaylistMode.loop) {
      _player.setPlaylistMode(PlaylistMode.single);
    } else {
      _player.setPlaylistMode(PlaylistMode.loop);
    }
  }

  //_player.setPropertyString('loop-file', loopFile.value ? 'no' : 'inf');
  void setSizeAndPosition(int width, int height, int x, int y) {
    // =>
    //   _player.setPropertyString("geometry", "${width}x$height+$x+$y");
    throw UnimplementedError();
  }

  void _seekToRelative(double positionPercent) {
    _player.seek(
      Duration(milliseconds: ((duration * 1000.0) * positionPercent).round()),
    );
  }
  // => _player.command([
  //   "seek",
  //   (positionPercent * 100.0).toString(),
  //   "absolute-percent+exact",
  // ]);

  void seekTo(Duration seek) => _player.seek(seek);

  void setSpeed(double speed) => _player.setRate(speed.clamp(0.5, 2.0));
  // .command([
  //   "set",
  //   "speed",
  //   speed.clamp(0.5, 2.0).toStringAsPrecision(3),
  // ]);

  void setVolume(double volume) => _player.setVolume(volume.clamp(0, 130));
  //      _player.setPropertyDouble('volume', volume.clamp(0, 130));

  void togglePause() =>
      _player.playOrPause(); // _player.setPropertyFlag('pause', !paused.value);

  void _onPlaylistShuffle(PlaylistSetShuffleEvent event) {
    throw UnimplementedError();
    if (playlistShuffled.value != event.shuffle) {
      if (event.shuffle) {
        //_player.command(['playlist-shuffle']);
      } else {
        //_player.command(['playlist-unshuffle']);
      }
      _playlistShuffled.value = event.shuffle;
    }
  }
}
