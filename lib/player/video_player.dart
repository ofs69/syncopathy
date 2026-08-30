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
