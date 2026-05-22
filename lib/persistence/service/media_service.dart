import 'package:rxdart/rxdart.dart';
import 'package:signals/signals_flutter.dart';
import 'package:syncopathy/objectbox.g.dart';
import 'package:syncopathy/persistence/entities/media_file.dart';

class MediaService {
  final Box<MediaFile> _box;

  ReadonlySignal<List<MediaFile>> get allMediaFiles => _allMediaFiles;
  late final Signal<List<MediaFile>> _allMediaFiles = signal([]);

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

  MediaFile? getByHash(String hash) {
    final query = _box.query(MediaFile_.fileHash.equals(hash)).build();
    try {
      return query.findFirst();
    } finally {
      query.close();
    }
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
    final terms = query
        .split(' ')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();

    if (terms.isEmpty) {
      return getAll();
    }

    Condition<MediaFile>? condition;
    for (final term in terms) {
      final termCondition =
          MediaFile_.name.contains(term, caseSensitive: false) |
          MediaFile_.dbAliases.contains(term, caseSensitive: false);
      if (condition == null) {
        condition = termCondition;
      } else {
        condition = condition & termCondition;
      }
    }

    final q = _box.query(condition).build();
    try {
      return q.find();
    } finally {
      q.close();
    }
  }

  MediaFile? getById(int id) {
    return _box.get(id);
  }

  Future<List<MediaFile>> getAllAsync() async => _box.getAllAsync();

  bool remove(int id) {
    return _box.remove(id);
  }
}
