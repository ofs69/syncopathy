import 'dart:convert';
import 'package:collection/collection.dart';
import 'package:signals/signals_flutter.dart';
import 'package:syncopathy/sqlite/models/video_model.dart';

class PlaylistModel {
  final Signal<List<PlaylistItem>> _entries;
  late final ReadonlySignal<int> currentIndex;
  late final ReadonlySignal<PlaylistItem?> currentPlaylistItem;

  ReadonlySignal<List<PlaylistItem>> get entries => _entries;

  PlaylistModel(List<PlaylistItem> entries) : _entries = listSignal(entries) {
    currentIndex = computed(() => _entries.value.indexWhere((e) => e.current));
    currentPlaylistItem = computed(
      () => _entries.value.firstWhereOrNull((e) => e.current),
    );
  }
  //UnmodifiableListView<Video> get videos => UnmodifiableListView(_videos);
  //bool get isShuffled => _isShuffled;

  // void shuffleList() {
  //   _isShuffled = !_isShuffled;
  //   if (_isShuffled) {
  //     _videos.shuffle();
  //   } else {
  //     _videos
  //       ..clear()
  //       ..addAll(_originalVideos);
  //   }
  // }

  // Video? nextVideo() {
  //   if (_videos.isNotEmpty) {
  //     final index = (_currentIndex.value + 1) % _videos.length;
  //     return index >= 0 && index < _videos.length ? _videos[index] : null;
  //   }
  //   return null;
  // }

  // Video? previousVideo() {
  //   if (_videos.isNotEmpty) {
  //     final index = (_currentIndex.value - 1 + _videos.length) % _videos.length;
  //     return index >= 0 && index < _videos.length ? _videos[index] : null;
  //   }
  //   return null;
  // }

  // Video? videoAt(int index) {
  //   if (index >= 0 && index < _videos.length) {
  //     return _videos[index];
  //   }
  //   return null;
  // }

  // void setIndexFromVideo(Video video) {
  //   final index = _videos.indexOf(video);
  //   if (index < 0) {
  //     throw Exception("Video not in playlist");
  //   }
  //   _currentIndex.value = index;
  // }

  int getIndexForVideo(Video video) {
    final videoPath = Uri.file(video.videoPath).toFilePath(windows: false);

    return _entries.indexWhere(
      (v) => Uri.file(v.filename).toFilePath(windows: false) == videoPath,
    );
  }

  // void setIndexFromVideoPath(String newPath) {
  //   final index = _playlistItems.indexWhere((v) => v.filename == newPath);
  //   if (index < 0 && _playlistItems.isNotEmpty) {
  //     throw Exception("Video not in playlist");
  //   }
  //   _currentIndex.value = index;
  // }

  static PlaylistModel fromJson(String jsonString) {
    /*
      Playlist, current entry marked. Currently, the raw property value is useless.
      This has a number of sub-properties. Replace N with the 0-based playlist entry index.

      playlist/count
          Number of playlist entries (same as playlist-count).
      playlist/N/filename
          Filename of the Nth entry.
      playlist/N/playing
          yes/true if the playlist-playing-pos property points to this entry, no/false or unavailable otherwise.
      playlist/N/current
          yes/true if the playlist-current-pos property points to this entry, no/false or unavailable otherwise.
      playlist/N/title
          Name of the Nth entry. Available if the playlist file contains such fields and mpv's parser supports it for the given playlist format, or if the playlist entry has been opened before and a media-title other than filename has been acquired.
      playlist/N/id
          Unique ID for this entry. This is an automatically assigned integer ID that is unique for the entire life time of the current mpv core instance. Other commands, events, etc. use this as playlist_entry_id fields.
      playlist/N/playlist-path
          The original path of the playlist for this entry before mpv expanded it. Unavailable if the file was not originally associated with a playlist in some way. 
    */
    try {
      final json = jsonDecode(jsonString);
      if (json is! List<dynamic>) {
        return PlaylistModel([]);
      }

      List<PlaylistItem> items = [];
      for (final Map<String, dynamic> item
          in json.whereType<Map<String, dynamic>>()) {
        final id = item['id'] as int?;
        final filename = item['filename'] as String?;
        final current = item['current'] as bool?;
        final playing = item['playing'] as bool?;

        if (id != null && filename != null) {
          items.add(
            PlaylistItem(id, filename, current ?? false /*, playing ?? false*/),
          );
        }
      }
      return PlaylistModel(items);
    } catch (_) {}

    return PlaylistModel([]);
  }
}

class PlaylistItem {
  final int id;
  final String filename;
  final bool current;
  PlaylistItem(this.id, this.filename, this.current);
}
