import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/widgets.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart' hide Video;
import 'package:media_kit_video/media_kit_video.dart'
    as media_kit_video
    show Video;
import 'package:path/path.dart' as p;
import 'package:signals/signals_flutter.dart';
import 'package:syncopathy/logging.dart';
import 'package:syncopathy/model/playlist_model.dart';
import 'package:syncopathy/notification_feed.dart';
import 'package:syncopathy/persistence/entities/media_file.dart';
import 'package:syncopathy/player/playback_session.dart';
import 'package:syncopathy/player/smooth_video_signals.dart';
import 'package:syncopathy/player/video_player.dart';

/// [VideoPlayer] on top of `media_kit`/libmpv.
///
/// Every media_kit type stays inside this class and its subclasses; the rest of
/// the app talks to [VideoPlayer], or — for the funscript/device pipeline — to
/// the narrower [PlaybackSession].
abstract class MediaKitVideoPlayer extends VideoPlayer {
  /// A local player accepts every command, always.
  static final ReadonlySignal<Set<PlaybackCapability>> _allCapabilities =
      signal(Set.unmodifiable(PlaybackCapability.values.toSet()));

  @override
  final bool embeddedPlayer;

  @override
  ReadonlySignal<Set<PlaybackCapability>> get capabilities => _allCapabilities;

  // TODO: remove _previouslyLoadedVideos and find a better way to resolve the filename from the playlist back to a video
  final Signal<List<MediaFile>> _previouslyLoadedVideos = signal([]);
  @override
  late final ReadonlySignal<PlaylistModel> currentPlaylist;

  @override
  late final ReadonlySignal<bool> seeking;
  @override
  late final ReadonlySignal<double> volume;
  @override
  late final ReadonlySignal<double> playbackSpeed;
  @override
  late final ReadonlySignal<int?> videoWidth;
  @override
  late final ReadonlySignal<int?> videoHeight;
  @override
  late final ReadonlySignal<bool> loopFile;
  @override
  late final ReadonlySignal<String> loadedPath;
  @override
  late final ReadonlySignal<bool> buffering;
  @override
  late final ReadonlySignal<MediaFile?> currentMedia;

  /// mpv's own playlist. Kept private to this class — the rest of the app sees
  /// [currentPlaylist], which carries no media_kit types.
  late final ReadonlySignal<Playlist> _nativePlaylist;

  // Canonical media path -> video, rebuilt only when the loaded list changes,
  // so resolving the current track is an O(1) lookup instead of canonicalizing
  // the whole list on every track change.
  late final ReadonlySignal<Map<String, MediaFile>> _canonicalVideoMap =
      computed(() {
        return <String, MediaFile>{
          for (final v in _previouslyLoadedVideos.value)
            p.canonicalize(v.mediaPath): v,
        };
      });

  @override
  ReadonlySignal<double?> get duration => _duration;
  @override
  ReadonlySignal<double> get smoothPosition =>
      _smoothVideoSignals.smoothPosition;
  @override
  ReadonlySignal<double> get rawPosition => _smoothVideoSignals.rawPosition;

  @protected
  late final Player player;
  @protected
  late final SmoothVideoSignals _smoothVideoSignals;

  @protected
  late final VideoController? controller;

  @protected
  final Signal<bool> playlistShuffledInternal = signal(false);
  @override
  ReadonlySignal<bool> get playlistShuffled => playlistShuffledInternal;

  @protected
  final Signal<double?> _duration = signal(null);

  MediaKitVideoPlayer({required this.embeddedPlayer});

  void initSignals(Player player) {
    seeking = player.stream.seeking.toSyncSignal(player.state.seeking);
    volume = player.stream.volume
        .map((v) => v.clamp(0.0, 100.0))
        .toSyncSignal(player.state.volume);
    playbackSpeed = player.stream.rate.toSyncSignal(player.state.rate);
    videoWidth = player.stream.width.toSyncSignal(player.state.width);
    videoHeight = player.stream.height.toSyncSignal(player.state.height);
    _nativePlaylist = player.stream.playlist.toSyncSignal(
      player.state.playlist,
    );

    final playlistModeSignal = player.stream.playlistMode.toSyncSignal(
      player.state.playlistMode,
    );
    loopFile = computed(() {
      var playlistCount = _nativePlaylist.value.medias.length;
      var playlistMode = playlistModeSignal.value;

      // edge case playlist with one item looping == looping a single file
      if (playlistCount == 1 && playlistMode == PlaylistMode.loop) {
        return true;
      }
      // otherwise check if single file looping is on
      return playlistMode == PlaylistMode.single;
    });

    loadedPath = computed(() {
      final nativePlaylist = _nativePlaylist.value;
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

    currentMedia = computed(() {
      final playlistModel = currentPlaylist.value;
      final entry = playlistModel.currentPlaylistItem.value;
      final filename = entry?.filename;
      if (filename == null) return null;
      return _canonicalVideoMap.value[p.canonicalize(filename)];
    });

    player.setPlaylistMode(PlaylistMode.loop);
    player.pause();

    currentPlaylist = computed(() {
      final nativePlaylist = _nativePlaylist.value;
      final currentIndex = nativePlaylist.index;
      int counter = 0;
      final entries = nativePlaylist.medias.map((media) {
        final item = PlaylistItem(counter, media.uri, currentIndex == counter);
        counter += 1;
        return item;
      }).toList();
      return PlaylistModel(entries);
    });

    // Every duration event is written, not just a change. Moving to the next
    // playlist entry resets the duration to null below, and media_kit never
    // reports mpv's "unavailable" in between, so a next file of the same length
    // arrives as the value already seen — a deduplicating signal would swallow
    // it and leave the duration null for as long as the file plays.
    _setDuration(player.state.duration);
    _durationSubscription = player.stream.duration.listen(_setDuration);

    String lastDurationFile = "";
    effectAdd([
      effect(() {
        final path = loadedPath.value;
        if (path == lastDurationFile) return;
        lastDurationFile = path;
        // Never let the next file borrow the previous file's length.
        _duration.value = null;
        // The event carrying the new length can land before the playlist
        // reports the new entry - prefetching makes that common - and then
        // nothing follows to undo the reset. mpv already knows the length by
        // then, so ask it rather than wait for an event that has been and gone.
        untracked(() => _recoverDuration(path));
      }),
    ]);
  }

  StreamSubscription<Duration>? _durationSubscription;

  void _setDuration(Duration d) {
    final seconds = d.inMilliseconds / 1000.0;
    _duration.value = seconds < 0.1 ? null : seconds;
  }

  Future<void> _recoverDuration(String path) async {
    final seconds = await queryDuration();
    if (seconds == null || seconds < 0.1) return;
    // The player moved on while mpv answered, or the event got there first.
    if (loadedPath.value != path || _duration.value != null) return;
    _duration.value = seconds;
  }

  /// The open file's length in seconds as the player reports it right now, or
  /// null when it does not know yet or cannot be asked.
  @protected
  Future<double?> queryDuration() async => null;

  @override
  void dispose() async {
    super.dispose();
    await _durationSubscription?.cancel();
    _smoothVideoSignals.dispose();
    await player.dispose();
  }

  @override
  Future<void> closeMedia() async {
    await player.stop();
    player.setShuffle(false);
  }

  @override
  Future<void> openSingleVideo(MediaFile media) async {
    if (_refuseWhileNotOwner()) return;
    // If a playlist is currently open try to find the video and set the index
    final playlistModel = currentPlaylist.value;
    final index = playlistModel.getIndexForVideo(media);
    if (index >= 0 && index < playlistModel.entries.value.length) {
      player.jump(index);
      return;
    }

    // Open video as a playlist with one video
    await openMultipleVideos([media]);
  }

  @override
  Future<void> openMultipleVideos(List<MediaFile> videos) async {
    if (_refuseWhileNotOwner()) return;
    if (videos.isEmpty) return;
    _previouslyLoadedVideos.value = videos;
    final playlist = Playlist(videos.map((v) => Media(v.mediaPath)).toList());
    await player.open(playlist, play: player.state.playing);
    playlistShuffledInternal.value = false;
  }

  /// Refuses to start playing while another session owns the clock, and says
  /// so. Returns whether the caller should stop.
  ///
  /// Checked here rather than at each button, so a path added later cannot
  /// quietly reintroduce the conflict: every way into local playback comes
  /// through these two methods.
  bool _refuseWhileNotOwner() {
    if (ownsPlayback) return false;
    final owner = playbackOwner?.sessionName ?? 'another player';
    Logger.info('Refused local playback: $owner owns the clock');
    AlertManager.showError(
      '$owner is playing. Stop it there before playing something here.',
    );
    return true;
  }

  @override
  void jumpPreviousPlaylistEntry() {
    final playlistModel = currentPlaylist.value;
    final count = playlistModel.entries.value.length;
    if (count <= 1) return;
    // Wrap around: stepping back from the first entry lands on the last.
    final current = playlistModel.currentIndex.value.clamp(0, count - 1);
    final newIndex = (current - 1 + count) % count;
    if (newIndex != current) {
      player.jump(newIndex);
    }
  }

  @override
  void jumpNextPlaylistEntry() {
    final playlistModel = currentPlaylist.value;
    final count = playlistModel.entries.value.length;
    if (count <= 1) return;
    // Wrap around: stepping past the last entry lands on the first.
    final current = playlistModel.currentIndex.value.clamp(0, count - 1);
    final newIndex = (current + 1) % count;
    if (newIndex != current) {
      player.jump(newIndex);
    }
  }

  @override
  Future<Uint8List?> screenshot() async {
    // Nothing is rendering here while another session owns playback, so the
    // honest answer is no frame rather than a stale one.
    if (!ownsPlayback) return null;
    return await player.screenshot(
      format: 'image/jpeg',
      includeLibassSubtitles: false,
    );
  }

  @override
  void toggleLooping() {
    if (player.state.playlistMode == PlaylistMode.loop) {
      player.setPlaylistMode(PlaylistMode.single);
    } else {
      player.setPlaylistMode(PlaylistMode.loop);
    }
  }

  @override
  void seekTo(Duration position) => player.seek(position);

  @override
  void setSpeed(double speed) => player.setRate(
    speed.clamp(VideoPlayer.minPlaybackSpeed, VideoPlayer.maxPlaybackSpeed),
  );

  @override
  void setVolume(double volume) =>
      player.setVolume(volume.clamp(0, VideoPlayer.maxVolume));

  @override
  void togglePause() => player.playOrPause();

  @override
  void setPlaylistShuffle(bool shuffle) {
    if (playlistShuffledInternal.value != shuffle) {
      player.setShuffle(shuffle);
      playlistShuffledInternal.value = shuffle;
    }
  }

  @override
  Widget? buildVideoSurface() {
    final videoController = controller;
    if (videoController == null) return null;
    return media_kit_video.Video(controller: videoController, controls: null);
  }
}
