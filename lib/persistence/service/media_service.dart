import 'package:objectbox/objectbox.dart';
import 'package:syncopathy/persistence/entities/media_file.dart';

class MediaService {
  final Box<MediaFile> _box;
  MediaService(Store store) : _box = store.box<MediaFile>();

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
}
