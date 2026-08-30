import 'package:flutter_test/flutter_test.dart';
import 'package:syncopathy/ioc.dart';
import 'package:syncopathy/media_library/matching/fuzzy_matcher.dart';
import 'package:syncopathy/media_library/matching/match_draft.dart';
import 'package:syncopathy/media_library/matching/match_features.dart';
import 'package:syncopathy/media_library/matching/match_rules_store.dart';
import 'package:syncopathy/media_library/matching/match_snapshot.dart';
import 'package:syncopathy/media_library/matching/matching_session_model.dart';
import 'package:syncopathy/media_library/matching/matching_settings.dart';
import 'package:syncopathy/model/settings_model.dart';
import 'package:syncopathy/platform/key_value_store/key_value_store.dart';

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

/// A session with its draft seeded directly, so the review flow can be
/// exercised without a database or a filesystem scan.
MatchingSessionModel _sessionWith(List<MatchProposal> proposals) {
  final session = MatchingSessionModel(
    SettingsModel(),
    FunscriptMatchingSettings(),
    MatchRulesStore(),
  );
  session.draft.value = MatchDraft(proposals);
  session.phase.value = MatchSessionPhase.reviewing;
  session.selectedScriptHash.value = proposals.isEmpty
      ? null
      : proposals.first.script.funscriptHash;
  return session;
}

/// Three scripts: two with a clear video each, one with nothing at all.
MatchingSessionModel _threeRowSession() => _sessionWith(
  FuzzyMatcher([
    _media('Zebracorn Waltzing 2160p'),
    _media('Marmalade Skyline 1080p'),
  ]).proposeAll([
    _script('Zebracorn Waltzing'),
    _script('Marmalade Skyline'),
    _script('Quilting Bee Nocturne'),
  ]),
);

void main() {
  setUp(() {
    getIt.registerSingleton<IKeyValueStore>(_FakeKeyValueStore());
  });

  tearDown(() => getIt.reset());

  group('the review queue', () {
    test('a script with no suggestion is not in the review queue', () {
      final session = _threeRowSession();

      expect(session.draft.value!.proposals, hasLength(3));
      // It is undecided, but there is nothing to decide: leaving it in the
      // queue would make the queue look permanently unfinished.
      expect(session.needsReviewCount, 2);
      expect(session.visibleProposals, hasLength(2));

      session.dispose();
    });

    test('filters partition the list', () {
      final session = _threeRowSession();
      session.accept(
        session.draft.value!.proposals.first,
        session.draft.value!.proposals.first.best!.candidateId,
      );

      session.listFilter.value = MatchReviewFilter.all;
      expect(session.visibleProposals, hasLength(3));

      session.listFilter.value = MatchReviewFilter.decided;
      expect(session.visibleProposals, hasLength(1));

      session.listFilter.value = MatchReviewFilter.noCandidates;
      expect(
        session.visibleProposals.single.script.basename,
        'Quilting Bee Nocturne',
      );

      session.listFilter.value = MatchReviewFilter.needsReview;
      expect(session.visibleProposals, hasLength(1));

      session.dispose();
    });

    test('search matches the funscript or any candidate video', () {
      final session = _threeRowSession();
      session.listFilter.value = MatchReviewFilter.all;

      session.listSearch.value = 'quilting';
      expect(session.visibleProposals, hasLength(1));

      // The video's name is the thing a person remembers; searching only the
      // funscript name would miss it.
      session.listSearch.value = '2160p';
      expect(
        session.visibleProposals.single.script.basename,
        'Zebracorn Waltzing',
      );

      session.listSearch.value = 'nothing matches this';
      expect(session.visibleProposals, isEmpty);

      session.dispose();
    });
  });

  group('moving through the list', () {
    test('stepping stays inside the visible list', () {
      final session = _threeRowSession();
      session.listFilter.value = MatchReviewFilter.all;
      final names = [
        for (final p in session.visibleProposals) p.script.basename,
      ];

      session.step(1);
      expect(session.selectedProposal!.script.basename, names[1]);

      session.step(-1);
      expect(session.selectedProposal!.script.basename, names[0]);

      // Clamped rather than wrapped: an arrow key held down should stop at the
      // end, not loop silently back to the top.
      session.step(-1);
      expect(session.selectedProposal!.script.basename, names[0]);

      session.dispose();
    });

    test('deciding moves on to the next row that needs review', () {
      final session = _threeRowSession();
      final first = session.visibleProposals.first;

      session.acceptBest(first);

      expect(session.selectedProposal, isNot(first));
      expect(session.selectedProposal, isNotNull);
      session.dispose();
    });

    test('auto-advance can be turned off', () {
      final session = _threeRowSession();
      session.autoAdvance.value = false;
      final first = session.visibleProposals.first;

      session.acceptBest(first);

      expect(session.selectedProposal, first);
      session.dispose();
    });

    test('deciding the last row leaves nothing selected', () {
      final session = _threeRowSession();
      for (final proposal in [...session.visibleProposals]) {
        session.acceptBest(proposal);
      }

      expect(session.needsReviewCount, 0);
      expect(session.selectedScriptHash.value, isNull);
      session.dispose();
    });

    test('deciding a row that is not selected does not move the selection', () {
      final session = _threeRowSession();
      session.listFilter.value = MatchReviewFilter.all;
      final selected = session.selectedProposal;
      final other = session.visibleProposals[1];

      session.skip(other);

      expect(session.selectedProposal, selected);
      session.dispose();
    });
  });

  group('accepting the obvious ones', () {
    test('takes only unambiguous matches', () {
      final session = _threeRowSession();

      final taken = session.acceptClearWinners();

      // Both suggested rows are lone, strong candidates; the third has nothing.
      expect(taken, 2);
      expect(session.draft.value!.acceptedCount.value, 2);
      session.dispose();
    });

    test('leaves a close call alone', () {
      final session = _sessionWith(
        FuzzyMatcher([
          _media('Zebracorn Waltzing Alpha'),
          _media('Zebracorn Waltzing Bravo'),
        ]).proposeAll([_script('Zebracorn Waltzing')]),
      );

      expect(session.draft.value!.proposals.single.isCloseCall, isTrue);
      // Two videos this similar are exactly where an unreviewed accept goes
      // wrong, however good the top score looks.
      expect(session.acceptClearWinners(), 0);
      session.dispose();
    });

    test('leaves a flagged candidate alone', () {
      final session = _sessionWith(
        FuzzyMatcher([
          for (var i = 1; i <= 8; i++)
            _media('Studio Productions 2023 Chapter$i'),
          for (var i = 1; i <= 12; i++) _media('Unrelated Recording $i'),
        ]).proposeAll([_script('Studio Productions 2023 Rooftop Interview')]),
      );

      final best = session.draft.value!.proposals.single.best!;
      expect(best.cautions, contains(MatchCaution.commonWordsOnly));
      expect(session.acceptClearWinners(), 0);
      session.dispose();
    });

    test('never overrides a decision already made', () {
      final session = _threeRowSession();
      final first = session.visibleProposals.first;
      session.reject(first);

      session.acceptClearWinners();

      expect(
        session.draft.value!.decisionFor(first)!.kind,
        MatchDecisionKind.reject,
      );
      session.dispose();
    });

    test('the count matches what the action would take', () {
      final session = _threeRowSession();
      final predicted = session.clearWinnerCount;

      expect(session.acceptClearWinners(), predicted);
      session.dispose();
    });
  });

  group('ordering', () {
    test('progress counts every proposal, not just the answerable ones', () {
      final session = _threeRowSession();
      session.acceptBest(session.visibleProposals.first);

      expect(session.decidedCount, 1);
      expect(session.draft.value!.proposals, hasLength(3));
      session.dispose();
    });
  });
}
