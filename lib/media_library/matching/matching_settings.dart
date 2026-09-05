import 'package:signals/signals_flutter.dart';
import 'package:syncopathy/helper/debouncer.dart';
import 'package:syncopathy/logging.dart';
import 'package:syncopathy/media_library/matching/fuzzy_matcher.dart';
import 'package:syncopathy/media_library/matching/name_normalizer.dart';
import 'package:syncopathy/platform/key_value_store/key_value_store.dart';

/// Settings for the funscript matching tool.
///
/// Kept here and surfaced inside the tool rather than on the general settings
/// page: none of it means anything until the tool is open.
class FunscriptMatchingSettings {
  static const String _key = 'funscript_matching_settings';

  final Signal<int> maxCandidates = signal(
    const MatchingOptions().maxCandidates,
  );
  final Signal<double> minimumScore = signal(
    const MatchingOptions().minimumScore,
  );
  final Signal<bool> useDirectoryLabels = signal(true);
  final Signal<bool> useScriptMetadata = signal(true);
  final Signal<bool> requireDistinctiveEvidence = signal(
    const MatchingOptions().requireDistinctiveEvidence,
  );

  /// Words this library repeats everywhere, dropped on top of the built-in
  /// list. Already normalized — see [normalizeNoiseWord].
  final Signal<Set<String>> extraNoiseWords = signal(const <String>{});

  /// Built-in noise words the user wants matched on after all.
  final Signal<Set<String>> matchedBuiltinWords = signal(const <String>{});

  final _debouncer = Debouncer(milliseconds: 500);
  EffectCleanup? _saveEffect;

  NoiseVocabulary get noiseVocabulary => NoiseVocabulary(
    extraWords: extraNoiseWords.value,
    matchedWords: matchedBuiltinWords.value,
  );

  /// Adds [input] to [extraNoiseWords], normalized. Returns the word as it was
  /// stored, or null when the input held nothing usable or was already there.
  String? addNoiseWord(String input) {
    final word = normalizeNoiseWord(input);
    if (word == null || extraNoiseWords.value.contains(word)) return null;
    extraNoiseWords.value = {...extraNoiseWords.value, word};
    return word;
  }

  void removeNoiseWord(String word) {
    if (!extraNoiseWords.value.contains(word)) return;
    extraNoiseWords.value = {...extraNoiseWords.value}..remove(word);
  }

  /// Whether [word] — a built-in noise word — is currently being dropped.
  bool builtinIsNoise(String word) => !matchedBuiltinWords.value.contains(word);

  /// Sets whether a built-in noise word is dropped ([isNoise]) or matched on.
  void setBuiltinIsNoise(String word, bool isNoise) {
    final next = {...matchedBuiltinWords.value};
    if (isNoise ? !next.remove(word) : !next.add(word)) return;
    matchedBuiltinWords.value = next;
  }

  /// Puts every built-in word back to dropping.
  void restoreBuiltinNoiseWords() {
    if (matchedBuiltinWords.value.isEmpty) return;
    matchedBuiltinWords.value = const <String>{};
  }

  MatchingOptions get matchingOptions => MatchingOptions(
    maxCandidates: maxCandidates.value,
    minimumScore: minimumScore.value,
    useDirectoryLabels: useDirectoryLabels.value,
    useScriptMetadata: useScriptMetadata.value,
    requireDistinctiveEvidence: requireDistinctiveEvidence.value,
  );


  Future<void> load() async {
    try {
      final stored = await KVStore.get(_key);
      if (stored != null) {
        batch(() {
          maxCandidates.value = _readInt(
            stored['maxCandidates'],
            maxCandidates.value,
          );
          minimumScore.value = _readDouble(
            stored['minimumScore'],
            minimumScore.value,
          );
          useDirectoryLabels.value =
              stored['useDirectoryLabels'] as bool? ?? useDirectoryLabels.value;
          useScriptMetadata.value =
              stored['useScriptMetadata'] as bool? ?? useScriptMetadata.value;
          requireDistinctiveEvidence.value =
              stored['requireDistinctiveEvidence'] as bool? ??
              requireDistinctiveEvidence.value;
          extraNoiseWords.value = _readWords(stored['extraNoiseWords']);
          // Intersected with what the built-in list actually holds: a word
          // dropped from a later release of that list would otherwise sit in
          // storage forever, excusing nothing.
          matchedBuiltinWords.value = _readWords(
            stored['matchedBuiltinWords'],
          ).intersection(builtinNoiseWords);
        });
      }
    } catch (e, st) {
      Logger.error('Failed to load funscript matching settings', e, st);
    }

    // Subscribed only after loading, so restoring stored values doesn't write
    // them straight back out.
    _saveEffect ??= effect(() {
      final snapshot = {
        'maxCandidates': maxCandidates.value,
        'minimumScore': minimumScore.value,
        'useDirectoryLabels': useDirectoryLabels.value,
        'useScriptMetadata': useScriptMetadata.value,
        'requireDistinctiveEvidence': requireDistinctiveEvidence.value,
        // Sorted so an unchanged set serializes identically and the debounced
        // write has nothing to do.
        'extraNoiseWords': extraNoiseWords.value.toList()..sort(),
        'matchedBuiltinWords': matchedBuiltinWords.value.toList()..sort(),
      };
      _debouncer.run(() => KVStore.put(_key, snapshot));
    });
  }

  void dispose() {
    _saveEffect?.call();
    _saveEffect = null;
    _debouncer.dispose();
  }

  static int _readInt(Object? value, int fallback) =>
      value is int ? value : (value is num ? value.toInt() : fallback);

  static double _readDouble(Object? value, double fallback) =>
      value is num ? value.toDouble() : fallback;

  /// Re-normalizes on the way in as well as on the way out: the built-in list
  /// can change shape between releases, and a stored word that no longer folds
  /// to itself would never fire again.
  static Set<String> _readWords(Object? value) {
    if (value is! List) return const <String>{};
    return {
      for (final entry in value)
        if (entry is String) ?normalizeNoiseWord(entry),
    };
  }
}
