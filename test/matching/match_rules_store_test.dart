import 'package:flutter_test/flutter_test.dart';
import 'package:syncopathy/ioc.dart';
import 'package:syncopathy/media_library/matching/fuzzy_matcher.dart';
import 'package:syncopathy/media_library/matching/match_rules_store.dart';
import 'package:syncopathy/media_library/matching/match_snapshot.dart';
import 'package:syncopathy/platform/key_value_store/key_value_store.dart';

/// In-memory stand-in for the real key-value store, so the rules can be tested
/// without ObjectBox or shared preferences.
class _FakeKeyValueStore implements IKeyValueStore {
  final Map<String, Map<String, dynamic>> values = {};

  @override
  Future<Map<String, dynamic>?> get(String key) async => values[key];

  @override
  Future<void> put(String key, Map<String, dynamic> json) async {
    values[key] = json;
  }
}

MediaSnapshot _media(String basename) =>
    MediaSnapshot(fileHash: 'media:$basename', basename: basename);

FunscriptSnapshot _script(String basename) =>
    FunscriptSnapshot(funscriptHash: 'script:$basename', basename: basename);

void main() {
  late _FakeKeyValueStore store;

  setUp(() {
    store = _FakeKeyValueStore();
    getIt.registerSingleton<IKeyValueStore>(store);
  });

  tearDown(() => getIt.reset());

  test('a rejection survives a reload', () async {
    final rules = MatchRulesStore();
    await rules.load();
    await rules.reject([('script:a', 'media:b')]);

    final reloaded = MatchRulesStore();
    await reloaded.load();

    expect(reloaded.isRejected('script:a', 'media:b'), isTrue);
    expect(reloaded.isRejected('script:a', 'media:other'), isFalse);
  });

  test('clearing forgets everything', () async {
    final rules = MatchRulesStore();
    await rules.load();
    await rules.reject([('script:a', 'media:b')]);
    await rules.clear();

    final reloaded = MatchRulesStore();
    await reloaded.load();
    expect(reloaded.rejectedPairs, isEmpty);
  });

  test('a corrupt blob loads as empty instead of failing', () async {
    store.values['funscript_match_rules'] = {'rejected': 'not a list'};

    final rules = MatchRulesStore();
    await rules.load();

    expect(rules.rejectedPairs, isEmpty);
  });

  test('a rejected pair is not offered again', () async {
    final rules = MatchRulesStore();
    await rules.load();

    final library = [_media('Alpha Beta Gamma'), _media('Alpha Beta Delta')];
    final script = _script('alpha beta gamma');

    final before = FuzzyMatcher(library).proposeFor(script);
    expect(before.best!.media.basename, 'Alpha Beta Gamma');

    await rules.reject([(script.funscriptHash, 'media:Alpha Beta Gamma')]);

    final after = FuzzyMatcher(
      library,
      rejectedPairs: rules.rejectedPairs,
    ).proposeFor(script);

    // Excluded outright rather than ranked lower: a suggestion someone has
    // already turned down is noise on every later pass.
    expect(
      after.candidates.map((c) => c.media.basename),
      isNot(contains('Alpha Beta Gamma')),
    );
  });

  test('rejections are keyed per script, not per media', () async {
    final rules = MatchRulesStore();
    await rules.load();
    await rules.reject([('script:one', 'media:shared')]);

    expect(rules.isRejected('script:one', 'media:shared'), isTrue);
    // Another script may still legitimately belong to that same video.
    expect(rules.isRejected('script:two', 'media:shared'), isFalse);
  });

  test('the stored key matches what the matcher looks up', () async {
    final rules = MatchRulesStore();
    await rules.load();
    await rules.reject([('script:a', 'media:b')]);

    expect(rules.rejectedPairs, contains(matchPairKey('script:a', 'media:b')));
  });
}
