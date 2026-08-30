import 'package:signals/signals_flutter.dart';
import 'package:syncopathy/media_library/matching/match_features.dart';

/// What a reviewer concluded about one [MatchProposal].
enum MatchDecisionKind {
  /// This script belongs to a specific candidate. Only ever recorded with a
  /// candidate id that was actually offered — see [MatchDraft.record].
  accept,

  /// None of the candidates is right. Remembered so the pair is not offered
  /// again on the next run.
  reject,

  /// Undecided, deliberately. Left for the next session rather than recorded.
  skip,

  /// The decision could not be recorded as given, because it named a candidate
  /// this proposal does not contain. Never an implicit match.
  error,
}

/// One answer for one proposal.
class MatchDecision {
  final MatchDecisionKind kind;

  /// Set only for [MatchDecisionKind.accept], and only after validation.
  final String? candidateId;

  final List<String> evidence;

  final String? error;

  const MatchDecision._({
    required this.kind,
    this.candidateId,
    this.evidence = const [],
    this.error,
  });

  factory MatchDecision.accept(
    String candidateId, {
    List<String> evidence = const [],
  }) => MatchDecision._(
    kind: MatchDecisionKind.accept,
    candidateId: candidateId,
    evidence: evidence,
  );

  factory MatchDecision.reject({List<String> evidence = const []}) =>
      MatchDecision._(kind: MatchDecisionKind.reject, evidence: evidence);

  const MatchDecision.skip() : this._(kind: MatchDecisionKind.skip);

  factory MatchDecision.error(String error) =>
      MatchDecision._(kind: MatchDecisionKind.error, error: error);

  bool get isAccept => kind == MatchDecisionKind.accept;
}

/// The decisions made so far, and the only place they are validated.
///
/// A draft writes nothing. It exists so review is reversible right up to the
/// moment the user applies it: closing the tool, or calling [clear], leaves the
/// library exactly as it was.
class MatchDraft {
  final List<MatchProposal> proposals;

  /// Keyed by the primary script's hash. Replaced wholesale on every change —
  /// mutating a collection signal in place re-emits the same instance and the
  /// update is silently swallowed.
  final Signal<Map<String, MatchDecision>> _decisions = signal(const {});
  ReadonlySignal<Map<String, MatchDecision>> get decisions => _decisions;

  MatchDraft(this.proposals);

  late final ReadonlySignal<int> acceptedCount = computed(
    () => _decisions.value.values.where((d) => d.isAccept).length,
  );

  late final ReadonlySignal<int> undecidedCount = computed(
    () => proposals.length - _decisions.value.length,
  );

  /// Proposals still waiting on a decision, in their original order.
  List<MatchProposal> get undecided => [
    for (final proposal in proposals)
      if (!_decisions.value.containsKey(proposal.script.funscriptHash))
        proposal,
  ];

  MatchDecision? decisionFor(MatchProposal proposal) =>
      _decisions.value[proposal.script.funscriptHash];

  /// Records [decision] against [proposal], validating it first.
  ///
  /// An accept naming a candidate the proposal does not contain is stored as an
  /// error, never as a match. Everything that reaches Apply comes through here,
  /// so a candidate id that was never offered cannot become a link however it
  /// was produced.
  ///
  /// Returns what was actually stored, which may not be what was passed in.
  MatchDecision record(MatchProposal proposal, MatchDecision decision) {
    var stored = decision;

    if (decision.isAccept) {
      final candidateId = decision.candidateId;
      if (candidateId == null || proposal.candidateById(candidateId) == null) {
        stored = MatchDecision.error(
          'not one of the offered candidates: ${candidateId ?? '<none>'}',
        );
      }
    }

    _decisions.value = {
      ..._decisions.value,
      proposal.script.funscriptHash: stored,
    };
    return stored;
  }

  /// Drops the decision for [proposal], returning it to the undecided pile.
  void clearDecision(MatchProposal proposal) {
    final next = {..._decisions.value}..remove(proposal.script.funscriptHash);
    _decisions.value = next;
  }

  /// Discards every decision. Cancelling a session must be free of consequence,
  /// so this is all it takes to undo one.
  void clear() => _decisions.value = const {};

  /// The accepted pairs, ready for the Apply step to validate against the
  /// filesystem and write. Every entry names a candidate that was offered.
  List<AcceptedMatch> get accepted => [
    for (final proposal in proposals)
      if (decisionFor(proposal) case final decision?)
        if (decision.isAccept)
          AcceptedMatch(
            proposal: proposal,
            candidate: proposal.candidateById(decision.candidateId!)!,
          ),
  ];

  /// The pairs a reviewer turned down, as suppression keys for later runs.
  List<MatchProposal> get rejected => [
    for (final proposal in proposals)
      if (decisionFor(proposal)?.kind == MatchDecisionKind.reject) proposal,
  ];

  void dispose() {
    acceptedCount.dispose();
    undecidedCount.dispose();
  }
}

/// One accepted match, with everything Apply needs and nothing it does not.
class AcceptedMatch {
  final MatchProposal proposal;
  final ScoredCandidate candidate;

  const AcceptedMatch({required this.proposal, required this.candidate});

  /// Every script that follows this decision: the primary and its multi-axis
  /// companions.
  List<String> get funscriptHashes => [
    for (final script in proposal.allScripts) script.funscriptHash,
  ];

  String get mediaHash => candidate.media.fileHash;
}
