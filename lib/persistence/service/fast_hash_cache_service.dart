import 'package:syncopathy/objectbox.g.dart';
import 'package:syncopathy/persistence/entities/fast_hash_cache.dart';

class FastHashCacheService {
  final Box<FastHashCache> _box;

  FastHashCacheService(Store store) : _box = store.box<FastHashCache>();

  FastHashCache? getByPath(String path) {
    final query = _box.query(FastHashCache_.path.equals(path)).build();
    try {
      return query.findFirst();
    } finally {
      query.close();
    }
  }

  void put(FastHashCache cache) {
    // Check if it already exists to avoid duplicates
    final existing = getByPath(cache.path);
    if (existing != null) {
      cache.id = existing.id;
    }
    _box.put(cache);
  }
}
