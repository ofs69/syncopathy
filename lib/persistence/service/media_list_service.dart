import 'package:objectbox/objectbox.dart';
import 'package:syncopathy/persistence/entities/media_list.dart';

class MediaListService {
  final Box<MediaList> _box;
  MediaListService(Store store) : _box = store.box<MediaList>();

  int save(MediaList mediaList) {
    return _box.put(mediaList);
  }
}
