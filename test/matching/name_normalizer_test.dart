import 'package:flutter_test/flutter_test.dart';
import 'package:syncopathy/media_library/matching/name_normalizer.dart';

/// Normalization decides what the fuzzy matcher is even allowed to compare, so
/// every scoring result rests on these reductions being right.
void main() {
  group('noise removal', () {
    test('release tags are dropped, title words are kept', () {
      final name = normalizeName('Alpha.Beta.1080p.WEB-DL.x265-GROUP');

      expect(name.tokens, ['alpha', 'beta', 'group']);
      // `WEB-DL` folds into two tokens, so both halves have to be known noise.
      expect(name.noiseTokens, containsAll(['1080p', 'web', 'dl', 'x265']));
    });

    test('a VR release reduces to the same stem as a plain one', () {
      final vr = normalizeName('Alpha.Beta.8K.VR180.MKX200.60FPS.h265');
      final plain = normalizeName('Alpha Beta');

      expect(vr.stem, plain.stem);
    });

    test('a title made only of noise words survives as empty, not as noise', () {
      final name = normalizeName('1080p.x264');

      expect(name.tokens, isEmpty);
      expect(name.isEmpty, isTrue);
    });
  });

  group('separator and case folding', () {
    test('punctuation variants normalize alike', () {
      final expected = normalizeName('Alpha Beta Gamma').stem;

      expect(normalizeName('alpha_beta-gamma').stem, expected);
      expect(normalizeName('Alpha.Beta.Gamma').stem, expected);
      expect(normalizeName('[Alpha] (Beta) {Gamma}').stem, expected);
    });

    test('camelCase is split so it shares words with the separated form', () {
      expect(normalizeName('AlphaBetaGamma').tokens, [
        'alpha',
        'beta',
        'gamma',
      ]);
      // A run of capitals splits only where a new word starts.
      expect(normalizeName('ABCVideoClip').tokens, ['abc', 'video', 'clip']);
      // ...and a digit before a capital is not a word start, so release tags
      // survive intact and get recognized as noise.
      expect(normalizeName('Alpha 8K 60FPS').tokens, ['alpha']);
    });

    test('apostrophes close up rather than splitting a word', () {
      expect(normalizeName("Girl's Night").tokens, ['girls', 'night']);
    });

    test('accented letters fold to their base letter', () {
      expect(normalizeName('Björk Ångström').tokens, ['bjork', 'angstrom']);
    });
  });

  group('identifiers', () {
    test('a studio code normalizes the same however it is punctuated', () {
      const expected = {'abp123'};

      expect(normalizeName('ABP-123 Title').identifiers, expected);
      expect(normalizeName('ABP123 Title').identifiers, expected);
      expect(normalizeName('abp_123_title').identifiers, expected);
    });

    test('a full date becomes one identifier however it is written', () {
      expect(normalizeName('Studio 2023-05-14 Title').identifiers, {
        '20230514',
      });
      expect(normalizeName('Studio.20230514.Title').identifiers, {'20230514'});
    });

    test('a bare year is not treated as part of a scene code', () {
      // Otherwise the same studio in two years would read as two conflicting
      // identifiers rather than as one shared studio name.
      expect(normalizeName('Studio 2023 Title').identifiers, isEmpty);
    });
  });

  group('ordinals', () {
    test('season/episode is read out of the combined token', () {
      final name = normalizeName('Alpha.Beta.S01E02.1080p');

      expect(name.ordinals, {OrdinalKind.season: 1, OrdinalKind.episode: 2});
      // Consumed, not left in the text: two episodes must not look like the
      // same title with a one-character difference.
      expect(name.tokens, ['alpha', 'beta']);
    });

    test('detached and attached scene numbers read the same', () {
      expect(normalizeName('Studio - Scene 3 - Title').ordinals, {
        OrdinalKind.scene: 3,
      });
      expect(normalizeName('Studio.Scene3.Title').ordinals, {
        OrdinalKind.scene: 3,
      });
    });

    test('part and disc markers are recognized', () {
      expect(normalizeName('Title pt2').ordinals, {OrdinalKind.part: 2});
      expect(normalizeName('Title CD1').ordinals, {OrdinalKind.part: 1});
    });

    test('a marker word not followed by a number stays an ordinary word', () {
      final name = normalizeName('Scene Of The Crime');

      expect(name.ordinals, isEmpty);
      expect(name.tokens, ['scene', 'of', 'the', 'crime']);
    });
  });

  group('funscript axis suffixes', () {
    test('a companion axis normalizes to the same stem as its stroke script', () {
      final stroke = normalizeName('Alpha Beta', stripAxis: true);

      expect(normalizeName('Alpha Beta.twist', stripAxis: true).stem,
          stroke.stem);
      expect(normalizeName('Alpha Beta_R1', stripAxis: true).stem, stroke.stem);
      expect(normalizeName('Alpha Beta.L0', stripAxis: true).stem, stroke.stem);
    });

    test('an unrecognized suffix is left alone', () {
      // `part2` is a real part of the name, not an axis.
      expect(
        normalizeName('Alpha Beta.part2', stripAxis: true).ordinals,
        {OrdinalKind.part: 2},
      );
    });

    test('media names never have an axis stripped', () {
      // A video legitimately named `... roll` must keep the word.
      expect(normalizeName('Drum Roll').tokens, ['drum', 'roll']);
    });
  });

  test('trigrams pad both ends so short names still compare', () {
    expect(trigramsOf('ab'), {'  a', ' ab', 'ab '});
    expect(trigramsOf(''), isEmpty);
  });

  test('isNoiseToken reports what the reduction dropped', () {
    expect(isNoiseToken('1080P'), isTrue);
    expect(isNoiseToken('alpha'), isFalse);
  });
}
