import 'package:collection/collection.dart';
import 'package:syncopathy/objectbox.g.dart';
import 'package:syncopathy/persistence/entities/funscript_file.dart';
import 'package:syncopathy/persistence/entities/media_file.dart';

class FunscriptService {
  final Box<FunscriptFile> _box;
  FunscriptService(Store store) : _box = store.box<FunscriptFile>();

  int save(FunscriptFile mediaList) {
    return _box.put(mediaList);
  }

  void saveMany(List<FunscriptFile> funscripts) {
    _box.putMany(funscripts);
  }

  FunscriptFile? getByHash(String hash) {
    final query = _box.query(FunscriptFile_.funscriptHash.equals(hash)).build();
    try {
      return query.findFirst();
    } finally {
      query.close();
    }
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

  void removeDuplicates(Store store) {
    final all = _box.getAll();
    final groups = groupBy(all, (f) => f.funscriptHash);

    store.runInTransaction(TxMode.write, () {
      final mediaBox = store.box<MediaFile>();

      for (final entry in groups.entries) {
        final hash = entry.key;
        if (hash.isEmpty) continue;

        final group = entry.value;
        if (group.length <= 1) continue;

        final primary = group.first;
        final duplicates = group.skip(1).toList();

        for (final duplicate in duplicates) {
          // 1. Update MediaFile.mainFunscript
          final mediaWithMain = mediaBox
              .query(MediaFile_.mainFunscript.equals(duplicate.id))
              .build();
          final resultsMain = mediaWithMain.find();
          mediaWithMain.close();

          for (final m in resultsMain) {
            m.mainFunscript.target = primary;
            mediaBox.put(m);
          }

          // 2. Update MediaFile.funscripts
          // Use the backlink from FunscriptFile to find MediaFiles
          for (final m in duplicate.media) {
            m.funscripts.remove(duplicate);
            if (!m.funscripts.contains(primary)) {
              m.funscripts.add(primary);
            }
            mediaBox.put(m);
          }

          // 3. Delete the duplicate
          _box.remove(duplicate.id);
        }
      }
    });
  }
}
