import 'dart:convert';
import 'package:collection/collection.dart';
import 'package:path/path.dart' as p;
import 'package:signals/signals_flutter.dart';
import 'package:syncopathy/persistence/entities/media_file.dart';

class PlaylistModel {
  final Signal<List<PlaylistItem>> _entries;
  late final ReadonlySignal<int> currentIndex;
  late final ReadonlySignal<PlaylistItem?> currentPlaylistItem;
  late final ReadonlySignal<Map<String, int>> _canonicalFilenamesToIndex;
  late final ReadonlySignal<Set<String>> canonicalFilenames;

  ReadonlySignal<List<PlaylistItem>> get entries => _entries;

  PlaylistModel(List<PlaylistItem> entries) : _entries = listSignal(entries) {
    currentIndex = computed(() => _entries.value.indexWhere((e) => e.current));
    currentPlaylistItem = computed(
      () => _entries.value.firstWhereOrNull((e) => e.current),
    );
    _canonicalFilenamesToIndex = computed(() {
      final map = <String, int>{};
      for (var i = 0; i < _entries.value.length; i++) {
        map[p.canonicalize(_entries.value[i].filename)] = i;
      }
      return map;
    });
    canonicalFilenames = computed(
      () => _canonicalFilenamesToIndex.value.keys.toSet(),
    );
  }

  int getIndexForVideo(MediaFile video) {
    final videoPath = p.canonicalize(video.mediaPath);
    return _canonicalFilenamesToIndex.value[videoPath] ?? -1;
  }

  // Parses mpv's `playlist` property (a JSON array of entries). We only use
  // each entry's `id`, `filename`, and `current` flag; see the mpv manual's
  // "playlist" property for the full sub-property list.
  static PlaylistModel fromJson(String jsonString) {
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

        if (id != null && filename != null) {
          items.add(PlaylistItem(id, filename, current ?? false));
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
