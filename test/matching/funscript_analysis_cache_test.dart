import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:syncopathy/funscript_algo.dart';
import 'package:syncopathy/media_library/matching/match_discovery.dart';
import 'package:syncopathy/model/json/funscript_metadata.dart';
import 'package:syncopathy/persistence/entities/funscript_analysis_cache.dart';
import 'package:syncopathy/persistence/entities/funscript_file.dart';

/// Reading a funscript is a JSON decode of its whole action array, and the
/// match tool did it again for every unresolved script on every rescan. It is
/// cached now, which only works because what is cached is a function of the
/// file's bytes and nothing else. These cover that split: what [analyze]
/// takes out of the file, and what [toUnmatched] adds back from the library.
void main() {
  late Directory dir;

  setUp(() => dir = Directory.systemTemp.createTempSync('analysis_cache'));
  tearDown(() => dir.deleteSync(recursive: true));

  File write(String name, Map<String, dynamic> json) =>
      File('${dir.path}${Platform.pathSeparator}$name')
        ..writeAsStringSync(jsonEncode(json));

  Map<String, dynamic> script({
    List<Map<String, int>>? actions,
    Map<String, dynamic>? metadata,
  }) => {
    'actions':
        actions ??
        [
          {'at': 0, 'pos': 0},
          {'at': 500, 'pos': 100},
          {'at': 1500, 'pos': 20},
        ],
    'metadata': ?metadata,
  };

  final now = DateTime(2026, 9, 5, 12);

  group('what comes out of the file', () {
    test(
      'the derived numbers are stored with the version that made them',
      () async {
        final analysis = await MatchDiscovery.analyze(
          write('a.funscript', script()),
          'hash-a',
          now,
        );

        expect(analysis, isNotNull);
        expect(analysis!.funscriptHash, 'hash-a');
        expect(analysis.algorithmVersion, FunscriptAlgorithms.algorithmVersion);
        expect(analysis.lastSeenOn, now);
        // The last action is 1500ms in, and the cache keeps seconds.
        expect(analysis.lastActionSeconds, 1.5);
        expect(analysis.averageSpeed, greaterThan(0));
        expect(analysis.isScriptToken, isFalse);
      },
    );

    test('a script with no actions has no last action', () async {
      final analysis = await MatchDiscovery.analyze(
        write('empty.funscript', script(actions: [])),
        'hash-empty',
        now,
      );

      expect(analysis!.lastActionSeconds, isNull);
    });

    test('the file keeps only its own metadata', () async {
      final analysis = await MatchDiscovery.analyze(
        write(
          'm.funscript',
          script(
            metadata: {
              'title': 'A Scene',
              'performers': ['Jane Doe'],
            },
          ),
        ),
        'hash-m',
        now,
      );

      final stored = FunscriptMetadata.fromJson(
        jsonDecode(analysis!.metadataJson!),
      );
      expect(stored.title, 'A Scene');
      expect(stored.performers, ['Jane Doe']);
    });

    test('a file with no metadata caches none', () async {
      final analysis = await MatchDiscovery.analyze(
        write('plain.funscript', script()),
        'hash-plain',
        now,
      );

      expect(analysis!.metadataJson, isNull);
    });

    test('a file that will not parse is skipped, not thrown', () async {
      final broken = File('${dir.path}${Platform.pathSeparator}bad.funscript')
        ..writeAsStringSync('{not json');

      expect(await MatchDiscovery.analyze(broken, 'hash-bad', now), isNull);
    });

    test('a missing file is skipped', () async {
      final missing = File(
        '${dir.path}${Platform.pathSeparator}gone.funscript',
      );

      expect(await MatchDiscovery.analyze(missing, 'hash-gone', now), isNull);
    });
  });

  group('what the library adds back', () {
    FunscriptAnalysisCache cached({String? metadataJson}) =>
        FunscriptAnalysisCache(
          funscriptHash: 'hash-a',
          algorithmVersion: FunscriptAlgorithms.algorithmVersion,
          averageSpeed: 120,
          averageMin: 5,
          averageMax: 95,
          isScriptToken: false,
          lastSeenOn: now,
          metadataJson: metadataJson,
          lastActionSeconds: 1.5,
        );

    FunscriptFile row(FunscriptMetadata? metadata) => FunscriptFile(
      path: r'C:\library\a.funscript',
      averageSpeed: 0,
      averageMin: 0,
      averageMax: 0,
      isScriptToken: false,
      fileNotFound: false,
      funscriptHash: 'hash-a',
      metadata: metadata,
    );

    final file = File(
      [
        '',
        'library',
        'Scene Folder',
        'a.funscript',
      ].join(Platform.pathSeparator),
    );

    test('the path supplies the name and folder, the cache the numbers', () {
      final script = MatchDiscovery.toUnmatched(file, cached(), null);

      expect(script.basename, 'a');
      expect(script.directoryLabel, 'Scene Folder');
      expect(script.funscriptHash, 'hash-a');
      expect(script.averageSpeed, 120);
      expect(script.lastActionSeconds, 1.5);
      // Nothing in the library claims this hash.
      expect(script.inLibrary, isFalse);
    });

    test("the file's own metadata is used when it has any", () {
      final script = MatchDiscovery.toUnmatched(
        file,
        cached(
          metadataJson: jsonEncode({
            'title': '  From The File  ',
            'performers': ['Jane Doe', '  ', 'Someone Else'],
            'duration': 1800,
          }),
        ),
        row(FunscriptMetadata(title: 'From The Library')),
      );

      expect(script.metadataTitle, 'From The File');
      // Blank performer entries are dropped and the rest trimmed.
      expect(script.performers, ['Jane Doe', 'Someone Else']);
      expect(script.metadataDurationSeconds, 1800);
      expect(script.inLibrary, isTrue);
    });

    test('a library row fills in for a file that carries no metadata', () {
      final script = MatchDiscovery.toUnmatched(
        file,
        cached(),
        row(FunscriptMetadata(title: 'From The Library')),
      );

      expect(script.metadataTitle, 'From The Library');
    });

    test('with metadata nowhere, the fields are simply absent', () {
      final script = MatchDiscovery.toUnmatched(file, cached(), row(null));

      expect(script.metadataJson, isNull);
      expect(script.metadataTitle, isNull);
      expect(script.performers, isEmpty);
      expect(script.metadataDurationSeconds, isNull);
    });

    test('a blank title and a zero duration count as absent', () {
      final script = MatchDiscovery.toUnmatched(
        file,
        cached(metadataJson: jsonEncode({'title': '   ', 'duration': 0})),
        null,
      );

      expect(script.metadataTitle, isNull);
      expect(script.metadataDurationSeconds, isNull);
    });
  });
}
