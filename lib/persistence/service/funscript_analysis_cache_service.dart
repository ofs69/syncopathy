import 'package:syncopathy/objectbox.g.dart';
import 'package:syncopathy/persistence/entities/funscript_analysis_cache.dart';

class FunscriptAnalysisCacheService {
  final Box<FunscriptAnalysisCache> _box;

  FunscriptAnalysisCacheService(Store store)
    : _box = store.box<FunscriptAnalysisCache>();

  /// Every cached analysis, keyed by hash.
  ///
  /// One read rather than a query per script: a scan asks about its whole
  /// residual at once, and that runs to thousands of files in the libraries
  /// this tool exists for.
  Map<String, FunscriptAnalysisCache> getAll() => {
    for (final entry in _box.getAll()) entry.funscriptHash: entry,
  };

  /// Writes [entries] in one transaction. Rows carrying an id are updated;
  /// a new row replaces any existing one with the same hash.
  void putMany(List<FunscriptAnalysisCache> entries) {
    if (entries.isEmpty) return;
    _box.putMany(entries);
  }
}
