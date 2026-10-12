import 'dart:math' as math;

import 'package:syncopathy/media_library/matching/match_features.dart';
import 'package:syncopathy/media_library/matching/match_snapshot.dart';
import 'package:syncopathy/media_library/matching/name_normalizer.dart';

/// Knobs the review tool exposes. Defaults are deliberately conservative: a
/// short, high-confidence list a reviewer will actually read beats a long one
/// they will skim.
class MatchingOptions {
  /// Top-K. The bound that makes every downstream step safe — a decision only
  /// ever names one of this many.
  final int maxCandidates;

  /// How many cheap-scored candidates get the expensive edit-distance pass.
  /// Refinement reorders the shortlist; it does not rescue anything the cheap
  /// stage ranked far down.
  final int refineLimit;

  /// Candidates below this score are dropped entirely rather than shown as weak
  /// suggestions. A reviewer offered rubbish stops reading the evidence.
  final double minimumScore;

  final bool useDirectoryLabels;
  final bool useScriptMetadata;

  /// Drop candidates whose entire case is words the library uses everywhere.
  ///
  /// Off by default: the honest answer to "your video is not in the library"
  /// is a weak suggestion carrying [MatchCaution.commonWordsOnly], not silence.
  /// But a library with a heavy house style produces those by the hundred, and
  /// a reviewer who only wants the pairs with a real word in common should be
  /// able to say so.
  final bool requireDistinctiveEvidence;

  const MatchingOptions({
    this.maxCandidates = 12,
    this.refineLimit = 50,
    this.minimumScore = 0.18,
    this.useDirectoryLabels = true,
    this.useScriptMetadata = true,
    this.requireDistinctiveEvidence = false,
  });
}

/// Key identifying one script/media pair, for suppressing pairs a reviewer has
/// already rejected.
String matchPairKey(String funscriptHash, String mediaHash) =>
    '$funscriptHash|$mediaHash';

/// Ranks media against funscripts the trie could not resolve.
///
/// Pure and synchronous: no I/O, no database. Everything it knows comes from the
/// snapshots handed to the constructor, which is what makes it testable against
/// a fixture and what makes it the part of this feature that can be trusted.
///
/// Construction builds inverted indexes over the media, so build one matcher
/// per session and reuse it across scripts.
class FuzzyMatcher {
  final List<MediaSnapshot> media;
  final MatchingOptions options;

  /// Pair keys ([matchPairKey]) a reviewer previously rejected. Excluded
  /// outright rather than penalized: re-offering a rejected pair every scan is
  /// how a repair tool becomes something people stop opening.
  final Set<String> rejectedPairs;

  final Map<String, List<int>> _tokenIndex = {};
  final Map<String, List<int>> _identifierIndex = {};

  /// Words this particular library uses so widely they cannot say which file a
  /// script belongs to.
  ///
  /// [normalizeName] drops the noise every library shares — resolutions,
  /// codecs, headsets. This is the half no fixed list can cover: the studio
  /// name in every filename, the site tag, the house-style word this
  /// collection happens to repeat. They arrive looking exactly like content,
  /// and left as content they are what makes two unrelated files of the same
  /// provenance score as the same scene.
  final Set<String> _boilerplate = {};

  /// Per-media text with [_boilerplate] removed, for the features that read a
  /// name as a string rather than as a bag of words.
  ///
  /// Character similarity is the measure boilerplate distorts most: two files
  /// sharing a long house-style prefix overlap heavily as *text* while sharing
  /// no title at all.
  late final List<_Content> _mediaContent;

  FuzzyMatcher(
    Iterable<MediaSnapshot> media, {
    this.options = const MatchingOptions(),
    this.rejectedPairs = const {},
  }) : media = List.unmodifiable(media) {
    for (var i = 0; i < this.media.length; i++) {
      final name = this.media[i].name;
      for (final token in name.tokenSet) {
        _tokenIndex.putIfAbsent(token, () => []).add(i);
      }
      for (final identifier in name.identifiers) {
        _identifierIndex.putIfAbsent(identifier, () => []).add(i);
      }
    }

    // Needs the finished index, and a pool big enough for "this word is
    // everywhere" to be a measurement rather than an accident of sample size.
    if (_frequencyIsMeaningful) {
      final threshold = math.max(
        _minBoilerplateCount,
        (this.media.length * _boilerplateShare).ceil(),
      );
      for (final entry in _tokenIndex.entries) {
        if (entry.value.length >= threshold) _boilerplate.add(entry.key);
      }
    }

    _mediaContent = [
      for (final snapshot in this.media) _contentOf(snapshot.name),
    ];
  }

  /// Reduces [name] to the words that distinguish it within *this* library,
  /// keeping the full text alongside for the pairs where the reduction leaves
  /// nothing to compare.
  _Content _contentOf(NormalizedName name) {
    if (_boilerplate.isEmpty) {
      return _Content(stem: name.stem, trigrams: name.trigrams);
    }

    final tokens = name.tokens
        .where((token) => !_boilerplate.contains(token))
        .toList();
    if (tokens.isEmpty) {
      return _Content(stem: name.stem, trigrams: name.trigrams);
    }

    final stem = tokens.join(' ');
    return _Content(
      stem: name.stem,
      trigrams: name.trigrams,
      contentStem: stem,
      contentTrigrams: trigramsOf(stem),
    );
  }

  /// Ranks every script, bundling multi-axis companions so one decision covers
  /// a whole set. Proposals come back in input order of each bundle's primary.
  List<MatchProposal> proposeAll(Iterable<FunscriptSnapshot> scripts) {
    final bundles = <String, List<FunscriptSnapshot>>{};
    for (final script in scripts) {
      final key = '${script.directoryLabel ?? ''}\u0000${script.axisStem}';
      bundles.putIfAbsent(key, () => []).add(script);
    }

    return [
      for (final bundle in bundles.values)
        _proposeForBundle(_sortBundle(bundle)),
    ];
  }

  /// Ranks a single script, with no companions.
  MatchProposal proposeFor(FunscriptSnapshot script) =>
      _proposeForBundle([script]);

  /// Orders a multi-axis set so the best main-script candidate comes first: a
  /// plain script over an explicit stroke one over a secondary axis, then the
  /// shortest name, then alphabetically so the result never depends on the
  /// order the filesystem happened to list them in.
  static List<FunscriptSnapshot> _sortBundle(List<FunscriptSnapshot> bundle) {
    final sorted = [...bundle];
    sorted.sort((a, b) {
      final byRank = a.axisRank.compareTo(b.axisRank);
      if (byRank != 0) return byRank;
      final byLength = a.basename.length.compareTo(b.basename.length);
      if (byLength != 0) return byLength;
      return a.basename.compareTo(b.basename);
    });
    return sorted;
  }

  MatchProposal _proposeForBundle(List<FunscriptSnapshot> bundle) {
    final script = bundle.first;
    return MatchProposal(
      script: script,
      companions: bundle.skip(1).toList(),
      candidates: _rank(script),
    );
  }

  List<ScoredCandidate> _rank(FunscriptSnapshot script) {
    final gated = _gate(script);
    if (gated.isEmpty) return const [];

    // Cheap pass over everything the gate let through, then the expensive
    // edit-distance pass over only the shortlist.
    final scriptContent = _contentOf(script.name);

    final cheap = <_Scored>[];
    for (final index in gated) {
      final scored = _score(
        script,
        scriptContent,
        index,
        withEditDistance: false,
      );
      if (scored.score <= 0) continue;
      cheap.add(_Scored(index, scored));
    }
    cheap.sort((a, b) => b.result.score.compareTo(a.result.score));

    final refined = <_Scored>[];
    for (final entry in cheap.take(options.refineLimit)) {
      refined.add(
        _Scored(
          entry.index,
          _score(script, scriptContent, entry.index, withEditDistance: true),
        ),
      );
    }
    refined.sort((a, b) {
      final byScore = b.result.score.compareTo(a.result.score);
      if (byScore != 0) return byScore;
      // Stable, name-based tiebreak so equal scores rank identically on every
      // run rather than following filesystem order.
      return media[a.index].basename.compareTo(media[b.index].basename);
    });

    final result = <ScoredCandidate>[];
    for (final entry in refined) {
      if (entry.result.score < options.minimumScore) break;
      if (result.length >= options.maxCandidates) break;
      final candidate = media[entry.index];
      final shared = script.name.tokenSet.intersection(candidate.name.tokenSet);
      final distinctive = shared.where(_isDistinctive).toSet();
      final cautions = _cautionsFor(
        script,
        candidate,
        entry.result,
        shared: shared,
        distinctive: distinctive,
      );

      // Ranked above the cut but resting on nothing but the library's house
      // style. Skipped rather than stopped on: a later candidate may still
      // have a real word in common.
      if (options.requireDistinctiveEvidence &&
          cautions.contains(MatchCaution.commonWordsOnly)) {
        continue;
      }

      result.add(
        ScoredCandidate(
          candidateId: 'c${result.length + 1}',
          media: candidate,
          score: entry.result.score,
          baseScore: entry.result.baseScore,
          features: entry.result.features,
          penalties: entry.result.penalties,
          cautions: cautions,
          sharedTokens: shared,
          distinctiveTokens: distinctive,
        ),
      );
    }
    return result;
  }

  /// Reasons a candidate may be wrong despite how it scored.
  ///
  /// These are the shapes a strong false positive takes. The matcher cannot
  /// rule them out — that is what makes them false *positives* rather than
  /// penalties — so it says so instead, and lets the reviewer spend their
  /// attention where it is actually needed.
  List<MatchCaution> _cautionsFor(
    FunscriptSnapshot script,
    MediaSnapshot candidate,
    _ScoreResult result, {
    required Set<String> shared,
    required Set<String> distinctive,
  }) {
    final cautions = <MatchCaution>[];

    final sharesIdentifier = script.name.identifiers
        .intersection(candidate.name.identifiers)
        .isNotEmpty;

    if (!sharesIdentifier) {
      if (shared.isEmpty) {
        cautions.add(MatchCaution.noSharedWords);
      } else if (distinctive.isEmpty && _frequencyIsMeaningful) {
        cautions.add(MatchCaution.commonWordsOnly);
      }
    }

    // Nothing outside the filenames was available to check the guess against.
    final corroborated = result.features.any(
      (feature) =>
          feature.kind == MatchFeatureKind.duration ||
          feature.kind == MatchFeatureKind.metadata ||
          (feature.kind == MatchFeatureKind.directory && feature.value > 0),
    );
    if (!corroborated && !sharesIdentifier) {
      cautions.add(MatchCaution.nameEvidenceOnly);
    }

    return cautions;
  }

  /// Narrows the library to media worth scoring: anything sharing a content
  /// token or an identifier with the script.
  ///
  /// Media sharing nothing at all is not silently wrong to drop — with no
  /// common word and no common code there is no evidence for the pair, only
  /// character noise. This is also what keeps the pass linear in the library
  /// rather than quadratic.
  List<int> _gate(FunscriptSnapshot script) {
    final shared = <int, double>{};

    void add(Iterable<int>? indexes, double weight) {
      if (indexes == null) return;
      for (final index in indexes) {
        shared[index] = (shared[index] ?? 0) + weight;
      }
    }

    // Weighted by what each word is worth, because the gate's ranking decides
    // what survives [_gateLimit]. Counting words equally is how the one file
    // agreeing on the title loses its place to a hundred agreeing on the
    // studio.
    for (final token in script.name.tokenSet) {
      add(_tokenIndex[token], _tokenValue(token));
    }
    for (final identifier in script.name.identifiers) {
      add(_identifierIndex[identifier], _identifierGateWeight);
    }
    if (options.useScriptMetadata) {
      for (final token in script.title?.tokenSet ?? const <String>{}) {
        add(_tokenIndex[token], _tokenValue(token));
      }
    }

    shared.removeWhere(
      (index, _) => rejectedPairs.contains(
        matchPairKey(script.funscriptHash, media[index].fileHash),
      ),
    );
    if (shared.isEmpty) return const [];

    final indexes = shared.keys.toList();
    if (indexes.length <= _gateLimit) return indexes;

    // Too many share at least one word — usually a common one. Keep those
    // sharing the most, which is a crude ranking but only decides what gets
    // scored properly, not what gets suggested.
    indexes.sort((a, b) => shared[b]!.compareTo(shared[a]!));
    return indexes.sublist(0, _gateLimit);
  }

  /// An identifier match alone is enough to keep a candidate, so it outweighs
  /// any plausible number of incidental shared words at the gate.
  static const double _identifierGateWeight = 100;

  /// Ceiling on how many media reach full scoring for one script.
  static const int _gateLimit = 400;

  _ScoreResult _score(
    FunscriptSnapshot script,
    _Content scriptContent,
    int candidateIndex, {
    required bool withEditDistance,
  }) {
    final candidate = media[candidateIndex];
    final candidateContent = _mediaContent[candidateIndex];
    final features = <MatchFeature>[];
    final penalties = <MatchPenalty>[];

    _addIdentifierFeature(script.name, candidate.name, features);
    _addTokenFeature(script.name, candidate.name, features);
    _addTrigramFeature(scriptContent, candidateContent, features);
    if (withEditDistance) {
      _addEditFeature(scriptContent, candidateContent, features);
    }
    _addDurationFeature(script, candidate, features, penalties);
    if (options.useDirectoryLabels) {
      _addDirectoryFeature(script, candidate, features);
    }
    if (options.useScriptMetadata) {
      _addMetadataFeature(script, candidate, features);
    }
    _addOrdinalPenalty(script.name, candidate.name, penalties);

    var totalWeight = 0.0;
    var weighted = 0.0;
    for (final feature in features) {
      totalWeight += feature.weight;
      weighted += feature.value * feature.weight;
    }
    final baseScore = totalWeight == 0 ? 0.0 : weighted / totalWeight;

    var score = baseScore;
    for (final penalty in penalties) {
      score *= penalty.factor;
    }

    return _ScoreResult(
      score: score,
      baseScore: baseScore,
      features: features,
      penalties: penalties,
    );
  }

  // --- Features ---

  /// Studio codes and dates. Only applicable when *both* names carry one:
  /// a script stripped down to a title has no identifier to disagree with, and
  /// scoring that as a mismatch would bury every correct match of that shape.
  static void _addIdentifierFeature(
    NormalizedName script,
    NormalizedName candidate,
    List<MatchFeature> features,
  ) {
    if (script.identifiers.isEmpty || candidate.identifiers.isEmpty) return;

    final shared = script.identifiers.intersection(candidate.identifiers);
    features.add(
      MatchFeature(
        kind: MatchFeatureKind.identifier,
        value: shared.isEmpty ? 0.0 : 1.0,
        weight: _identifierWeight,
        evidence: shared.isEmpty
            ? 'different identifiers: '
                  '${_list(script.identifiers)} vs ${_list(candidate.identifiers)}'
            : 'shares identifier ${_list(shared)}',
      ),
    );
  }

  /// Shared words, weighted by how rare each one is in this library.
  ///
  /// Counting shared words equally is what produces a confident wrong answer:
  /// two files that agree on the studio, the year and the word "scene" can
  /// outscore the one file that agrees on the actual title. Rarity is the whole
  /// signal — a word half the library uses says almost nothing about which half
  /// this pair belongs to.
  void _addTokenFeature(
    NormalizedName script,
    NormalizedName candidate,
    List<MatchFeature> features,
  ) {
    if (script.tokenSet.isEmpty || candidate.tokenSet.isEmpty) return;

    final shared = script.tokenSet.intersection(candidate.tokenSet);
    final distinctive = shared.where(_isDistinctive).toSet();

    final String evidence;
    if (shared.isEmpty) {
      evidence = 'no title words in common';
    } else if (distinctive.isEmpty) {
      evidence = 'shares only common words: ${_list(shared)}';
    } else {
      evidence =
          'shares ${_list(distinctive)}'
          '${shared.length > distinctive.length ? ' (plus ${shared.length - distinctive.length} common ${shared.length - distinctive.length == 1 ? 'word' : 'words'})' : ''}';
    }

    features.add(
      MatchFeature(
        kind: MatchFeatureKind.tokenOverlap,
        value: _weightedOverlap(script.tokenSet, candidate.tokenSet),
        weight: _tokenWeight,
        evidence: evidence,
      ),
    );
  }

  /// How rare [token] is across the candidate pool, in 0..1.
  ///
  /// Smoothed so a token in every video does not divide by zero, then
  /// normalized against the best possible value so it means the same thing in a
  /// library of fifty and a library of five thousand.
  double _rarity(String token) {
    if (media.isEmpty) return 1;
    final count = _tokenIndex[token]?.length ?? 0;
    final idf = math.log((media.length + 1) / (count + 1));
    final maxIdf = math.log(media.length + 1);
    return maxIdf <= 0 ? 1 : (idf / maxIdf).clamp(0.0, 1.0);
  }

  /// What one shared word is worth.
  ///
  /// Floored, because a word every candidate happens to contain is weak
  /// evidence, not *no* evidence — and in a small pool every word looks
  /// ubiquitous. Without the floor a two-file library scores every pair at
  /// zero, which is the opposite of what rarity weighting is for.
  double _tokenValue(String token) {
    // The floor is for words that are merely common. A word this library puts
    // in every filename is below that: crediting it at the floor is what lets
    // four house-style agreements outweigh the one word that matters.
    if (_boilerplate.contains(token)) return _boilerplateTokenValue;
    return _minTokenValue + (1 - _minTokenValue) * _rarity(token);
  }

  /// Whether the pool is big enough for word frequency to say anything.
  ///
  /// In a handful of files "this word is everywhere" is an accident of sample
  /// size, and calling a match unremarkable on that basis would be a guess
  /// dressed as a measurement.
  bool get _frequencyIsMeaningful => media.length >= _minLibraryForFrequency;

  /// Whether a shared word is rare enough to be worth pointing at.
  bool _isDistinctive(String token) {
    if (!_frequencyIsMeaningful) return true;
    if (_boilerplate.contains(token)) return false;
    return _rarity(token) >= _distinctiveRarity;
  }

  /// [_overlap], with each token contributing its worth rather than 1.
  double _weightedOverlap(Set<String> a, Set<String> b) {
    if (a.isEmpty || b.isEmpty) return 0;

    var sharedWeight = 0.0;
    for (final token in a) {
      if (b.contains(token)) sharedWeight += _tokenValue(token);
    }
    if (sharedWeight <= 0) return 0;

    var weightA = 0.0;
    for (final token in a) {
      weightA += _tokenValue(token);
    }
    var weightB = 0.0;
    for (final token in b) {
      weightB += _tokenValue(token);
    }

    final containment = sharedWeight / math.min(weightA, weightB);
    final jaccard = sharedWeight / (weightA + weightB - sharedWeight);
    return math.sqrt(containment * jaccard).clamp(0.0, 1.0);
  }

  static void _addTrigramFeature(
    _Content script,
    _Content candidate,
    List<MatchFeature> features,
  ) {
    final grams = _comparableTrigrams(script, candidate);
    if (grams.a.isEmpty || grams.b.isEmpty) return;

    final shared = grams.a.intersection(grams.b).length;
    final dice = 2 * shared / (grams.a.length + grams.b.length);
    features.add(
      MatchFeature(
        kind: MatchFeatureKind.characterSimilarity,
        value: dice,
        weight: _trigramWeight,
        evidence: '${_percent(dice)} character overlap',
      ),
    );
  }

  static void _addEditFeature(
    _Content script,
    _Content candidate,
    List<MatchFeature> features,
  ) {
    final stems = _comparableStems(script, candidate);
    if (stems.a.isEmpty || stems.b.isEmpty) return;

    final longest = math.max(stems.a.length, stems.b.length);
    final ratio = 1 - levenshteinDistance(stems.a, stems.b) / longest;
    features.add(
      MatchFeature(
        kind: MatchFeatureKind.nameSimilarity,
        value: ratio.clamp(0.0, 1.0),
        weight: _editWeight,
        evidence: '${_percent(ratio)} name similarity',
      ),
    );
  }

  /// Duration agreement, and the conflict that rules a pair out.
  ///
  /// Deliberately lenient. Scripts are routinely partial, shifted, or written
  /// for a different cut, and a script whose only duration signal is its last
  /// action always stops before the video does — so a shorter script is
  /// expected, while a *longer* one is genuinely suspicious.
  void _addDurationFeature(
    FunscriptSnapshot script,
    MediaSnapshot candidate,
    List<MatchFeature> features,
    List<MatchPenalty> penalties,
  ) {
    final scriptDuration = script.effectiveDurationSeconds;
    final mediaDuration = candidate.durationSeconds;
    if (scriptDuration == null ||
        mediaDuration == null ||
        scriptDuration <= 0 ||
        mediaDuration <= 0) {
      return;
    }

    final difference = (scriptDuration - mediaDuration).abs();
    final relative = difference / math.max(scriptDuration, mediaDuration);

    final scriptEndsEarly =
        script.metadataDurationSeconds == null &&
        scriptDuration < mediaDuration;
    final tolerance = scriptEndsEarly
        ? _lastActionDurationTolerance
        : _durationTolerance;

    features.add(
      MatchFeature(
        kind: MatchFeatureKind.duration,
        value: (1 - relative / tolerance).clamp(0.0, 1.0),
        weight: _durationWeight,
        evidence:
            'script ${formatDuration(scriptDuration)} vs media '
            '${formatDuration(mediaDuration)} '
            '(${_percent(relative)} apart)',
      ),
    );

    if (relative > _durationConflictRatio &&
        difference > _durationConflictSeconds) {
      penalties.add(
        MatchPenalty(
          kind: MatchPenaltyKind.durationConflict,
          factor: _durationConflictFactor,
          evidence:
              'durations differ by ${_percent(relative)}: '
              '${formatDuration(scriptDuration)} vs '
              '${formatDuration(mediaDuration)}',
        ),
      );
    }
  }

  static void _addDirectoryFeature(
    FunscriptSnapshot script,
    MediaSnapshot candidate,
    List<MatchFeature> features,
  ) {
    final scriptDirectory = script.directory;
    final mediaDirectory = candidate.directory;
    if (scriptDirectory == null || mediaDirectory == null) return;
    if (scriptDirectory.tokenSet.isEmpty || mediaDirectory.tokenSet.isEmpty) {
      return;
    }

    final same = script.directoryLabel == candidate.directoryLabel;
    features.add(
      MatchFeature(
        kind: MatchFeatureKind.directory,
        value: same
            ? 1.0
            : _overlap(scriptDirectory.tokenSet, mediaDirectory.tokenSet),
        weight: _directoryWeight,
        evidence: same
            ? 'same folder "${script.directoryLabel}"'
            : 'folders "${script.directoryLabel}" and '
                  '"${candidate.directoryLabel}"',
      ),
    );
  }

  /// What the script says about itself, against the candidate's filename.
  /// Present on a minority of scripts, but when it is present it is authored
  /// rather than derived from a release name, so it is worth more than its
  /// share of the text.
  static void _addMetadataFeature(
    FunscriptSnapshot script,
    MediaSnapshot candidate,
    List<MatchFeature> features,
  ) {
    final parts = <double>[];
    final evidence = <String>[];

    final title = script.title;
    if (title != null && title.tokenSet.isNotEmpty) {
      final shared = title.tokenSet.intersection(candidate.name.tokenSet);
      parts.add(_overlap(title.tokenSet, candidate.name.tokenSet));
      evidence.add(
        shared.isEmpty
            ? 'script title shares no words'
            : 'script title shares ${_list(shared)}',
      );
    }

    if (script.performers.isNotEmpty) {
      final matched = <String>[];
      for (final performer in script.performers) {
        final tokens = normalizeName(
          performer,
          vocabulary: script.vocabulary,
        ).tokenSet;
        if (tokens.isEmpty) continue;
        // Every word of the name has to be there: "jane" alone in a filename
        // is not evidence that "jane doe" performs in it.
        if (tokens.difference(candidate.name.tokenSet).isEmpty) {
          matched.add(performer);
        }
      }
      parts.add(matched.length / script.performers.length);
      if (matched.isNotEmpty) {
        evidence.add('names ${_list(matched)}');
      }
    }

    if (parts.isEmpty) return;
    features.add(
      MatchFeature(
        kind: MatchFeatureKind.metadata,
        value: parts.reduce((a, b) => a + b) / parts.length,
        weight: _metadataWeight,
        evidence: evidence.isEmpty
            ? 'script metadata does not match this name'
            : evidence.join('; '),
      ),
    );
  }

  /// Numbering disagreement, the case fuzzy text matching most reliably gets
  /// wrong: `scene 3` and `scene 4` are near-identical strings naming different
  /// scenes. Asymmetric on purpose — disagreement is close to disqualifying,
  /// while agreement earns nothing, because agreeing on "scene 1" is common and
  /// says almost nothing.
  static void _addOrdinalPenalty(
    NormalizedName script,
    NormalizedName candidate,
    List<MatchPenalty> penalties,
  ) {
    for (final entry in script.ordinals.entries) {
      final other = candidate.ordinals[entry.key];
      if (other == null || other == entry.value) continue;
      penalties.add(
        MatchPenalty(
          kind: MatchPenaltyKind.ordinalConflict,
          factor: _ordinalConflictFactor,
          evidence:
              '${entry.key.name} ${entry.value} vs ${entry.key.name} $other',
        ),
      );
    }
  }

  // --- Weights ---
  //
  // Relative, not absolute: a pair's score is the weighted mean over the
  // features that apply to it, so these say how much each kind of evidence is
  // worth against the others, and a pair with fewer signals is not penalized
  // for the ones it could not have.

  static const double _identifierWeight = 0.30;
  static const double _tokenWeight = 0.30;
  static const double _trigramWeight = 0.20;
  static const double _editWeight = 0.12;
  static const double _durationWeight = 0.08;
  static const double _directoryWeight = 0.05;
  static const double _metadataWeight = 0.15;

  /// Rarity a shared word must reach to count as evidence about *this* pair
  /// rather than about the library's naming habits in general.
  static const double _distinctiveRarity = 0.35;

  /// Floor on what any shared word is worth, so a common word still counts.
  static const double _minTokenValue = 0.25;

  /// What a word the library puts in nearly every filename is worth. Not zero:
  /// it is still weakly better than no overlap at all, and a hard zero would
  /// make a name built entirely of house style score as unmatchable.
  static const double _boilerplateTokenValue = 0.02;

  /// Share of the library a word must appear in before it is treated as this
  /// library's house style rather than as content.
  ///
  /// Set well clear of [_distinctiveRarity] so the two thresholds stay three
  /// tiers rather than two: a rare word is evidence, a common word is weak
  /// evidence worth the floor and worth flagging, and only a word in most of
  /// the library is worth nothing at all. A popular performer or series can
  /// carry a third of a collection and must stay content.
  static const double _boilerplateShare = 0.5;

  /// And an absolute floor, so a handful of files that happen to agree are not
  /// enough to condemn a word.
  static const int _minBoilerplateCount = 6;

  /// Pool size below which word frequency is noise rather than a signal.
  static const int _minLibraryForFrequency = 8;

  /// Relative difference at which the duration feature reaches zero.
  static const double _durationTolerance = 0.20;

  /// The same, for a script whose duration is only its last action timestamp
  /// and which is shorter than the media — the expected shape of a partial
  /// script, not a sign of a wrong match.
  static const double _lastActionDurationTolerance = 0.40;

  /// A pair must be this far apart *both* proportionally and in absolute terms
  /// before the mismatch counts as a conflict, so short clips are not ruled out
  /// over a few seconds.
  static const double _durationConflictRatio = 0.50;
  static const double _durationConflictSeconds = 120;
  static const double _durationConflictFactor = 0.35;

  static const double _ordinalConflictFactor = 0.15;
}

/// Geometric mean of containment and Jaccard overlap.
///
/// Containment alone rates a one-word name a perfect match for everything that
/// contains that word; Jaccard alone punishes a short correct name against a
/// long release name. Their geometric mean rewards a genuine subset while
/// collapsing on the degenerate single-token case.
double _overlap(Set<String> a, Set<String> b) {
  if (a.isEmpty || b.isEmpty) return 0;
  final shared = a.intersection(b).length;
  if (shared == 0) return 0;

  final containment = shared / math.min(a.length, b.length);
  final jaccard = shared / (a.length + b.length - shared);
  return math.sqrt(containment * jaccard);
}

/// Levenshtein edit distance, two-row so memory stays proportional to the
/// shorter string rather than to their product.
int levenshteinDistance(String a, String b) {
  if (a == b) return 0;
  if (a.isEmpty) return b.length;
  if (b.isEmpty) return a.length;

  var previous = List<int>.generate(b.length + 1, (i) => i);
  var current = List<int>.filled(b.length + 1, 0);

  for (var i = 0; i < a.length; i++) {
    current[0] = i + 1;
    for (var j = 0; j < b.length; j++) {
      final substitution =
          previous[j] + (a.codeUnitAt(i) == b.codeUnitAt(j) ? 0 : 1);
      final insertion = current[j] + 1;
      final deletion = previous[j + 1] + 1;
      current[j + 1] = math.min(substitution, math.min(insertion, deletion));
    }
    final swap = previous;
    previous = current;
    current = swap;
  }
  return previous[b.length];
}

/// `mm:ss`, or `h:mm:ss` past an hour. Used in evidence strings, which a person
/// reads and a model is shown.
String formatDuration(double seconds) {
  final total = seconds.round();
  final hours = total ~/ 3600;
  final minutes = (total % 3600) ~/ 60;
  final remainder = total % 60;
  final tail =
      '${minutes.toString().padLeft(hours > 0 ? 2 : 1, '0')}:'
      '${remainder.toString().padLeft(2, '0')}';
  return hours > 0 ? '$hours:$tail' : tail;
}

String _percent(double value) => '${(value * 100).round()}%';

/// Joins a handful of tokens for an evidence string, capped so one pathological
/// filename cannot produce an unreadable line.
String _list(Iterable<String> values) {
  final list = values.toList()..sort();
  if (list.length <= _maxListedTokens) return list.join(', ');
  return '${list.take(_maxListedTokens).join(', ')} '
      '(+${list.length - _maxListedTokens} more)';
}

const int _maxListedTokens = 5;

class _Scored {
  final int index;
  final _ScoreResult result;
  const _Scored(this.index, this.result);
}

/// A name in both the forms the character-similarity features may need: as
/// written, and with this library's house style taken out of it.
class _Content {
  final String stem;
  final Set<String> trigrams;

  /// The same with boilerplate removed, or null when the name is nothing but
  /// boilerplate and no such reduction exists.
  final String? contentStem;
  final Set<String>? contentTrigrams;

  const _Content({
    required this.stem,
    required this.trigrams,
    this.contentStem,
    this.contentTrigrams,
  });

  bool get hasContent => contentStem != null;
}

/// The pair of strings to compare, reduced the same way on both sides.
///
/// Stripping only one name would measure a title against a fragment and call
/// the difference a mismatch, so a name that is entirely house style pulls its
/// partner back to full text rather than being compared against a remainder.
({String a, String b}) _comparableStems(_Content a, _Content b) =>
    a.hasContent && b.hasContent
    ? (a: a.contentStem!, b: b.contentStem!)
    : (a: a.stem, b: b.stem);

({Set<String> a, Set<String> b}) _comparableTrigrams(_Content a, _Content b) =>
    a.hasContent && b.hasContent
    ? (a: a.contentTrigrams!, b: b.contentTrigrams!)
    : (a: a.trigrams, b: b.trigrams);

class _ScoreResult {
  final double score;
  final double baseScore;
  final List<MatchFeature> features;
  final List<MatchPenalty> penalties;

  const _ScoreResult({
    required this.score,
    required this.baseScore,
    required this.features,
    required this.penalties,
  });
}
