import 'package:objectbox/objectbox.dart';
import 'package:syncopathy/persistence/entities/media.dart';

class MediaService {
  final Box<Media> _box;
  MediaService(Store store) : _box = store.box<Media>();

  int save(Media media) {
    return _box.put(media);
  }
}
