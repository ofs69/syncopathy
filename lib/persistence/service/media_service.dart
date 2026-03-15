import 'package:rxdart/rxdart.dart';
import 'package:signals/signals_flutter.dart';
import 'package:syncopathy/objectbox.g.dart';
import 'package:syncopathy/persistence/entities/media_file.dart';

class MediaService {
  final Box<MediaFile> _box;

  ReadonlySignal<List<MediaFile>> get allMediaFiles => _allMediaFiles;
  late final Signal<List<MediaFile>> _allMediaFiles = signal([]);

  late final searchQuery = _box
      .query(
        MediaFile_.name.contains(
              '',
              caseSensitive: false,
              alias: 'nameFilter',
            ) |
            MediaFile_.dbAliases.contains(
              '',
              caseSensitive: false,
              alias: 'aliasFilter',
            ),
      )
      .build();

  MediaService(Store store) : _box = store.box<MediaFile>() {
    _box
        .query()
        .watch(triggerImmediately: true)
        .debounceTime(Duration(milliseconds: 100))
        .listen((query) {
          _allMediaFiles.value = query.find();
        });
  }

  int save(MediaFile media) {
    return _box.put(media);
  }

  void resetAllVideosPlayCount() {
    final allMedia = _box.getAll();
    for (var media in allMedia) {
      media.playCount = 0;
    }
    _box.putMany(allMedia);
  }

  List<MediaFile> getAll() => _box.getAll();

  List<MediaFile> findByQuery(String query) {
    searchQuery.param(MediaFile_.name, alias: 'nameFilter').value = query;
    searchQuery.param(MediaFile_.dbAliases, alias: 'aliasFilter').value = query;
    return searchQuery.find();
  }
}
