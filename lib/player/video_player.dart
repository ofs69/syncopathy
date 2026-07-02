import 'dart:typed_data';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart' hide Video;
import 'package:path/path.dart' as p;
import 'package:signals/signals_flutter.dart';
import 'package:syncopathy/helper/effect_dispose_mixin.dart';
import 'package:syncopathy/model/playlist_model.dart';
import 'package:syncopathy/persistence/entities/media_file.dart';
import 'package:syncopathy/player/smooth_video_signals.dart';

// for UI purposes update the position in 1000 steps
const int videoPlayerPositionFixedStepCount = 1000;

abstract class VideoPlayer with EffectDispose {
  static const double minPlaybackSpeed = 0.5;
  static const double maxPlaybackSpeed = 2.0;
  static const double maxVolume = 130;

  final bool embeddedPlayer;

  // TODO: remove _previouslyLoadedVideos and find a better way to resolve the filename from the playlist back to a video
  final Signal<List<MediaFile>> _previouslyLoadedVideos = signal([]);
  late final ReadonlySignal<PlaylistModel> currentPlaylist;

  late final ReadonlySignal<bool> seeking;
  late final ReadonlySignal<double> volume;
  late final ReadonlySignal<double> playbackSpeed;
  late final ReadonlySignal<int?> videoWidth;
  late final ReadonlySignal<int?> videoHeight;
  late final ReadonlySignal<Playlist> playlist;
  late final ReadonlySignal<bool> loopFile;
  late final ReadonlySignal<String> loadedPath;
  late final ReadonlySignal<bool> buffering;
  late final ReadonlySignal<MediaFile?> currentMedia;
  late final ReadonlySignal<int> currentPositionSeconds; // for UI
  late final ReadonlySignal<int> currentPositionFixedStep; // for UI
  ReadonlySignal<bool> get paused;

  ReadonlySignal<double?> get duration => _duration;
  ReadonlySignal<double> get smoothPosition =>
      _smoothVideoSignals.smoothPosition;
  ReadonlySignal<double> get rawPosition => _smoothVideoSignals.rawPosition;

  @protected
  late final Player player;
  @protected
  late final SmoothVideoSignals _smoothVideoSignals;

  late final VideoController? controller;

  @protected
  final Signal<bool> playlistShuffledInternal = signal(false);
  ReadonlySignal<bool> get playlistShuffled => playlistShuffledInternal;

  @protected
  final Signal<double?> _duration = signal(null);

  VideoPlayer({required this.embeddedPlayer});

  void initSignals(Player player) {
    seeking = player.stream.seeking.toSyncSignal(player.state.seeking);
    volume = player.stream.volume
        .map((v) => v.clamp(0.0, 100.0))
        .toSyncSignal(player.state.volume);
    playbackSpeed = player.stream.rate.toSyncSignal(player.state.rate);
    videoWidth = player.stream.width.toSyncSignal(player.state.width);
    videoHeight = player.stream.height.toSyncSignal(player.state.height);
    playlist = player.stream.playlist.toSyncSignal(player.state.playlist);

    final playlistModeSignal = player.stream.playlistMode.toSyncSignal(
      player.state.playlistMode,
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
      final nativePlaylist = playlist.value;
      final index = nativePlaylist.index;
      if (index >= 0 && index < nativePlaylist.medias.length) {
        return nativePlaylist.medias[index].uri;
      }
      return "";
    });
    buffering = player.stream.buffering.toSyncSignal(player.state.buffering);
    _smoothVideoSignals = SmoothVideoSignals(
      player.stream.position
          .map((d) => d.inMilliseconds / 1000.0)
          .toSyncSignal(player.state.position.inMilliseconds / 1000.0),
      paused,
      playbackSpeed,
      buffering,
    );
    currentPositionSeconds = computed(() {
      return smoothPosition.value.toInt();
    });
    currentPositionFixedStep = computed(() {
      final currentPosition = smoothPosition.value;
      final totalDuration = duration.value;
      if (totalDuration == null) return 0;
      final stepSize = totalDuration / videoPlayerPositionFixedStepCount;
      return currentPosition ~/ stepSize;
    });

    currentMedia = computed(() {
      final playlistModel = currentPlaylist.value;
      final entry = playlistModel.currentPlaylistItem.value;
      var filename = entry?.filename;
      if (filename != null) {
        filename = p.canonicalize(filename);
        final video = _previouslyLoadedVideos.value.firstWhereOrNull((v) {
          final videoPath = p.canonicalize(v.mediaPath);
          return videoPath == filename;
        });
        return video;
      }
      return null;
    });

    player.setPlaylistMode(PlaylistMode.loop);
    player.pause();

    currentPlaylist = computed(() {
      final nativePlaylist = playlist.value;
      final currentIndex = nativePlaylist.index;
      int counter = 0;
      final entries = nativePlaylist.medias.map((media) {
        final item = PlaylistItem(counter, media.uri, currentIndex == counter);
        counter += 1;
        return item;
      }).toList();
      return PlaylistModel(entries);
    });

    final durationSignal = player.stream.duration
        .map((d) => d.inMilliseconds / 1000.0)
        .toSyncSignal(player.state.duration.inMilliseconds / 1000.0);

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

  void dispose() async {
    effectDispose();
    _smoothVideoSignals.dispose();
    await player.dispose();
  }

  Future<void> closeMedia() async {
    await player.stop();
    player.setShuffle(false);
  }

  Future<void> openSingleVideo(MediaFile video) async {
    // If a playlist is currently open try to find the video and set the index
    final playlistModel = currentPlaylist.value;
    final index = playlistModel.getIndexForVideo(video);
    if (index >= 0 && index < playlistModel.entries.length) {
      player.jump(index);
      return;
    }

    // Open video as a playlist with one video
    await openMultipleVideos([video]);
  }

  Future<void> openMultipleVideos(List<MediaFile> videos) async {
    if (videos.isEmpty) return;
    _previouslyLoadedVideos.value = videos;
    final playlist = Playlist(videos.map((v) => Media(v.mediaPath)).toList());
    await player.open(playlist, play: player.state.playing);
    playlistShuffledInternal.value = false;
  }

  void jumpPreviousPlaylistEntry() {
    final playlistModel = currentPlaylist.value;
    final newIndex = (playlistModel.currentIndex.value - 1).clamp(
      0,
      playlistModel.entries.length - 1,
    );

    if (newIndex != playlistModel.currentIndex.value) {
      player.jump(newIndex);
    }
  }

  void jumpNextPlaylistEntry() {
    final playlistModel = currentPlaylist.value;
    final newIndex = (playlistModel.currentIndex.value + 1).clamp(
      0,
      playlistModel.entries.length - 1,
    );

    if (newIndex != playlistModel.currentIndex.value) {
      player.jump(newIndex);
    }
  }

  Future<Uint8List?> screenshot() async {
    return await player.screenshot(
      format: 'image/jpeg',
      includeLibassSubtitles: false,
    );
  }

  void toggleLooping() {
    if (player.state.playlistMode == PlaylistMode.loop) {
      player.setPlaylistMode(PlaylistMode.single);
    } else {
      player.setPlaylistMode(PlaylistMode.loop);
    }
  }

  void seekTo(Duration seek) => player.seek(seek);

  void seekRelative(Duration offset) {
    final current = player.state.position;
    seekTo(current + offset);
  }

  void setSpeed(double speed) =>
      player.setRate(speed.clamp(minPlaybackSpeed, maxPlaybackSpeed));

  void setVolume(double volume) => player.setVolume(volume.clamp(0, maxVolume));

  void togglePause() => player.playOrPause();

  void setPlaylistShuffle(bool shuffle) {
    if (playlistShuffledInternal.value != shuffle) {
      player.setShuffle(shuffle);
      playlistShuffledInternal.value = shuffle;
    }
  }
}
