import 'package:collection/collection.dart';
import 'package:objectbox/objectbox.dart';
import 'package:syncopathy/persistence/entities/funscript_file.dart';

class FunscriptService {
  final Box<FunscriptFile> _box;
  FunscriptService(Store store) : _box = store.box<FunscriptFile>();

  int save(FunscriptFile mediaList) {
    return _box.put(mediaList);
  }

  List<String> getAllAuthors() {
    return _box
        .getAll()
        .map((f) => f.metadata?.creator?.trim())
        .where((c) => c != null && c.isNotEmpty)
        .cast<String>()
        .toSet()
        .sorted()
        .toList();
  }

  List<String> getAllTags() {
    return _box
        .getAll()
        .expand<String>((f) => f.metadata?.tags ?? const [])
        .map((t) => t.trim())
        .where((t) => t.isNotEmpty)
        .toSet()
        .sorted()
        .toList();
  }

  List<String> getAllPerformers() {
    return _box
        .getAll()
        .expand<String>((f) => f.metadata?.performers ?? const [])
        .map((t) => t.trim())
        .where((t) => t.isNotEmpty)
        .toSet()
        .sorted()
        .toList();
  }

  List<FunscriptFile> getAll() => _box.getAll();

  Future<List<FunscriptFile>> getAllAsync() async => _box.getAllAsync();
}
