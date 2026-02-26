import 'package:path/path.dart' as p;

import 'package:syncopathy/objectbox.g.dart';
import 'package:syncopathy/persistence/service/funscript_service.dart';
import 'package:syncopathy/persistence/service/key_value_service.dart';
import 'package:syncopathy/persistence/service/media_list_service.dart';
import 'package:syncopathy/persistence/service/media_service.dart';

class ObjectBox {
  late final Store store;
  late final KeyValueService keyValueService;
  late final MediaListService mediaListService;
  late final MediaService mediaService;
  late final FunscriptService funscriptService;

  ObjectBox._create(this.store) {
    keyValueService = KeyValueService(store);
    mediaListService = MediaListService(store);
    mediaService = MediaService(store);
    funscriptService = FunscriptService(store);
  }

  static Future<ObjectBox> create(String path) async {
    final store = await openStore(directory: p.join(path, "objectbox"));
    return ObjectBox._create(store);
  }
}
