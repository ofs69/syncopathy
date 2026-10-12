import 'package:flutter_test/flutter_test.dart';
import 'package:syncopathy/helper/trie.dart';
import 'package:syncopathy/media_library/matching/fuzzy_matcher.dart';
import 'package:syncopathy/media_library/matching/match_features.dart';
import 'package:syncopathy/media_library/matching/match_snapshot.dart';

MediaSnapshot _media(
  String basename, {
  String? folder,
  double? duration,
  String? hash,
}) => MediaSnapshot(
  fileHash: hash ?? 'media:$basename',
  basename: basename,
  directoryLabel: folder,
  durationSeconds: duration,
);

FunscriptSnapshot _script(
  String basename, {
  String? folder,
  double? duration,
  double? lastAction,
  String? title,
  List<String> performers = const [],
  String? hash,
}) => FunscriptSnapshot(
  funscriptHash: hash ?? 'script:$basename',
  basename: basename,
  directoryLabel: folder,
  metadataDurationSeconds: duration,
  lastActionSeconds: lastAction,
  metadataTitle: title,
  performers: performers,
);

/// Names present in every library so the matcher always has plausible-looking
/// wrong answers to reject rather than a single candidate to fall into. They
/// deliberately share no words with any test case: a distractor that overlaps
/// the target measures an ambiguity the fixture invented, not the matcher.
const List<String> _distractors = [
  'Crimson Harbor Nights 1080p',
  'Midnight Garden Party',
  'Silver Lake Sessions 2160p',
  'Copper Ridge Trail',
  'Velvet Morning Light',
];

List<MediaSnapshot> _library(List<String> names) =>
    [...names, ..._distractors].map((name) => _media(name)).toList();

String? _topName(MatchProposal proposal) => proposal.best?.media.basename;

/// The score that separates every true match in this fixture from every false
/// one. Not a threshold the matcher enforces -- it is a measurement, and it
/// moving is the signal that scoring has changed shape.
const double _separationThreshold = 0.40;

void main() {
  group('name shapes the trie cannot resolve', () {
    test('reordered words still find the right media', () {
      final matcher = FuzzyMatcher(_library(['Alpha Beta Gamma']));

      final proposal = matcher.proposeFor(_script('Gamma Alpha Beta'));

      expect(_topName(proposal), 'Alpha Beta Gamma');
    });

    test(
      'a script with only release noise between it and the media matches',
      () {
        final matcher = FuzzyMatcher(
          _library(['Sierra.Tango.Uniform.2160p.VR180.MKX200.h265-CREW']),
        );

        final proposal = matcher.proposeFor(_script('Sierra Tango Uniform'));

        expect(
          _topName(proposal),
          'Sierra.Tango.Uniform.2160p.VR180.MKX200.h265-CREW',
        );
      },
    );

    test('camelCase on one side and separators on the other still match', () {
      final matcher = FuzzyMatcher(_library(['victor_whiskey_xray']));

      final proposal = matcher.proposeFor(_script('VictorWhiskeyXray'));

      expect(_topName(proposal), 'victor_whiskey_xray');
    });

    test('a shared studio code beats an unrelated name', () {
      final matcher = FuzzyMatcher(
        _library(['ABP123 Some Entirely Different Words']),
      );

      final proposal = matcher.proposeFor(_script('ABP-123'));

      expect(_topName(proposal), 'ABP123 Some Entirely Different Words');
      expect(
        proposal.best!.features.map((f) => f.kind),
        contains(MatchFeatureKind.identifier),
      );
      expect(proposal.best!.evidence, contains('shares identifier abp123'));
    });
  });

  group('cases that must not match', () {
    test('a script with nothing in common yields no candidates', () {
      final matcher = FuzzyMatcher(_library(['Alpha Beta Gamma']));

      final proposal = matcher.proposeFor(_script('Zulu Yankee Whiskey'));

      expect(proposal.hasCandidates, isFalse);
      expect(proposal.best, isNull);
    });

    test('a one-digit scene difference drops out of the suggestions', () {
      final matcher = FuzzyMatcher(
        _library(['Studio.Title.Scene.3.1080p', 'Studio.Title.Scene.4.1080p']),
      );

      final proposal = matcher.proposeFor(_script('Studio Title Scene 3'));

      expect(proposal.candidates, hasLength(1));
      expect(_topName(proposal), 'Studio.Title.Scene.3.1080p');
    });

    test('only the numbering separates two otherwise identical names', () {
      // Scored with no floor so the demoted candidate is still visible: the
      // point is that the text is equally good and the penalty is what decides.
      final matcher = FuzzyMatcher(
        _library(['Studio.Title.Scene.3.1080p', 'Studio.Title.Scene.4.1080p']),
        options: const MatchingOptions(minimumScore: 0),
      );

      final proposal = matcher.proposeFor(_script('Studio Title Scene 3'));
      final wrongScene = proposal.candidates.firstWhere(
        (c) => c.media.basename == 'Studio.Title.Scene.4.1080p',
      );

      expect(
        wrongScene.penalties.map((p) => p.kind),
        contains(MatchPenaltyKind.ordinalConflict),
      );
      expect(wrongScene.evidence, contains('scene 3 vs scene 4'));
      expect(wrongScene.baseScore, closeTo(proposal.best!.baseScore, 0.001));
      expect(wrongScene.score, lessThan(proposal.best!.score * 0.5));
    });

    test('a materially different duration is flagged as a conflict', () {
      final matcher = FuzzyMatcher([
        _media('Alpha Beta', duration: 1800),
        _media('Alpha Beta Extra', duration: 300),
      ]);

      final proposal = matcher.proposeFor(
        _script('Alpha Beta Extra', duration: 1790),
      );

      expect(_topName(proposal), 'Alpha Beta');
      final shortClip = proposal.candidates.firstWhere(
        (c) => c.media.basename == 'Alpha Beta Extra',
      );
      expect(
        shortClip.penalties.map((p) => p.kind),
        contains(MatchPenaltyKind.durationConflict),
      );
    });

    test('a partial script is not penalized for stopping early', () {
      // The only duration signal is the last action, and a script that ends
      // before the video does is the normal shape, not a wrong match.
      final matcher = FuzzyMatcher([_media('Alpha Beta', duration: 1800)]);

      final proposal = matcher.proposeFor(
        _script('Alpha Beta', lastAction: 1550),
      );

      expect(proposal.best!.penalties, isEmpty);
    });

    test('a rejected pair is never offered again', () {
      final media = _media('Alpha Beta Gamma', hash: 'm1');
      final script = _script('Alpha Beta Gamma', hash: 's1');
      final matcher = FuzzyMatcher(
        [media],
        rejectedPairs: {matchPairKey('s1', 'm1')},
      );

      expect(matcher.proposeFor(script).hasCandidates, isFalse);
    });
  });

  group('bounded, explained output', () {
    test('candidates never exceed maxCandidates and are ranked', () {
      final matcher = FuzzyMatcher(
        List.generate(30, (i) => _media('Alpha Beta Variant $i')),
        options: const MatchingOptions(maxCandidates: 5),
      );

      final candidates = matcher.proposeFor(_script('Alpha Beta')).candidates;

      expect(candidates, hasLength(5));
      expect(candidates.map((c) => c.candidateId), [
        'c1',
        'c2',
        'c3',
        'c4',
        'c5',
      ]);
      for (var i = 1; i < candidates.length; i++) {
        expect(candidates[i].score, lessThanOrEqualTo(candidates[i - 1].score));
      }
    });

    test('every candidate carries concrete evidence', () {
      final matcher = FuzzyMatcher([
        _media('Alpha Beta Gamma', folder: 'clips', duration: 1200),
      ]);

      final proposal = matcher.proposeFor(
        _script('Alpha Beta', folder: 'clips', duration: 1200),
      );

      final best = proposal.best!;
      expect(best.features, isNotEmpty);
      for (final feature in best.features) {
        expect(feature.evidence, isNotEmpty);
        expect(feature.value, inInclusiveRange(0.0, 1.0));
      }
      expect(best.score, inInclusiveRange(0.0, 1.0));
      expect(
        best.evidence.join(' '),
        allOf(contains('alpha, beta'), contains('same folder "clips"')),
      );
    });

    test('ranking is deterministic across runs', () {
      List<String> run() =>
          FuzzyMatcher(
                _library(['Alpha Beta One', 'Alpha Beta Two', 'Alpha Three']),
              )
              .proposeFor(_script('Alpha Beta'))
              .candidates
              .map((c) => c.media.basename)
              .toList();

      expect(run(), run());
      expect(run(), isNotEmpty);
    });

    test('genuine ties break by name, not by input order', () {
      List<String> run(List<String> library) => FuzzyMatcher(_library(library))
          .proposeFor(_script('Alpha Beta'))
          .candidates
          .map((c) => c.media.basename)
          .toList();

      // Same length, same overlap, same edit distance from the query: nothing
      // but the tiebreak can order these, and it must not be the input order.
      const expected = ['Alpha Beta Kilo', 'Alpha Beta Zulu'];
      expect(run(['Alpha Beta Zulu', 'Alpha Beta Kilo']), expected);
      expect(run(['Alpha Beta Kilo', 'Alpha Beta Zulu']), expected);
    });

    test('weak candidates are dropped rather than shown', () {
      final matcher = FuzzyMatcher(
        _library(['Alpha Completely Unrelated Words Filling Space Here']),
        options: const MatchingOptions(minimumScore: 0.6),
      );

      expect(matcher.proposeFor(_script('Alpha')).hasCandidates, isFalse);
    });
  });

  group('script metadata', () {
    test('a title in the metadata matches a media the filename does not', () {
      final matcher = FuzzyMatcher(_library(['Romeo Sierra Tango 1080p']));

      final proposal = matcher.proposeFor(
        _script('script_export_0042', title: 'Romeo Sierra Tango'),
      );

      expect(_topName(proposal), 'Romeo Sierra Tango 1080p');
    });

    test('a performer counts only when the whole name is present', () {
      final matcher = FuzzyMatcher([
        _media('Alpha Beta with Jane Doe'),
        _media('Alpha Beta with Jane Smith'),
      ]);

      final proposal = matcher.proposeFor(
        _script('Alpha Beta', performers: ['Jane Doe']),
      );

      expect(_topName(proposal), 'Alpha Beta with Jane Doe');
      expect(proposal.best!.evidence.join(' '), contains('Jane Doe'));
    });

    test('metadata can be turned off', () {
      final matcher = FuzzyMatcher(
        _library(['Romeo Sierra Tango 1080p']),
        options: const MatchingOptions(useScriptMetadata: false),
      );

      final proposal = matcher.proposeFor(
        _script('script_export_0042', title: 'Romeo Sierra Tango'),
      );

      expect(proposal.hasCandidates, isFalse);
    });
  });

  group('multi-axis bundling', () {
    test('companions ride along with their stroke script', () {
      final matcher = FuzzyMatcher(_library(['Alpha Beta Gamma']));

      final proposals = matcher.proposeAll([
        _script('Alpha Beta Gamma.twist', folder: 'clips'),
        _script('Alpha Beta Gamma', folder: 'clips'),
        _script('Alpha Beta Gamma.roll', folder: 'clips'),
      ]);

      expect(proposals, hasLength(1));
      final proposal = proposals.single;
      // The decision is made on the stroke script, never on a twist track.
      expect(proposal.script.basename, 'Alpha Beta Gamma');
      expect(
        proposal.companions.map((s) => s.basename),
        containsAll(['Alpha Beta Gamma.twist', 'Alpha Beta Gamma.roll']),
      );
      expect(proposal.allScripts, hasLength(3));
      expect(_topName(proposal), 'Alpha Beta Gamma');
    });

    test('an explicit stroke script leads when there is no plain one', () {
      final matcher = FuzzyMatcher(_library(['Alpha Beta Gamma']));

      final proposal = matcher.proposeAll([
        _script('Alpha Beta Gamma.R1', folder: 'clips'),
        _script('Alpha Beta Gamma.L0', folder: 'clips'),
      ]).single;

      expect(proposal.script.basename, 'Alpha Beta Gamma.L0');
    });

    test('same-named scripts in different folders stay separate', () {
      final matcher = FuzzyMatcher(_library(['Alpha Beta Gamma']));

      final proposals = matcher.proposeAll([
        _script('Alpha Beta Gamma', folder: 'one', hash: 's1'),
        _script('Alpha Beta Gamma', folder: 'two', hash: 's2'),
      ]);

      expect(proposals, hasLength(2));
    });
  });

  group('what a strong false positive looks like', () {
    /// A library where a large minority of the files are named the same way.
    /// These shared words are what a naive overlap counts, and what says very
    /// little about which entry a script belongs to.
    ///
    /// Deliberately a minority: a word in *most* of a library is house style
    /// and the matcher discounts it to nothing, which is a different case with
    /// its own test below. This fixture is the harder middle — common enough
    /// to be poor evidence, not common enough to throw away.
    List<MediaSnapshot> boilerplate() => [
      for (var i = 1; i <= 8; i++) _media('Studio Productions 2023 Chapter$i'),
      for (var i = 1; i <= 12; i++) _media('Unrelated Recording $i'),
    ];

    double tokenScore(ScoredCandidate candidate) => candidate.features
        .firstWhere((f) => f.kind == MatchFeatureKind.tokenOverlap)
        .value;

    test('a shared word the whole library uses is not distinctive', () {
      final best = FuzzyMatcher(
        boilerplate(),
      ).proposeFor(_script('Studio Productions 2023 Chapter7 Rooftop')).best!;

      expect(best.media.basename, 'Studio Productions 2023 Chapter7');
      // Only "chapter7" actually points at this entry; the rest is the
      // library's house style.
      expect(best.distinctiveTokens, ['chapter7']);
      expect(best.sharedTokens, hasLength(4));
    });

    test('the same overlap counts for more when the words are rare', () {
      // Identical set arithmetic on both sides -- three shared words out of
      // four and three -- so anything that separates them is rarity alone.
      final common = FuzzyMatcher(
        boilerplate(),
      ).proposeFor(_script('Studio Productions 2023 Chapter7 Rooftop')).best!;

      final rare = FuzzyMatcher([
        for (var i = 1; i <= 20; i++)
          _media('Zebracorn$i Waltzing$i Chapter$i'),
      ]).proposeFor(_script('Zebracorn7 Waltzing7 Chapter7 Rooftop')).best!;

      expect(common.sharedTokens, hasLength(4));
      expect(rare.sharedTokens, hasLength(3));
      // Three rare agreements beat four agreements where three are worthless.
      expect(tokenScore(rare), greaterThan(tokenScore(common)));
    });

    test('a script whose real video is absent is flagged, not asserted', () {
      // The right answer is simply not in the library. Something still comes
      // top, which is exactly what makes this the dangerous case.
      final best = FuzzyMatcher(
        boilerplate(),
      ).proposeFor(_script('Studio Productions 2023 Rooftop Interview')).best;

      expect(best, isNotNull);
      expect(best!.distinctiveTokens, isEmpty);
      expect(best.cautions, contains(MatchCaution.commonWordsOnly));
    });

    test('a word in most of the library stops being evidence at all', () {
      // The whole library is one house style, so "studio productions 2023"
      // describes the collection rather than any entry in it. Agreeing on it
      // is not a weak match, it is no match, and the honest answer is silence
      // rather than the best of twenty indistinguishable guesses.
      final proposal = FuzzyMatcher([
        for (var i = 1; i <= 20; i++)
          _media('Studio Productions 2023 Chapter$i'),
      ]).proposeFor(_script('Studio Productions 2023 Rooftop Interview'));

      expect(proposal.candidates, isEmpty);
    });

    test('house style does not drown the one word that identifies a file', () {
      // Every name shares three words and differs in one. That one word is
      // the entire signal, and it has to survive being outnumbered.
      final best = FuzzyMatcher([
        for (var i = 1; i <= 20; i++)
          _media('Studio Productions 2023 Chapter$i'),
      ]).proposeFor(_script('Studio Productions 2023 Chapter7')).best!;

      expect(best.media.basename, 'Studio Productions 2023 Chapter7');
      expect(best.score, greaterThan(_separationThreshold));
    });

    test('a release tag shared by two VR files is not a rare agreement', () {
      // Resolutions and headset names look rare to a matcher that has never
      // seen them before, and rarity is what it trusts most. Nothing about
      // this pair beyond the tags matches, so nothing should come back.
      final proposal = FuzzyMatcher([
        _media('Zebracorn Waltzing 5400x2700 oculusrift 180 LR'),
        ..._library(const []),
      ]).proposeFor(_script('Quartzite Fandango 5400x2700 oculusrift 180 LR'));

      expect(proposal.candidates, isEmpty);
    });

    test('release tags do not stop a real title from matching', () {
      final best =
          FuzzyMatcher([
                _media('Zebracorn Waltzing 5400x2700 oculusrift 180 LR'),
                ..._library(const []),
              ])
              .proposeFor(
                _script('Zebracorn Waltzing 7680x3840 oculusquest2 MKX200'),
              )
              .best!;

      expect(
        best.media.basename,
        'Zebracorn Waltzing 5400x2700 oculusrift 180 LR',
      );
      expect(best.score, greaterThan(_separationThreshold));
    });

    test('a match resting on script metadata alone is flagged', () {
      // The filenames have nothing in common; only the title inside the
      // funscript brought this pair together.
      final best = FuzzyMatcher([
        _media('Zebracorn Waltzing'),
      ]).proposeFor(_script('untitled 0042', title: 'Zebracorn Waltzing')).best;

      expect(best, isNotNull);
      expect(best!.sharedTokens, isEmpty);
      expect(best.cautions, contains(MatchCaution.noSharedWords));
    });

    test('nothing but the names is admitted as such', () {
      final best = FuzzyMatcher([
        _media('Zebracorn Waltzing'),
      ]).proposeFor(_script('Zebracorn Waltzing')).best!;

      // A perfect name match that no duration, folder or metadata corroborates
      // should say so rather than imply certainty.
      expect(best.score, greaterThan(0.9));
      expect(best.cautions, contains(MatchCaution.nameEvidenceOnly));
    });

    test('corroboration removes the name-only caution', () {
      final best =
          FuzzyMatcher([
                _media('Zebracorn Waltzing', folder: 'clips', duration: 1200),
              ])
              .proposeFor(
                _script('Zebracorn Waltzing', folder: 'clips', duration: 1195),
              )
              .best!;

      expect(best.cautions, isEmpty);
    });

    test('a note about missing corroboration does not block a bulk accept', () {
      final best = FuzzyMatcher([
        _media('Zebracorn Waltzing'),
      ]).proposeFor(_script('Zebracorn Waltzing')).best!;

      // Most filename matching has nothing but filenames to go on. Saying so
      // is useful; treating it as a reason to doubt would make every match
      // suspect.
      expect(best.cautions, contains(MatchCaution.nameEvidenceOnly));
      expect(best.isDoubtful, isFalse);
    });

    test('a shared identifier is never called into question', () {
      final best = FuzzyMatcher([
        _media('ABP-123 Studio Productions 2023'),
      ]).proposeFor(_script('abp123')).best!;

      // An exact code agreement is the strongest evidence available; it needs
      // no corroboration and no distinctive words beside it.
      expect(best.cautions, isEmpty);
    });
  });

  group('close calls', () {
    test('two near-identical candidates are reported as a close call', () {
      final proposal = FuzzyMatcher([
        _media('Zebracorn Waltzing Alpha'),
        _media('Zebracorn Waltzing Bravo'),
      ]).proposeFor(_script('Zebracorn Waltzing'));

      expect(proposal.candidates, hasLength(2));
      expect(proposal.leadOverRunnerUp, lessThan(MatchProposal.closeCallGap));
      // The number on the top candidate says nothing about the runner-up being
      // just as good. This is what says it.
      expect(proposal.isCloseCall, isTrue);
    });

    test('a lone candidate is not a close call', () {
      final proposal = FuzzyMatcher([
        _media('Zebracorn Waltzing'),
      ]).proposeFor(_script('Zebracorn Waltzing'));

      expect(proposal.leadOverRunnerUp, isNull);
      expect(proposal.isCloseCall, isFalse);
    });

    test('shared words are reported so the UI can show the overlap', () {
      final best = FuzzyMatcher([
        _media('Zebracorn Waltzing 2160p'),
      ]).proposeFor(_script('Zebracorn Waltzing')).best!;

      expect(best.sharedTokens, containsAll(['zebracorn', 'waltzing']));
      // Release noise is stripped before comparison, so it never appears as a
      // word the two names "share".
      expect(best.sharedTokens, isNot(contains('2160p')));
    });
  });

  group('helpers', () {
    test('levenshteinDistance', () {
      expect(levenshteinDistance('kitten', 'sitting'), 3);
      expect(levenshteinDistance('same', 'same'), 0);
      expect(levenshteinDistance('', 'abc'), 3);
    });

    test('formatDuration', () {
      expect(formatDuration(95), '1:35');
      expect(formatDuration(3725), '1:02:05');
    });
  });

  group('evaluation fixture', () {
    // Every pair here is a case the existing trie strategy cannot resolve, so
    // this measures what the fuzzy matcher adds *after* the trie has failed —
    // not how often the two agree.
    const pairs = <String, String>{
      'Alpha Beta Gamma': 'Gamma Alpha Beta',
      'Studio.Delta.Echo.1080p.WEB-DL.x265-CREW': 'Delta Echo',
      'FoxtrotGolfHotel': 'foxtrot_golf_hotel',
      'ABP-456 India Juliett': 'ABP456',
      'Kilo Lima 2023-05-14': 'Kilo Lima 20230514',
      'Mike.November.S02E05.2160p': 'Mike November s02e05',
      'Oscar Papa Quebec 4K VR180 SBS': 'Oscar Papa Quebec',
      'Romeo & Sierra - Tango (2023)': 'Romeo Sierra Tango 2023',
      'Uniform Victor Whiskey pt2': 'Uniform Victor Whiskey part 2',
      'Xray-Yankee-Zulu-1080p60': 'XrayYankeeZulu',
      "Anna's Big Day": 'Annas Big Day',
      'Björk Live Session': 'Bjork Live Session',
      'Charlie.Delta.scene3.HEVC': 'Charlie Delta Scene 3',
      'Echo Foxtrot Golf [WEBRIP][HD]': 'echo.foxtrot.golf',
      'Hotel India Juliett - Part One': 'Hotel India Juliett Part One',
    };

    late FuzzyMatcher matcher;

    setUp(() {
      matcher = FuzzyMatcher([
        ...pairs.keys.map((name) => _media(name)),
        ..._distractors.map((name) => _media(name)),
      ]);
    });

    test('these are genuinely cases the trie fails on', () {
      final trie = Trie();
      for (final mediaName in [...pairs.keys, ..._distractors]) {
        trie.insert(mediaName);
      }

      for (final entry in pairs.entries) {
        expect(
          trie.findLongestPrefix(entry.value),
          isNot(entry.key),
          reason:
              'the trie already resolves "${entry.value}", so it does not '
              'belong in a residual fixture',
        );
      }
    });

    test('the right media is ranked first for every case', () {
      final misses = <String>[];
      for (final entry in pairs.entries) {
        final top = _topName(matcher.proposeFor(_script(entry.value)));
        if (top != entry.key) misses.add('${entry.value} -> $top');
      }

      expect(misses, isEmpty, reason: 'top-1 misses: ${misses.join('; ')}');
    });

    test('a script sharing nothing produces no suggestion at all', () {
      final proposal = matcher.proposeFor(
        _script('Completely Unrelated Recording'),
      );

      expect(proposal.hasCandidates, isFalse);
    });

    test('true and false matches are separated by score', () {
      // The false-positive guard. A script whose words happen to be scattered
      // across the library does produce candidates -- suppressing them would
      // also suppress real weak matches -- but it must score visibly below a
      // genuine one, so a reviewer can tell the two apart at a glance.
      //
      // Measured on this fixture: true matches land at 0.44 and above, the
      // weakest being an identifier-only match that shares no words at all,
      // while scattered-word non-matches peak at 0.39.
      var weakestTrue = 1.0;
      for (final entry in pairs.entries) {
        final score = matcher.proposeFor(_script(entry.value)).best!.score;
        if (score < weakestTrue) weakestTrue = score;
      }

      var strongestFalse = 0.0;
      for (final name in [
        'Tango Foxtrot Sierra Bravo Kilo',
        'Alpha Session Party',
        'Golf Morning Trail',
      ]) {
        final best = matcher.proposeFor(_script(name)).best;
        if (best != null && best.score > strongestFalse) {
          strongestFalse = best.score;
        }
      }

      expect(weakestTrue, greaterThan(_separationThreshold));
      expect(strongestFalse, lessThan(_separationThreshold));
    });
  });
}
