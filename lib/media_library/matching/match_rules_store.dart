import 'package:syncopathy/logging.dart';
import 'package:syncopathy/media_library/matching/fuzzy_matcher.dart';
import 'package:syncopathy/platform/key_value_store/key_value_store.dart';

/// The pairs a reviewer has already turned down.
///
/// Persisted rather than kept per session, because the value of saying "no" is
/// entirely in not being asked again: a tool that re-offers the same wrong
/// suggestion after every scan is one people stop opening. Stored as opaque
/// hash pairs — no paths, no names.
///
/// Accepted matches need no equivalent. Applying one writes a real relation,
/// and indexing only ever adds to those, so the link survives later scans by
/// itself.
class MatchRulesStore {
  static const String _key = 'funscript_match_rules';
  static const int _version = 1;

  /// Ceiling on retained rejections. Old ones are dropped first: a rejection
  /// from long enough ago is likely about files that no longer exist, and an
  /// unbounded list would grow with every session forever.
  static const int _maxRejected = 5000;

  /// Insertion-ordered, so trimming drops the oldest.
  final Set<String> _rejected = <String>{};

  Set<String> get rejectedPairs => Set.unmodifiable(_rejected);

  bool isRejected(String funscriptHash, String mediaHash) =>
      _rejected.contains(matchPairKey(funscriptHash, mediaHash));

  Future<void> load() async {
    try {
      final stored = await KVStore.get(_key);
      if (stored == null) return;
      final pairs = stored['rejected'];
      if (pairs is! List) return;
      _rejected
        ..clear()
        ..addAll(pairs.whereType<String>());
    } catch (e, st) {
      // A corrupt rules blob must not stop the tool opening; the worst case is
      // that a previously rejected pair is offered again.
      Logger.error('Failed to load funscript match rules', e, st);
    }
  }

  Future<void> reject(Iterable<(String funscriptHash, String mediaHash)> pairs) {
    for (final (funscriptHash, mediaHash) in pairs) {
      _rejected.add(matchPairKey(funscriptHash, mediaHash));
    }
    return _save();
  }

  /// Forgets every rejection, so the next pass proposes them again. The escape
  /// hatch for a reviewer who worked through a session too quickly.
  Future<void> clear() {
    _rejected.clear();
    return _save();
  }

  Future<void> _save() async {
    if (_rejected.length > _maxRejected) {
      final trimmed = _rejected.skip(_rejected.length - _maxRejected).toList();
      _rejected
        ..clear()
        ..addAll(trimmed);
    }
    try {
      await KVStore.put(_key, {
        'version': _version,
        'rejected': _rejected.toList(),
      });
    } catch (e, st) {
      Logger.error('Failed to save funscript match rules', e, st);
    }
  }
}
