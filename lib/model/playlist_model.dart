import 'package:collection/collection.dart';
import 'package:signals/signals_flutter.dart';
import 'package:syncopathy/model/video.dart';

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

  int getIndexForVideo(Video video) {
    final videoPath = Uri.file(video.url).toFilePath(windows: false);

    return _entries.indexWhere(
      (v) => Uri.file(v.filename).toFilePath(windows: false) == videoPath,
    );
  }
}

class PlaylistItem {
  final int id;
  final String filename;
  final bool current;
  PlaylistItem(this.id, this.filename, this.current);
}
