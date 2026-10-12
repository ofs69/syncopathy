import 'package:syncopathy/media_library/matching/match_snapshot.dart';

/// The evidence types the matcher can produce. Each one is a reason a candidate
/// scored the way it did, phrased for someone deciding whether to trust it.
enum MatchFeatureKind {
  identifier('identifier'),
  tokenOverlap('title words'),
  characterSimilarity('character similarity'),
  nameSimilarity('name similarity'),
  duration('duration'),
  directory('folder'),
  metadata('script metadata');

  /// Short label for the review UI.
  final String label;
  const MatchFeatureKind(this.label);
}

/// One scored reason a video is or is not a plausible match.
///
/// [value] is normalized to 0..1 so features are comparable; [weight] is how
/// much this kind of evidence is worth relative to the others. A feature that
/// does not apply to a pair (no durations known, neither name carries an
/// identifier) is simply absent, and the remaining weights renormalize — a
/// missing signal must not read as a negative one.
class MatchFeature {
  final MatchFeatureKind kind;
  final double value;
  final double weight;

  /// Why this feature has this value, in the concrete: which words matched,
  /// how far apart the durations are. Generic labels are useless to a reviewer
  /// deciding whether to trust a suggestion.
  final String evidence;

  const MatchFeature({
    required this.kind,
    required this.value,
    required this.weight,
    required this.evidence,
  });
}

/// A reason to distrust a candidate that no amount of text similarity should
/// overcome. Penalties multiply the score rather than subtracting from it, so a
/// near-perfect name with a contradicting scene number still lands near the
/// bottom instead of merely a little lower.
class MatchPenalty {
  final MatchPenaltyKind kind;

  /// Multiplier applied to the base score, in 0..1.
  final double factor;
  final String evidence;

  const MatchPenalty({
    required this.kind,
    required this.factor,
    required this.evidence,
  });
}

enum MatchPenaltyKind {
  /// The names declare different season/episode/scene/part numbers. These are
  /// deliberately near-identical names for genuinely different scenes, which is
  /// exactly the case fuzzy text matching gets wrong.
  ordinalConflict('conflicting numbering'),

  /// The durations are too far apart to be the same cut. Kept lenient: partial
  /// scripts are common and legitimate.
  durationConflict('duration conflict');

  final String label;
  const MatchPenaltyKind(this.label);
}

/// A reason a *confident-looking* candidate might still be wrong.
///
/// Distinct from a penalty: a penalty is the matcher deciding a candidate is
/// worse than it looks, and a caution is the matcher admitting it cannot tell.
/// A high score reached without distinctive evidence is the shape a strong
/// false positive takes, and the one thing a reviewer must not have to work out
/// from the number alone.
enum MatchCaution {
  /// Everything the two names share is a word much of the library also uses.
  commonWordsOnly(
    'only common words',
    'The words these two share turn up all over the library, so they say very '
        'little about this pair in particular.',
    blocksBulkAccept: true,
  ),

  /// The filenames have nothing in common; something else brought the pair
  /// together.
  noSharedWords(
    'no shared words',
    'These filenames have no word and no identifier in common — the match '
        'rests on the funscript metadata alone.',
    blocksBulkAccept: true,
  ),

  /// Nothing corroborates the name evidence: no duration on either side, no
  /// shared folder, no script metadata.
  nameEvidenceOnly(
    'name evidence only',
    'Nothing but the names supports this. No duration, folder or funscript '
        'metadata could be compared.',
  );

  /// Short label for a chip.
  final String label;

  /// What it means, for a tooltip.
  final String explanation;

  /// Whether this is a reason to doubt the names themselves, rather than a note
  /// about what could not be checked.
  ///
  /// Only the former should hold a candidate back from being taken in bulk.
  /// Most filename matching has nothing but filenames to go on, so treating
  /// that as suspicious would make an unreviewed accept impossible rather than
  /// careful.
  final bool blocksBulkAccept;

  const MatchCaution(
    this.label,
    this.explanation, {
    this.blocksBulkAccept = false,
  });
}

/// One ranked video for one unresolved funscript.
class ScoredCandidate {
  /// Opaque, stable only within its own [MatchProposal]. Decisions name this
  /// and nothing else, so an accept can never reach a file that was not
  /// offered.
  final String candidateId;

  final MediaSnapshot media;

  /// 0..1, penalties already applied. Comparable within a proposal; across
  /// proposals it is a rough guide, not a probability.
  final double score;

  /// Score before penalties, kept so the UI can show that an otherwise strong
  /// name was demoted rather than simply weak.
  final double baseScore;

  final List<MatchFeature> features;
  final List<MatchPenalty> penalties;

  /// Reasons this candidate may be wrong despite its score.
  final List<MatchCaution> cautions;

  /// Words the two names have in common, normalized. The UI highlights these
  /// in both filenames so a reviewer can see the overlap rather than infer it
  /// from a percentage.
  final Set<String> sharedTokens;

  /// The subset of [sharedTokens] that is actually rare across the library.
  /// These are the words that make a match believable; the rest is filler.
  final Set<String> distinctiveTokens;

  const ScoredCandidate({
    required this.candidateId,
    required this.media,
    required this.score,
    required this.baseScore,
    required this.features,
    required this.penalties,
    this.cautions = const [],
    this.sharedTokens = const {},
    this.distinctiveTokens = const {},
  });

  /// Every reason behind this ranking, strongest first, as display strings.
  List<String> get evidence => [
    for (final penalty in penalties) penalty.evidence,
    for (final feature in features) feature.evidence,
  ];

  bool get hasCautions => cautions.isNotEmpty;

  /// Cautions that are reasons to doubt this candidate, not just notes.
  List<MatchCaution> get blockingCautions => [
    for (final caution in cautions)
      if (caution.blocksBulkAccept) caution,
  ];

  bool get isDoubtful => blockingCautions.isNotEmpty;
}

/// One unresolved funscript and the bounded set of videos it might belong to.
class MatchProposal {
  /// The script the decision is about. For a multi-axis set this is the best
  /// main-script candidate, never a secondary axis.
  final FunscriptSnapshot script;

  /// Other scripts of the same multi-axis set, which follow [script] wherever
  /// it is matched. Bundling them is what stops a twist track being attached to
  /// a different video than its stroke script.
  final List<FunscriptSnapshot> companions;

  /// Ranked best first, already bounded and filtered. Empty means the matcher
  /// found nothing plausible — an explicit outcome, not a failure.
  final List<ScoredCandidate> candidates;

  const MatchProposal({
    required this.script,
    required this.companions,
    required this.candidates,
  });

  bool get hasCandidates => candidates.isNotEmpty;

  ScoredCandidate? get best => candidates.isEmpty ? null : candidates.first;

  /// How far the top candidate is ahead of the runner-up, or `null` when there
  /// is only one.
  double? get leadOverRunnerUp =>
      candidates.length < 2 ? null : candidates[0].score - candidates[1].score;

  /// Whether the top two are close enough that the ranking is not really
  /// choosing between them.
  ///
  /// The single most useful thing to show a reviewer: a 70% top candidate with
  /// a 68% runner-up is a coin toss wearing a confident number, and it is
  /// exactly where an unread suggestion goes wrong.
  bool get isCloseCall => (leadOverRunnerUp ?? double.infinity) < closeCallGap;

  static const double closeCallGap = 0.08;

  ScoredCandidate? candidateById(String id) {
    for (final candidate in candidates) {
      if (candidate.candidateId == id) return candidate;
    }
    return null;
  }

  /// Every script this proposal decides for: [script] plus its [companions].
  List<FunscriptSnapshot> get allScripts => [script, ...companions];
}
