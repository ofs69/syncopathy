import 'package:flutter_test/flutter_test.dart';
import 'package:signals/signals.dart';
import 'package:syncopathy/media_library/matching/fuzzy_matcher.dart';
import 'package:syncopathy/media_library/matching/match_draft.dart';
import 'package:syncopathy/media_library/matching/match_snapshot.dart';

MediaSnapshot _media(String basename) =>
    MediaSnapshot(fileHash: 'media:$basename', basename: basename);

FunscriptSnapshot _script(String basename, {String? folder}) =>
    FunscriptSnapshot(
      funscriptHash: 'script:$basename',
      basename: basename,
      directoryLabel: folder,
    );

MatchDraft _draftFor(List<String> library, List<FunscriptSnapshot> scripts) =>
    MatchDraft(FuzzyMatcher(library.map(_media)).proposeAll(scripts));

void main() {
  group('validation', () {
    test('an accept naming a candidate that was never offered is an error', () {
      final draft = _draftFor(
        ['Alpha Beta Gamma'],
        [_script('Gamma Alpha Beta')],
      );
      final proposal = draft.proposals.single;

      final stored = draft.record(proposal, MatchDecision.accept('c99'));

      expect(stored.kind, MatchDecisionKind.error);
      expect(stored.error, contains('c99'));
      // Crucially: not recorded as a match, and nothing reaches Apply.
      expect(draft.accepted, isEmpty);
      expect(draft.acceptedCount.value, 0);
    });

    test('an accept with no candidate id at all is an error', () {
      final draft = _draftFor(['Alpha Beta'], [_script('Alpha Beta')]);

      final stored = draft.record(
        draft.proposals.single,
        MatchDecision.accept(''),
      );

      expect(stored.kind, MatchDecisionKind.error);
      expect(draft.accepted, isEmpty);
    });

    test('an accept naming an offered candidate is kept', () {
      final draft = _draftFor(['Alpha Beta Gamma'], [_script('Alpha Beta')]);
      final proposal = draft.proposals.single;

      final stored = draft.record(
        proposal,
        MatchDecision.accept(proposal.best!.candidateId),
      );

      expect(stored.kind, MatchDecisionKind.accept);
      expect(draft.accepted.single.mediaHash, 'media:Alpha Beta Gamma');
    });
  });

  group('the draft writes nothing until it is applied', () {
    test('decisions accumulate and can be taken back one at a time', () {
      final draft = _draftFor(
        ['Alpha Beta Gamma', 'Delta Echo Foxtrot'],
        [_script('Alpha Beta'), _script('Delta Echo')],
      );
      final first = draft.proposals.first;

      expect(draft.undecidedCount.value, 2);

      draft.record(first, MatchDecision.accept(first.best!.candidateId));
      expect(draft.undecidedCount.value, 1);
      expect(draft.undecided.single, isNot(first));

      draft.clearDecision(first);
      expect(draft.undecidedCount.value, 2);
      expect(draft.accepted, isEmpty);
    });

    test('cancelling discards everything', () {
      final draft = _draftFor(
        ['Alpha Beta Gamma', 'Delta Echo Foxtrot'],
        [_script('Alpha Beta'), _script('Delta Echo')],
      );
      for (final proposal in draft.proposals) {
        draft.record(
          proposal,
          MatchDecision.accept(proposal.best!.candidateId),
        );
      }
      expect(draft.acceptedCount.value, 2);

      draft.clear();

      expect(draft.acceptedCount.value, 0);
      expect(draft.accepted, isEmpty);
      expect(draft.undecidedCount.value, 2);
    });

    test('counts are reactive so the review UI can follow them', () {
      final draft = _draftFor(['Alpha Beta Gamma'], [_script('Alpha Beta')]);
      final seen = <int>[];
      final dispose = effect(() => seen.add(draft.acceptedCount.value));

      final proposal = draft.proposals.single;
      draft.record(proposal, MatchDecision.accept(proposal.best!.candidateId));
      draft.clearDecision(proposal);

      dispose();
      expect(seen, [0, 1, 0]);
    });

    test('rejections are collected for suppression', () {
      final draft = _draftFor(['Alpha Beta Gamma'], [_script('Alpha Beta')]);

      draft.record(draft.proposals.single, MatchDecision.reject());

      expect(draft.rejected, hasLength(1));
      expect(draft.accepted, isEmpty);
      // Feeding these back into the next run is what stops a repair tool
      // suggesting the same wrong pair forever.
      expect(
        matchPairKey(
          draft.rejected.single.script.funscriptHash,
          draft.rejected.single.best!.media.fileHash,
        ),
        'script:Alpha Beta|media:Alpha Beta Gamma',
      );
    });

    test('a skip is decided without being accepted or rejected', () {
      final draft = _draftFor(['Alpha Beta Gamma'], [_script('Alpha Beta')]);

      draft.record(draft.proposals.single, const MatchDecision.skip());

      expect(draft.undecidedCount.value, 0);
      expect(draft.accepted, isEmpty);
      expect(draft.rejected, isEmpty);
    });
  });

  group('what reaches Apply', () {
    test('multi-axis companions follow the script they were bundled with', () {
      final draft = MatchDraft(
        FuzzyMatcher([_media('Alpha Beta Gamma 2160p')]).proposeAll([
          _script('alpha beta gamma'),
          _script('alpha beta gamma.twist'),
        ]),
      );
      final proposal = draft.proposals.single;
      expect(proposal.companions, hasLength(1));

      draft.record(proposal, MatchDecision.accept(proposal.best!.candidateId));

      final accepted = draft.accepted.single;
      expect(accepted.funscriptHashes, hasLength(2));
      expect(accepted.mediaHash, 'media:Alpha Beta Gamma 2160p');
    });

    test('an errored decision never reaches Apply', () {
      final draft = _draftFor(['Alpha Beta Gamma'], [_script('Alpha Beta')]);

      draft.record(draft.proposals.single, MatchDecision.accept('nope'));

      expect(draft.accepted, isEmpty);
      expect(draft.rejected, isEmpty);
    });
  });
}
