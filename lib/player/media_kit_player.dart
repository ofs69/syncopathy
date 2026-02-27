import 'dart:async';
import 'dart:io';

import 'package:collection/collection.dart';
import 'package:flutter/scheduler.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart' hide Video;
import 'package:signals/signals_flutter.dart';
import 'package:syncopathy/events/event_bus.dart';
import 'package:syncopathy/events/event_subscriber_mixin.dart';
import 'package:syncopathy/events/player_event.dart';
import 'package:syncopathy/helper/effect_dispose_mixin.dart';
import 'package:syncopathy/model/playlist_model.dart';
import 'package:syncopathy/model/video.dart';

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
  late final VideoController? controller;

  late final ReadonlySignal<double> volume;
  late final ReadonlySignal<double> duration;
  late final ReadonlySignal<double> playbackSpeed;
  late final ReadonlySignal<bool> paused;

  // late final SmoothVideoSignals _smoothVideoSignals;
  // ReadonlySignal<double> get smoothPosition =>
  //     _smoothVideoSignals.smoothPosition;
  // ReadonlySignal<double> get rawPosition => _smoothVideoSignals.rawPosition;

  late final ReadonlySignal<double> smoothPosition;
  late final ReadonlySignal<double> rawPosition;

  late final ReadonlySignal<int?> videoWidth;
  late final ReadonlySignal<int?> videoHeight;
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
      configuration: PlayerConfiguration(
        osc: !videoOutput,
        externalWindow: !videoOutput,
        aditionalLibMpvOptions: {
          'config': 'yes',
          'config-dir': '',
          'input-default-bindings': 'yes',
          'hwdec': 'auto-safe',
          'border': 'yes',
          'geometry': "1280x720",
          'idle': 'yes',
          'force-window': 'yes',
        },
        vo: 'gpu-next',
        title: "syncopathy",
      ),
    );
    controller = videoOutput ? VideoController(_player) : null;

    _player.setPlaylistMode(PlaylistMode.single);
    _player.pause();
    volume = _player.stream.volume.toSyncSignal(100);
    duration = _player.stream.duration
        .map((d) => d.inMilliseconds / 1000.0)
        .toSyncSignal(0);
    playbackSpeed = _player.stream.rate.toSyncSignal(1);

    final bufferingSignal = _player.stream.buffering.toSyncSignal(
      _player.state.buffering,
    );
    final playingSignal = _player.stream.playing.toSyncSignal(
      _player.state.playing,
    );
    paused = computed(() {
      final paused = !playingSignal.value;
      final buffering = bufferingSignal.value;
      return buffering ? true : paused;
    });

    videoWidth = _player.stream.width.toSyncSignal(_player.state.width);
    videoHeight = _player.stream.height.toSyncSignal(_player.state.height);

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
      var filename = entry?.filename;
      if (filename != null) {
        filename = Uri.file(filename).toFilePath(windows: false);
        final video = _previouslyLoadedVideos.value.firstWhereOrNull((v) {
          final videoPath = Uri.file(v.url).toFilePath(windows: false);
          return videoPath == filename;
        });
        return video;
      }
      return null;
    });

    // _smoothVideoSignals = SmoothVideoSignals(
    //   _player.stream.position
    //       .map((d) => d.inMilliseconds / 1000.0)
    //       .toSyncSignal(_player.state.position.inMilliseconds / 1000.0),
    //   paused,
    //   playbackSpeed,
    // );

    rawPosition = _player.stream.position
        .map((d) => d.inMilliseconds / 1000.0)
        .toSyncSignal(_player.state.position.inMilliseconds / 1000.0);
    smoothPosition = rawPosition;

    eventSubs([
      Events.on<OpenVideoEvent>().listen((ev) async {
        // If a playlist is currently open try to find the video and set the index
        final playlist = currentPlaylist.value;
        final video = ev.video;
        final index = playlist.getIndexForVideo(video);
        if (index >= 0 && index < playlist.entries.length) {
          _player.jump(index);
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
    // final playlistFile = await _createPlaylistM3U(event.videos);
    _loadList(event.videos);
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

  void _loadList(List<Video> videos) {
    final playlist = Playlist(videos.map((v) => Media(v.url)).toList());
    _player.open(playlist, play: false);
    _playlistShuffled.value = false;
  }

  // ignore: unused_element
  Future<bool> _loadFile(String filepath) async {
    _player.open(Media(filepath));
    return true;
  }

  Future<void> _closeFile() async {
    await _player.stop();
    _player.setShuffle(false);
  }

  void dispose() async {
    eventDispose();
    effectDispose();
    await _player.dispose();
    //_smoothVideoSignals.dispose();
  }

  void screenshot(String path) async {
    final buffer = await _player.screenshot();
    if (buffer != null) {
      File(path).writeAsBytesSync(buffer.toList(), flush: true);
    }
  }

  void toggleLooping() {
    if (_player.state.playlistMode == PlaylistMode.loop) {
      _player.setPlaylistMode(PlaylistMode.single);
    } else {
      _player.setPlaylistMode(PlaylistMode.loop);
    }
  }

  void seekTo(Duration seek) => _player.seek(seek);

  void setSpeed(double speed) => _player.setRate(speed.clamp(0.5, 2.0));

  void setVolume(double volume) => _player.setVolume(volume.clamp(0, 100));

  void togglePause() => _player.playOrPause();

  void _onPlaylistShuffle(PlaylistSetShuffleEvent event) {
    if (playlistShuffled.value != event.shuffle) {
      _player.setShuffle(event.shuffle);
      _playlistShuffled.value = event.shuffle;
    }
  }
}
