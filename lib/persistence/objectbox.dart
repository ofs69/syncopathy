import 'package:path/path.dart' as p;

import 'package:syncopathy/objectbox.g.dart';
import 'package:syncopathy/persistence/repository/media_repository.dart';
import 'package:syncopathy/persistence/service/fast_hash_cache_service.dart';
import 'package:syncopathy/persistence/service/funscript_service.dart';
import 'package:syncopathy/persistence/service/key_value_service.dart';
import 'package:syncopathy/persistence/service/user_category_service.dart';
import 'package:syncopathy/persistence/service/media_service.dart';

class ObjectBox {
  late final Store store;
  late final KeyValueService keyValueService;
  late final UserCategoryService userCategoryService;
  late final MediaService mediaService;
  late final FunscriptService funscriptService;
  late final FastHashCacheService fastHashCacheService;

  /// Intent-named command layer over [mediaService]/[funscriptService]; the UI
  /// routes entity mutations through this instead of saving inline.
  late final MediaRepository mediaRepository;

  ObjectBox._create(this.store) {
    keyValueService = KeyValueService(store);
    userCategoryService = UserCategoryService(store);
    mediaService = MediaService(store);
    funscriptService = FunscriptService(store);
    fastHashCacheService = FastHashCacheService(store);
    mediaRepository = MediaRepository(mediaService, funscriptService);

    // Remove this at some point in the future
    funscriptService.removeDuplicates(store);
  }

  static Future<ObjectBox> create(String path) async {
    final store = await openStore(directory: p.join(path, "objectbox"));
    return ObjectBox._create(store);
  }
}
