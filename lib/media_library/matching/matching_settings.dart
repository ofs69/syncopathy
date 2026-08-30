import 'package:signals/signals_flutter.dart';
import 'package:syncopathy/helper/debouncer.dart';
import 'package:syncopathy/logging.dart';
import 'package:syncopathy/media_library/matching/fuzzy_matcher.dart';
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


  final _debouncer = Debouncer(milliseconds: 500);
  EffectCleanup? _saveEffect;

  MatchingOptions get matchingOptions => MatchingOptions(
    maxCandidates: maxCandidates.value,
    minimumScore: minimumScore.value,
    useDirectoryLabels: useDirectoryLabels.value,
    useScriptMetadata: useScriptMetadata.value,
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
}
