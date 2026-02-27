import 'package:syncopathy/model/video.dart';

abstract class PlayerEvent {}

class OpenVideoEvent extends PlayerEvent {
  final Video video;
  OpenVideoEvent(this.video);
}

class OpenPlaylistEvent extends PlayerEvent {
  final List<Video> videos;
  OpenPlaylistEvent(this.videos);
}

class CloseMediaEvent extends PlayerEvent {}

class PlaylistPreviousEvent extends PlayerEvent {}

class PlaylistNextEvent extends PlayerEvent {}

class PlaylistSetShuffleEvent extends PlayerEvent {
  final bool shuffle;
  PlaylistSetShuffleEvent(this.shuffle);
}
