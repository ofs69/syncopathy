import 'dart:typed_data';

import 'package:flutter/widgets.dart';
import 'package:signals/signals_flutter.dart';
import 'package:syncopathy/model/playlist_model.dart';
import 'package:syncopathy/persistence/entities/media_file.dart';
import 'package:syncopathy/player/playback_session.dart';

/// A [PlaybackSession] backed by a local video player that Syncopathy drives
/// itself.
///
/// Everything here is local-playback surface an externally owned session has no
/// answer for — a playlist, an audio volume, a frame grab, a video widget to
/// render. The clock and the transport commands live on [PlaybackSession]; keep
/// them there so the device pipeline never needs to know a local player exists.
abstract class VideoPlayer extends PlaybackSession {
  @override
  String get sessionName => 'the local player';

  ActivePlaybackSession? _ownership;

  /// Tells the local player who currently owns playback.
  ///
  /// Bound once at startup rather than passed to the constructor, because the
  /// [ActivePlaybackSession] is built *from* this player and cannot exist
  /// before it. Until it is bound the player assumes it is in charge, which is
  /// the right answer for a build that has no other session at all.
  void bindOwnership(ActivePlaybackSession ownership) => _ownership = ownership;

  /// Whether this player may act on a command right now.
  ///
  /// False while an external session holds the clock. Starting local playback
  /// then would leave two players running against one device, with the
  /// funscript following whichever reported last.
  bool get ownsPlayback => _ownership?.localOwnsPlayback.value ?? true;

  /// The session that does own playback, for a message that names it.
  PlaybackSession? get playbackOwner => _ownership?.value;

  static const double minPlaybackSpeed = 0.5;
  static const double maxPlaybackSpeed = 2.0;
  static const double maxVolume = 130;

  /// The video renders into the Syncopathy UI rather than the player's own
  /// window.
  bool get embeddedPlayer;

  /// Audio volume on a 0..[maxVolume] scale.
  ReadonlySignal<double> get volume;

  ReadonlySignal<PlaylistModel> get currentPlaylist;

  ReadonlySignal<bool> get playlistShuffled;

  void setVolume(double volume);

  /// Replaces the playlist with [videos] and starts at the first entry.
  Future<void> openMultipleVideos(List<MediaFile> videos);

  void jumpNextPlaylistEntry();

  void jumpPreviousPlaylistEntry();

  void setPlaylistShuffle(bool shuffle);

  /// Grabs the currently displayed frame as encoded image bytes, or null when
  /// the player cannot produce one.
  Future<Uint8List?> screenshot();

  /// The widget that renders the video, or null when the player draws into its
  /// own window and there is nothing to embed.
  ///
  /// The caller supplies the layout around it (aspect ratio, decoration); this
  /// returns the bare video surface so the rendering backend stays private to
  /// the implementation.
  Widget? buildVideoSurface();
}
