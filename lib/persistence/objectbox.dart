import 'package:path/path.dart' as p;

import 'package:syncopathy/objectbox.g.dart';
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

  ObjectBox._create(this.store) {
    keyValueService = KeyValueService(store);
    userCategoryService = UserCategoryService(store);
    mediaService = MediaService(store);
    funscriptService = FunscriptService(store);
  }

  static Future<ObjectBox> create(String path) async {
    final store = await openStore(directory: p.join(path, "objectbox_beta"));
    return ObjectBox._create(store);
  }
}
