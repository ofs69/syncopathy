import 'package:flutter_test/flutter_test.dart';
import 'package:syncopathy/ioc.dart';
import 'package:syncopathy/media_library/matching/match_discovery.dart';
import 'package:syncopathy/media_library/matching/match_rules_store.dart';
import 'package:syncopathy/media_library/matching/matching_session_model.dart';
import 'package:syncopathy/media_library/matching/matching_settings.dart';
import 'package:syncopathy/model/settings_model.dart';
import 'package:syncopathy/platform/key_value_store/key_value_store.dart';
import 'package:syncopathy/persistence/entities/media_file.dart';

class _FakeKeyValueStore implements IKeyValueStore {
  final Map<String, Map<String, dynamic>> values = {};

  @override
  Future<Map<String, dynamic>?> get(String key) async => values[key];

  @override
  Future<void> put(String key, Map<String, dynamic> json) async {
    values[key] = json;
  }
}

UnmatchedMedia _media(String basename) => UnmatchedMedia(
  fileHash: 'media:$basename',
  path: '/library/$basename.mp4',
  basename: basename,
  directoryLabel: 'library',
  type: MediaType.video,
  inLibrary: true,
);

UnmatchedFunscript _script(String basename) => UnmatchedFunscript(
  funscriptHash: 'script:$basename',
  path: '/library/$basename.funscript',
  basename: basename,
  directoryLabel: 'library',
  averageSpeed: 100,
  averageMin: 0,
  averageMax: 100,
  isScriptToken: false,
  inLibrary: false,
);

MatchDiscoveryResult _discovery({
  required List<UnmatchedMedia> media,
  required List<UnmatchedFunscript> scripts,
}) => MatchDiscoveryResult(
  media: media,
  scripts: scripts,
  trieResolvableScripts: 0,
  totalMediaFiles: media.length,
  totalScriptFiles: scripts.length,
  skippedPaths: const [],
);

/// The noise list decides what two filenames are even allowed to agree on, so a
/// user editing it is editing the matcher itself. These cover the round trip:
/// the word goes in, it survives a save, and the next ranking is built with it.
void main() {
  late _FakeKeyValueStore store;

  setUp(() {
    store = _FakeKeyValueStore();
    getIt.registerSingleton<IKeyValueStore>(store);
  });

  tearDown(() => getIt.reset());

  group('editing the list', () {
    test('a word is normalized on the way in', () async {
      final options = FunscriptMatchingSettings();
      addTearDown(options.dispose);

      expect(options.addNoiseWord('  Björk '), 'bjork');
      expect(options.extraNoiseWords.value, {'bjork'});
    });

    test('a word already in the list is not added twice', () async {
      final options = FunscriptMatchingSettings();
      addTearDown(options.dispose);

      expect(options.addNoiseWord('studio'), 'studio');
      expect(options.addNoiseWord('STUDIO'), isNull);
      expect(options.extraNoiseWords.value, {'studio'});
    });

    test('input with nothing usable in it is refused', () async {
      final options = FunscriptMatchingSettings();
      addTearDown(options.dispose);

      expect(options.addNoiseWord('  '), isNull);
      expect(options.extraNoiseWords.value, isEmpty);
    });

    test('removing a word leaves the rest alone', () async {
      final options = FunscriptMatchingSettings();
      addTearDown(options.dispose);

      options.addNoiseWord('studio');
      options.addNoiseWord('label');
      options.removeNoiseWord('studio');

      expect(options.extraNoiseWords.value, {'label'});
    });

    test('a built-in word can be turned off and back on', () async {
      final options = FunscriptMatchingSettings();
      addTearDown(options.dispose);

      expect(options.builtinIsNoise('quest'), isTrue);

      options.setBuiltinIsNoise('quest', false);
      expect(options.builtinIsNoise('quest'), isFalse);
      expect(options.noiseVocabulary.isNoise('quest'), isFalse);

      options.restoreBuiltinNoiseWords();
      expect(options.builtinIsNoise('quest'), isTrue);
      expect(options.noiseVocabulary.isNoise('quest'), isTrue);
    });

    test('the vocabulary carries both halves of the edit', () async {
      final options = FunscriptMatchingSettings();
      addTearDown(options.dispose);

      options.addNoiseWord('Studio');
      options.setBuiltinIsNoise('final', false);

      final vocabulary = options.noiseVocabulary;
      expect(vocabulary.isNoise('studio'), isTrue);
      expect(vocabulary.isNoise('final'), isFalse);
      expect(vocabulary.isNoise('1080p'), isTrue);
      expect(vocabulary.isStandard, isFalse);
    });
  });

  group('persistence', () {
    test('both lists survive a save and a reload', () async {
      final options = FunscriptMatchingSettings();
      await options.load();
      options.addNoiseWord('studio');
      options.setBuiltinIsNoise('quest', false);
      // The save is debounced; wait it out rather than reaching into it.
      await Future<void>.delayed(const Duration(milliseconds: 700));
      options.dispose();

      final reloaded = FunscriptMatchingSettings();
      addTearDown(reloaded.dispose);
      await reloaded.load();

      expect(reloaded.extraNoiseWords.value, {'studio'});
      expect(reloaded.matchedBuiltinWords.value, {'quest'});
    });

    test('a stored word the built-in list no longer has is dropped', () async {
      store.values['funscript_matching_settings'] = {
        'matchedBuiltinWords': ['quest', 'nolongerbuiltin'],
        'extraNoiseWords': ['Studio', '   ', 42],
      };

      final options = FunscriptMatchingSettings();
      addTearDown(options.dispose);
      await options.load();

      expect(options.matchedBuiltinWords.value, {'quest'});
      // Normalized and filtered on the way in, so nothing unusable is stored.
      expect(options.extraNoiseWords.value, {'studio'});
    });
  });

  group('re-ranking with the edited list', () {
    MatchingSessionModel sessionOver(
      FunscriptMatchingSettings options, {
      required List<String> media,
      required String script,
    }) {
      final session = MatchingSessionModel(
        SettingsModel(),
        options,
        MatchRulesStore(),
      );
      session.discovery.value = _discovery(
        media: [for (final name in media) _media(name)],
        scripts: [_script(script)],
      );
      return session;
    }

    test('an added word stops being evidence after a re-rank', () {
      final options = FunscriptMatchingSettings();
      addTearDown(options.dispose);
      // Two videos of one studio; the script names only one of them, and the
      // studio word is the whole of the other one's case.
      final session = sessionOver(
        options,
        media: ['Bigstudio Zebracorn Waltzing', 'Bigstudio Marmalade Skyline'],
        script: 'Bigstudio Zebracorn Waltzing',
      );
      addTearDown(session.dispose);

      session.rerank();
      expect(session.draft.value!.proposals.single.candidates, hasLength(2));

      options.addNoiseWord('bigstudio');
      session.rerank();

      // The studio word is gone from both sides, so the only agreement left is
      // the real title — which the other video shares none of.
      final after = session.draft.value!.proposals.single;
      expect(after.candidates, hasLength(1));
      expect(after.best!.media.basename, 'Bigstudio Zebracorn Waltzing');
    });

    test('a word turned back on tells two videos apart again', () {
      final options = FunscriptMatchingSettings();
      addTearDown(options.dispose);
      // `quest` and `final` are both built-in noise, so out of the box these
      // two videos reduce to the same name and neither can be ruled out.
      final session = sessionOver(
        options,
        media: ['Zebracorn Quest', 'Zebracorn Final'],
        script: 'Zebracorn Quest',
      );
      addTearDown(session.dispose);

      session.rerank();
      expect(session.draft.value!.proposals.single.candidates, hasLength(2));

      options.setBuiltinIsNoise('quest', false);
      options.setBuiltinIsNoise('final', false);
      session.rerank();

      final after = session.draft.value!.proposals.single;
      expect(after.best!.media.basename, 'Zebracorn Quest');
      expect(after.best!.score, greaterThan(after.candidates.last.score));
    });
  });
}
