import 'package:signals/signals_flutter.dart';
import 'package:syncopathy/ioc.dart';
import 'package:syncopathy/logging.dart';
import 'package:syncopathy/media_library/matching/fuzzy_matcher.dart';
import 'package:syncopathy/media_library/matching/match_apply.dart';
import 'package:syncopathy/media_library/matching/match_discovery.dart';
import 'package:syncopathy/media_library/matching/match_draft.dart';
import 'package:syncopathy/media_library/matching/match_features.dart';
import 'package:syncopathy/media_library/matching/match_rules_store.dart';
import 'package:syncopathy/media_library/matching/matching_settings.dart';
import 'package:syncopathy/model/settings_model.dart';

enum MatchSessionPhase {
  /// Nothing scanned yet, or the last scan was discarded.
  idle,

  /// Walking the library. Read-only.
  scanning,

  /// Proposals are on screen and waiting on decisions.
  reviewing,

  /// Writing accepted matches, or undoing a write.
  applying,
}

/// Which subset of the proposals the review list shows.
enum MatchReviewFilter {
  needsReview('Needs review'),
  decided('Decided'),
  noCandidates('No suggestion'),
  all('All');

  final String label;
  const MatchReviewFilter(this.label);
}

/// Drives one repair session, from scan to Apply.
///
/// Owns the whole flow because the flow is the thing that has to stay honest:
/// the tool scans on request only, holds everything in memory, and writes
/// exactly once when the user says so. Nothing here is registered as a startup
/// effect or reachable from normal indexing.
class MatchingSessionModel {
  final SettingsModel _settings;
  final FunscriptMatchingSettings options;
  final MatchRulesStore rules;

  final Signal<MatchSessionPhase> phase = signal(MatchSessionPhase.idle);
  final Signal<String?> status = signal(null);
  final Signal<double?> progress = signal(null);

  final Signal<MatchDiscoveryResult> discovery = signal(
    MatchDiscoveryResult.empty,
  );
  final Signal<MatchDraft?> draft = signal(null);

  /// The proposal shown in the detail pane. Held by script hash rather than by
  /// object so it survives a re-rank that produces an equal-but-new proposal.
  final Signal<String?> selectedScriptHash = signal(null);

  /// What the last Apply wrote, kept so it can be undone.
  final Signal<MatchApplyOutcome?> lastApply = signal(null);

  final Signal<MatchReviewFilter> listFilter = signal(
    MatchReviewFilter.needsReview,
  );
  final Signal<String> listSearch = signal('');

  /// Whether deciding a row moves on to the next one that needs review.
  ///
  /// Reviewing a backlog is a rhythm — look, judge, move — and having to aim at
  /// the next row by hand between every judgement is what makes a long list
  /// feel long.
  final Signal<bool> autoAdvance = signal(true);

  final Map<String, UnmatchedMedia> _mediaByHash = {};
  final Map<String, UnmatchedFunscript> _scriptsByHash = {};

  MatchingSessionModel(this._settings, this.options, this.rules);

  bool get isBusy =>
      phase.value == MatchSessionPhase.scanning ||
      phase.value == MatchSessionPhase.applying;

  /// Where a file actually is on disk.
  ///
  /// Paths live here rather than on the snapshots, which stay a description of
  /// a file rather than a handle to one.
  String? mediaPathFor(String fileHash) => _mediaByHash[fileHash]?.path;
  String? scriptPathFor(String funscriptHash) =>
      _scriptsByHash[funscriptHash]?.path;

  /// Whether the video behind [fileHash] is already a library row, rather than
  /// a file this tool found and would import.
  bool mediaIsInLibrary(String fileHash) =>
      _mediaByHash[fileHash]?.inLibrary ?? false;

  MatchProposal? get selectedProposal {
    final hash = selectedScriptHash.value;
    if (hash == null) return null;
    for (final proposal in draft.value?.proposals ?? const <MatchProposal>[]) {
      if (proposal.script.funscriptHash == hash) return proposal;
    }
    return null;
  }

  // --- The review list ---

  /// The proposals the list is currently showing, filtered and searched.
  List<MatchProposal> get visibleProposals {
    final current = draft.value;
    if (current == null) return const [];

    final filter = listFilter.value;
    final query = listSearch.value.trim().toLowerCase();
    final decisions = current.decisions.value;

    return [
      for (final proposal in current.proposals)
        if (_matchesFilter(proposal, decisions, filter) &&
            _matchesQuery(proposal, query))
          proposal,
    ];
  }

  bool _matchesFilter(
    MatchProposal proposal,
    Map<String, MatchDecision> decisions,
    MatchReviewFilter filter,
  ) {
    final decided = decisions.containsKey(proposal.script.funscriptHash);
    return switch (filter) {
      MatchReviewFilter.all => true,
      MatchReviewFilter.decided => decided,
      MatchReviewFilter.noCandidates => !proposal.hasCandidates,
      // A row with nothing to choose from is not waiting on a judgement; it is
      // waiting on a different library. Keeping it out of the review queue is
      // what stops the queue looking permanently unfinished.
      MatchReviewFilter.needsReview => !decided && proposal.hasCandidates,
    };
  }

  bool _matchesQuery(MatchProposal proposal, String query) {
    if (query.isEmpty) return true;
    if (proposal.script.basename.toLowerCase().contains(query)) return true;
    for (final candidate in proposal.candidates) {
      if (candidate.media.basename.toLowerCase().contains(query)) return true;
    }
    return false;
  }

  int get decidedCount => draft.value?.decisions.value.length ?? 0;

  /// Proposals that still need a person: undecided, and with something to
  /// choose from.
  int get needsReviewCount {
    final current = draft.value;
    if (current == null) return 0;
    final decisions = current.decisions.value;
    var count = 0;
    for (final proposal in current.proposals) {
      if (proposal.hasCandidates &&
          !decisions.containsKey(proposal.script.funscriptHash)) {
        count++;
      }
    }
    return count;
  }

  void select(MatchProposal proposal) =>
      selectedScriptHash.value = proposal.script.funscriptHash;

  /// Moves the selection by [delta] within the visible list.
  void step(int delta) {
    final visible = visibleProposals;
    if (visible.isEmpty) return;

    final current = selectedScriptHash.value;
    final index = visible.indexWhere(
      (p) => p.script.funscriptHash == current,
    );
    final next = index < 0
        ? 0
        : (index + delta).clamp(0, visible.length - 1);
    selectedScriptHash.value = visible[next].script.funscriptHash;
  }

  /// Selects the next row still needing review, wrapping to the start.
  ///
  /// Wrapping matters when the list is filtered to `Needs review`: deciding a
  /// row removes it, so "the next one" is usually whatever slid into its place,
  /// and at the end of the list that is the first row again.
  void advance() {
    final visible = visibleProposals;
    if (visible.isEmpty) {
      selectedScriptHash.value = null;
      return;
    }

    final current = selectedScriptHash.value;
    final index = visible.indexWhere((p) => p.script.funscriptHash == current);
    if (index >= 0) {
      selectedScriptHash.value =
          visible[(index + 1) % visible.length].script.funscriptHash;
      return;
    }
    // The current row was filtered out by the decision just made; whatever now
    // occupies its position is the natural next one.
    selectedScriptHash.value = visible.first.script.funscriptHash;
  }

  // --- Deciding ---

  void accept(MatchProposal proposal, String candidateId) =>
      _decide(proposal, MatchDecision.accept(candidateId));

  /// Accepts the best candidate. The keyboard's default action.
  void acceptBest(MatchProposal proposal) {
    final best = proposal.best;
    if (best == null) return;
    accept(proposal, best.candidateId);
  }

  void reject(MatchProposal proposal) =>
      _decide(proposal, MatchDecision.reject());

  void skip(MatchProposal proposal) =>
      _decide(proposal, const MatchDecision.skip());

  void _decide(MatchProposal proposal, MatchDecision decision) {
    final current = draft.value;
    if (current == null) return;

    final wasSelected =
        selectedScriptHash.value == proposal.script.funscriptHash;
    current.record(proposal, decision);
    if (wasSelected && autoAdvance.value) advance();
  }

  void undecide(MatchProposal proposal) => draft.value?.clearDecision(proposal);

  /// Drops every decision. Nothing has been written, so this is all it takes.
  void clearDecisions() => draft.value?.clear();

  /// Accepts every undecided proposal whose top candidate is both strong and
  /// clearly ahead of the runner-up.
  ///
  /// The gap is the important half. A high score on its own is exactly how a
  /// confident wrong answer looks — two files from the same series share a long
  /// title and score alike — so a top candidate is only unambiguous when
  /// nothing else came close.
  ///
  /// Returns how many were accepted.
  int acceptClearWinners({
    double minScore = clearWinnerScore,
    double minGap = clearWinnerGap,
  }) {
    final current = draft.value;
    if (current == null) return 0;

    var accepted = 0;
    for (final proposal in current.proposals) {
      if (current.decisionFor(proposal) != null) continue;
      if (!isClearWinner(proposal, minScore: minScore, minGap: minGap)) {
        continue;
      }
      current.record(
        proposal,
        MatchDecision.accept(proposal.best!.candidateId),
      );
      accepted++;
    }
    return accepted;
  }

  /// How many proposals [acceptClearWinners] would take.
  int get clearWinnerCount {
    final current = draft.value;
    if (current == null) return 0;
    var count = 0;
    for (final proposal in current.proposals) {
      if (current.decisionFor(proposal) != null) continue;
      if (isClearWinner(proposal)) count++;
    }
    return count;
  }

  /// Score a top candidate must reach before it can be taken unreviewed.
  static const double clearWinnerScore = 0.65;

  /// How far ahead of the runner-up it must be.
  static const double clearWinnerGap = 0.25;

  static bool isClearWinner(
    MatchProposal proposal, {
    double minScore = clearWinnerScore,
    double minGap = clearWinnerGap,
  }) {
    final best = proposal.best;
    if (best == null || best.score < minScore) return false;
    // A candidate the matcher has already flagged as possibly-wrong is exactly
    // the one that must not be taken without someone looking at it.
    if (best.isDoubtful) return false;
    if (proposal.candidates.length == 1) return true;
    return best.score - proposal.candidates[1].score >= minGap;
  }

  // --- Scanning ---

  /// Scans the library and rebuilds the proposals. Read-only from start to end.
  Future<void> scan() async {
    if (isBusy) return;

    phase.value = MatchSessionPhase.scanning;
    status.value = 'Starting…';
    progress.value = null;

    try {
      final result = await MatchDiscovery.run(
        searchPaths: _settings.mediaPaths.value,
        storeReference: oBox.store.reference,
        onProgress: (text, value) {
          status.value = text;
          progress.value = value;
        },
      );

      discovery.value = result;
      // The scan is the new truth about the library; an undo aimed at the state
      // before it would be undoing something nobody can still see.
      lastApply.value = null;
      _mediaByHash
        ..clear()
        ..addEntries(result.media.map((m) => MapEntry(m.fileHash, m)));
      _scriptsByHash
        ..clear()
        ..addEntries(result.scripts.map((s) => MapEntry(s.funscriptHash, s)));

      _rebuildProposals(result);
      phase.value = MatchSessionPhase.reviewing;
    } catch (e, st) {
      Logger.error('Funscript matching scan failed', e, st);
      status.value = 'Scan failed: $e';
      phase.value = MatchSessionPhase.idle;
    } finally {
      progress.value = null;
    }
  }

  void _rebuildProposals(MatchDiscoveryResult result) {
    final matcher = FuzzyMatcher(
      result.media.map((m) => m.toSnapshot()),
      options: options.matchingOptions,
      rejectedPairs: rules.rejectedPairs,
    );

    final proposals = matcher.proposeAll(
      result.scripts.map((s) => s.toSnapshot()),
    );

    // Unambiguous suggestions first, then the rest by score. The reviewer's
    // first decisions should be the ones that take a second, and the ones that
    // need thinking about should not be interleaved with them.
    proposals.sort((a, b) {
      final byClarity = _clarity(b).compareTo(_clarity(a));
      if (byClarity != 0) return byClarity;
      final byScore = (b.best?.score ?? -1).compareTo(a.best?.score ?? -1);
      if (byScore != 0) return byScore;
      return a.script.basename.toLowerCase().compareTo(
        b.script.basename.toLowerCase(),
      );
    });

    draft.value?.dispose();
    draft.value = MatchDraft(proposals);
    selectedScriptHash.value = proposals.isEmpty
        ? null
        : proposals.first.script.funscriptHash;
    status.value = null;
  }

  static int _clarity(MatchProposal proposal) {
    if (!proposal.hasCandidates) return 0;
    return isClearWinner(proposal) ? 2 : 1;
  }

  /// Re-ranks the scripts already found, without touching the disk again.
  ///
  /// Changing a scoring option means the old ranking is wrong, and a decision
  /// made against a ranking that no longer exists is worse than no decision, so
  /// the draft is rebuilt rather than carried over.
  void rerank() {
    if (isBusy) return;
    if (discovery.value.scripts.isEmpty) return;
    _rebuildProposals(discovery.value);
  }

  // --- Writing ---

  /// Writes every accepted match, and remembers every rejection.
  Future<MatchApplyOutcome?> apply() async {
    final current = draft.value;
    if (current == null || isBusy) return null;

    final accepted = current.accepted;
    final rejected = current.rejected;
    if (accepted.isEmpty && rejected.isEmpty) return null;

    phase.value = MatchSessionPhase.applying;
    status.value = 'Applying…';

    try {
      final outcome = await MatchApplier.apply(
        accepted,
        mediaByHash: _mediaByHash,
        scriptsByHash: _scriptsByHash,
      );

      // A "no match" means none of these candidates, so every candidate that
      // was on offer is suppressed — otherwise the next scan asks the same
      // question with the same answers.
      await rules.reject([
        for (final proposal in rejected)
          for (final candidate in proposal.candidates)
            (proposal.script.funscriptHash, candidate.media.fileHash),
      ]);

      lastApply.value = outcome.isRevertable ? outcome : null;
      _retire(accepted);
      return outcome;
    } catch (e, st) {
      Logger.error('Applying funscript matches failed', e, st);
      status.value = 'Apply failed: $e';
      return null;
    } finally {
      phase.value = MatchSessionPhase.reviewing;
      if (status.value == 'Applying…') status.value = null;
    }
  }

  /// Undoes the last Apply, removing exactly the relations it wrote.
  ///
  /// One Apply can link dozens of files, and a mistake spread across that many
  /// rows is not something anyone wants to unpick by hand. Files on disk are
  /// never touched.
  ///
  /// Rescans afterwards, because the scripts that just became unlinked are
  /// unmatched again and the session's view of the library is now wrong.
  /// Returns how many relations were removed.
  Future<int> revertLastApply() async {
    final outcome = lastApply.value;
    if (outcome == null || isBusy) return 0;

    phase.value = MatchSessionPhase.applying;
    status.value = 'Undoing…';
    int removed;
    try {
      removed = MatchApplier.revert(outcome.links);
      lastApply.value = null;
    } catch (e, st) {
      Logger.error('Reverting the last apply failed', e, st);
      status.value = 'Undo failed: $e';
      phase.value = MatchSessionPhase.reviewing;
      return 0;
    }

    phase.value = MatchSessionPhase.reviewing;
    status.value = null;
    await scan();
    return removed;
  }

  /// Drops everything an Apply consumed and re-ranks what is left.
  ///
  /// A linked script is no longer unmatched and a linked video is no longer a
  /// free candidate, so leaving either in the session would offer a video that
  /// now has a script and let the same match be applied twice. Rebuilding from
  /// the remainder is cheaper and more honest than a second full scan.
  void _retire(List<AcceptedMatch> accepted) {
    final retiredScripts = <String>{};
    final retiredMedia = <String>{};
    for (final match in accepted) {
      retiredScripts.addAll(match.funscriptHashes);
      retiredMedia.add(match.mediaHash);
    }

    for (final hash in retiredScripts) {
      _scriptsByHash.remove(hash);
    }
    for (final hash in retiredMedia) {
      _mediaByHash.remove(hash);
    }

    final previous = discovery.value;
    final remaining = MatchDiscoveryResult(
      media: [
        for (final media in previous.media)
          if (!retiredMedia.contains(media.fileHash)) media,
      ],
      scripts: [
        for (final script in previous.scripts)
          if (!retiredScripts.contains(script.funscriptHash)) script,
      ],
      trieResolvableScripts: previous.trieResolvableScripts,
      totalMediaFiles: previous.totalMediaFiles,
      totalScriptFiles: previous.totalScriptFiles,
      skippedPaths: previous.skippedPaths,
    );

    discovery.value = remaining;
    _rebuildProposals(remaining);
  }

  void dispose() {
    draft.value?.dispose();
  }
}
