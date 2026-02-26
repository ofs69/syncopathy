import 'package:objectbox/objectbox.dart';
import 'package:syncopathy/persistence/entities/funscript_file.dart';

class FunscriptService {
  final Box<FunscriptFile> _box;
  FunscriptService(Store store) : _box = store.box<FunscriptFile>();

  int save(FunscriptFile mediaList) {
    return _box.put(mediaList);
  }
}
