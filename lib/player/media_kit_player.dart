import 'dart:async';
import 'dart:io';

import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/scheduler.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart' hide Video;
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
  final ReadonlySignal<bool> buffering;

  final _frameTick = signal(DateTime.now());
  late final Ticker _ticker;
  DateTime _lastUpdateWallClock = DateTime.now();

  late final ReadonlySignal<double> smoothPosition;

  SmoothVideoSignals(
    this.rawPosition,
    this.isPaused,
    this.playbackSpeed,
    this.buffering,
  ) {
    _ticker = Ticker((_) => _frameTick.value = DateTime.now());

    smoothPosition = computed(() {
      final pos = rawPosition.value;
      final playing = !isPaused.value;
      final speed = playbackSpeed.value;
      final now = _frameTick.value;
      final isBuffering = buffering.value;

      if (!playing || isBuffering) return pos;

      // Calculate real-world time passed
      final wallClockDrift =
          now.difference(_lastUpdateWallClock).inMilliseconds / 1000.0;

      // Adjust drift based on playback speed
      final extrapolated = pos + (wallClockDrift * speed);
      return extrapolated < pos ? pos : extrapolated;
    });

    effectAdd([
      effect(() {
        update(
          rawPosition.value,
          !isPaused.value,
          playbackSpeed.value,
          buffering.value,
        );
      }),
    ]);
  }

  void dispose() {
    effectDispose();
    _ticker.dispose();
  }

  // Update this from your VideoPlayerController listener
  void update(double newPos, bool playing, double speed, bool buffering) {
    _lastUpdateWallClock = DateTime.now();

    if (playing && !_ticker.isTicking) _ticker.start();
    if ((!playing || buffering) && _ticker.isTicking) _ticker.stop();
  }
}

class MediaKitPlayer with EventSubscriber, EffectDispose {
  late Player _player;
  late final VideoController? controller;

  late final ReadonlySignal<double> volume;
  ReadonlySignal<double?> get duration => _duration;
  final Signal<double?> _duration = signal(0.0);

  late final ReadonlySignal<double> playbackSpeed;
  late final ReadonlySignal<bool> seeking;
  late final ReadonlySignal<bool> buffering;

  ReadonlySignal<bool> get paused => _paused;
  final Signal<bool> _paused = signal(true);

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
          'force-window': videoOutput ? 'no' : 'yes',
        },
        vo: videoOutput ? 'libmpv' : 'gpu-next',
        title: "syncopathy",
      ),
    );
    controller = videoOutput
        ? VideoController(
            _player,
            configuration: VideoControllerConfiguration(
              vo: 'libmpv',
              hwdec: 'auto-safe',
            ),
          )
        : null;

    NativePlayer? nativePlayer;
    if (_player.platform is NativePlayer) {
      nativePlayer = _player.platform as NativePlayer;
    }
    assert(nativePlayer != null, "Non MPV player not supported");

    nativePlayer?.setProperty('keep-open', 'yes');
    nativePlayer?.command(["keybind", "CLOSE_WIN", "ignore"]);
    nativePlayer?.command(["keybind", "q", "ignore"]);

    // nativePlayer?.setProperty('loop-file', 'no');
    // nativePlayer?.setProperty('loop-playlist', 'inf');
    // nativePlayer?.setProperty("volume", "100.0");
    // nativePlayer?.setProperty("pause", 'yes');

    _player.setPlaylistMode(PlaylistMode.loop);
    _player.pause();

    seeking = _player.stream.seeking.toSyncSignal(_player.state.seeking);
    volume = _player.stream.volume.toSyncSignal(100);

    playbackSpeed = _player.stream.rate.toSyncSignal(1);

    _paused.value = !_player.state.playing;

    // media-kit pause state is weird. listen to mpv directly
    nativePlayer?.observeProperty('pause', (value) async {
      _paused.value = value == 'yes' ? true : false;
    });

    videoParams = _player.stream.videoParams.toSyncSignal(
      _player.state.videoParams,
    );

    playlist = _player.stream.playlist.toSyncSignal(_player.state.playlist);
    final playlistModeSignal = _player.stream.playlistMode.toSyncSignal(
      _player.state.playlistMode,
    );

    loopFile = computed(() {
      var playlistCount = playlist.value.medias.length;
      var playlistMode = playlistModeSignal.value;

      // edge case playlist with one item looping == looping a single file
      if (playlistCount == 1 && playlistMode == PlaylistMode.loop) {
        return true;
      }
      // otherwise check if single file looping is on
      return playlistMode == PlaylistMode.single;
    });

    loadedPath = computed(() {
      final currentPlaylist = playlist.value;
      final index = currentPlaylist.index;
      if (index >= 0 && index < currentPlaylist.medias.length) {
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
          final videoPath = Uri.file(v.videoPath).toFilePath(windows: false);
          return videoPath == filename;
        });
        return video;
      }
      return null;
    });

    buffering = _player.stream.buffering.toSyncSignal(_player.state.buffering);
    _smoothVideoSignals = SmoothVideoSignals(
      _player.stream.position
          .map((d) => d.inMilliseconds / 1000.0)
          .toSyncSignal(_player.state.position.inMilliseconds / 1000.0),
      paused,
      playbackSpeed,
      buffering,
    );

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

    final durationSignal = _player.stream.duration
        .map((d) => d.inMilliseconds / 1000.0)
        .toSyncSignal(_player.state.duration.inMilliseconds / 1000.0);

    String lastDurationFile = "";
    effectAdd([
      effect(() {
        final path = loadedPath.value;
        if (path != lastDurationFile) {
          _duration.value = null;
        }
        lastDurationFile = path;
      }),
      effect(() {
        final newDuration = durationSignal.value;
        _duration.value = newDuration < 0.1 ? null : newDuration;
      }),
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

  // ignore: unused_element
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

  void _loadList(List<Video> videos) {
    final playlist = Playlist(videos.map((v) => Media(v.videoPath)).toList());
    _player.open(playlist, play: _player.state.playing);
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
    _smoothVideoSignals.dispose();
  }

  Future<Uint8List?> screenshot(String path) async {
    return await _player.screenshot(
      format: 'image/jpeg',
      includeLibassSubtitles: false,
    );
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

  void setVolume(double volume) => _player.setVolume(volume.clamp(0, 130));

  void togglePause() => _player.playOrPause();

  void _onPlaylistShuffle(PlaylistSetShuffleEvent event) {
    if (playlistShuffled.value != event.shuffle) {
      _player.setShuffle(event.shuffle);
      _playlistShuffled.value = event.shuffle;
    }
  }
}
