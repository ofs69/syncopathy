import 'dart:async';

import 'package:flutter/material.dart';
import 'package:libmpv_dart/video/video_params.dart';
import 'package:syncopathy/funscript_algo.dart';
import 'package:syncopathy/logging.dart';
import 'package:syncopathy/media_manager.dart';
import 'package:syncopathy/model/funscript.dart';
import 'package:syncopathy/model/playlist.dart';
import 'package:syncopathy/model/settings.dart';
import 'package:syncopathy/model/video_model.dart';
import 'package:syncopathy/player/funscript_stream_controller.dart';
import 'package:syncopathy/player/handy_ble.dart';
import 'package:syncopathy/player/mpv.dart';

class PlayerModel extends ChangeNotifier {
  late final MpvVideoplayer _mpvPlayer;
  bool _shouldPlay = false;
  ValueNotifier<bool> get paused => _mpvPlayer.paused;
  ValueNotifier<double> get volume => _mpvPlayer.volume;
  ValueNotifier<double> get positionNoOffset => _mpvPlayer.position;
  ValueNotifier<double> get duration => _mpvPlayer.duration;
  ValueNotifier<double> get playbackSpeed => _mpvPlayer.playbackSpeed;
  ValueNotifier<int> get textureId => _mpvPlayer.textureId;
  ValueNotifier<VideoParams> get videoParams => _mpvPlayer.videoParams;

  late final HandyBle _handyBle;
  ValueNotifier<bool> get isScanning => _handyBle.isScanning;
  ValueNotifier<bool> get isConnected => _handyBle.isConnected;

  final Settings _settings;
  final MediaManager _mediaManager;
  late final FunscriptStreamController _funscriptStreamController;

  final ValueNotifier<Playlist?> playlist = ValueNotifier(null);
  bool _hasTriggeredNextVideo = false;

  ValueNotifier<Video?> currentVideo = ValueNotifier(null);
  ValueNotifier<Funscript?> currentFunscript = ValueNotifier(null);

  ValueNotifier<double> get _positionNoOffset => _mpvPlayer.position;

  int get positionMs =>
      (_positionNoOffset.value * 1000.0).round().toInt() +
      _settings.offsetMs.value;

  PlayerModel(this._settings, this._mediaManager) {
    _mpvPlayer = MpvVideoplayer(
      videoOutput: _settings.embeddedVideoPlayer.value,
    );

    _handyBle = HandyBle(_settings);
    _funscriptStreamController = FunscriptStreamController(_handyBle);

    paused.addListener(_handlePausedChanged);
    _funscriptStreamController.canPlay.addListener(_handlePausedChanged);
    positionNoOffset.addListener(_handlePositionChanged);
  }

  @override
  void dispose() {
    paused.removeListener(_handlePausedChanged);
    _funscriptStreamController.canPlay.removeListener(_handlePausedChanged);
    positionNoOffset.removeListener(_handlePositionChanged);
    _mpvPlayer.dispose();
    _handyBle.dispose();
    super.dispose();
  }

  void tryConnect() {
    _handyBle.startScan();
  }

  Future<void> _handlePositionChanged() async {
    final stopwatch = Stopwatch()..start();
    await _funscriptStreamController.bufferFunscript(
      positionMs,
      paused.value,
      playbackSpeed.value,
    );
    if (!paused.value) {
      await _funscriptStreamController.positionUpdate(
        positionMs + stopwatch.elapsedMilliseconds,
        paused.value,
        playbackSpeed.value,
      );
      _checkAndPlayNextVideo();
    }
  }

  void _checkAndPlayNextVideo() {
    if (playlist.value == null || _hasTriggeredNextVideo) {
      return;
    }

    bool shouldPlayNext = false;
    if (currentFunscript.value != null &&
        currentFunscript.value!.actions.isNotEmpty) {
      final triggerTimeMs = currentFunscript.value!.actions.last.at - 100;
      if (positionMs >= triggerTimeMs) {
        shouldPlayNext = true;
      }
    } else {
      // Fallback to old logic if no funscript is loaded
      const double endThresholdSeconds =
          0.10; // Play next video 100 millieseconds before current one ends

      if (duration.value > 0 &&
          positionNoOffset.value >= (duration.value - endThresholdSeconds)) {
        shouldPlayNext = true;
      }
    }

    if (shouldPlayNext) {
      if (playlist.value!.currentIndex.value <
          playlist.value!.videos.length - 1) {
        _hasTriggeredNextVideo =
            true; // Prevent multiple triggers for the same video
        playlist.value!.next();
      }
    }
  }

  Future<void> _handlePausedChanged() async {
    // if (_funscriptStreamController.canPlay.value &&
    //     (_shouldPlay != !paused.value)) {
    //   _shouldPlay = !paused.value;
    // }

    if (_shouldPlay) {
      play();
      await _funscriptStreamController.startPlayback(
        positionMs,
        playbackSpeed.value,
      );
    } else {
      pause();
      await _funscriptStreamController.stopPlayback();
    }
  }

  Future<bool> _loadAndProcessFunscript(String script) async {
    var funscriptFile = await Funscript.fromFile(script).catchError(
      (e) => null,
      test: (e) {
        Logger.error(e.toString());
        return true;
      },
    );

    if (funscriptFile == null) {
      currentFunscript.value = null;
      await _funscriptStreamController.unloadFunscript();
      return false;
    }

    funscriptFile.actions = FunscriptAlgorithms.processForHandy(
      funscriptFile.actions,
      rdpEpsilon: _settings.rdpEpsilon.value,
      slewMaxRateOfChangePerSecond: _settings.slewMaxRateOfChange.value,
      remapRange: _settings.remapFullRange.value ? (0, 100) : null,
    );
    currentFunscript.value = funscriptFile;

    Logger.debug(currentFunscript.value?.fileName ?? "no script loaded");

    await _funscriptStreamController.loadFunscript(
      currentFunscript.value!,
      playbackSpeed.value,
    );

    return true;
  }

  Future<void> openVideoAndScript(Video video, bool isPlaylist) async {
    try {
      _hasTriggeredNextVideo = false;
      if (!isPlaylist) {
        clearPlaylist();
      }

      await closeVideo();
      await _loadAndProcessFunscript(video.funscriptPath);
      await _mpvPlayer.loadFile(video.videoPath);
      pause();

      currentVideo.value = video;

      if (_settings.skipToAction.value) {
        final startTime = FunscriptAlgorithms.findFirstStroke(
          currentFunscript.value!.actions,
        );
        seekTo(startTime / 1000.0);
      }
      await _handlePositionChanged();

      if (_settings.autoPlay.value) {
        play();
      }

      return;
    } catch (e) {
      Logger.error(e.toString());
      currentVideo.value = null;
    }
  }

  Future<void> closeVideo() async {
    pause();
    await _funscriptStreamController.stopPlayback();
    await _funscriptStreamController.unloadFunscript();
    _mpvPlayer.closeFile();
  }

  void togglePause() {
    _shouldPlay = !_shouldPlay;
    if (_shouldPlay) {
      play();
    } else {
      pause();
    }
  }

  void play() {
    _shouldPlay = true;
    _mpvPlayer.play();
  }

  void pause() {
    _shouldPlay = false;
    _mpvPlayer.pause();
  }

  void setVolume(double volume) {
    _mpvPlayer.setVolume(volume);
  }

  void setPlaybackSpeed(double speed) {
    _mpvPlayer.setSpeed(speed.clamp(0.5, 2.0));
  }

  void setSizeAndPosition(int width, int height, int x, int y) {
    _mpvPlayer.setSizeAndPosition(width, height, x, y);
  }

  void seekTo(double time) {
    final posPercent = time / duration.value;
    positionNoOffset.value = time;
    _mpvPlayer.seekTo(posPercent.clamp(0.0, 1.0));
  }

  void _handlePlaylistChange() {
    // This method is called when the playlist's internal state changes (e.g., next/previous)
    if (playlist.value != null &&
        playlist.value!.currentVideo != null &&
        playlist.value!.currentVideo != currentVideo.value) {
      openVideoAndScript(playlist.value!.currentVideo!, true);
    }
  }

  void clearPlaylist() {
    playlist.value?.removeListener(_handlePlaylistChange);
    playlist.value = null;
    _mpvPlayer.enableLooping();
  }

  void setPlaylist(List<Video> videos, int initialIndex) {
    // Remove listener from previous playlist if it exists
    playlist.value?.removeListener(_handlePlaylistChange);

    final newPlaylist = Playlist(videos: videos, initialIndex: initialIndex);
    playlist.value = newPlaylist;

    // Add listener to the new playlist
    newPlaylist.addListener(_handlePlaylistChange);

    _mpvPlayer.disableLooping();

    if (newPlaylist.currentVideo != null) {
      openVideoAndScript(newPlaylist.currentVideo!, true);
    }
  }
}
