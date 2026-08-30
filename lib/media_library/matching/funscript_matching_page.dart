import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:signals/signals_flutter.dart';
import 'package:syncopathy/helper/platform_utils.dart';
import 'package:syncopathy/media_library/matching/fuzzy_matcher.dart';
import 'package:syncopathy/media_library/matching/match_draft.dart';
import 'package:syncopathy/media_library/matching/match_features.dart';
import 'package:syncopathy/media_library/matching/match_rules_store.dart';
import 'package:syncopathy/media_library/matching/matching_session_model.dart';
import 'package:syncopathy/media_library/matching/matching_settings.dart';
import 'package:syncopathy/media_library/matching/matching_settings_dialog.dart';
import 'package:syncopathy/model/settings_model.dart';
import 'package:syncopathy/notification_feed.dart';

/// The funscript matching tool.
///
/// A funscript whose name does not begin with a video's name is invisible to
/// normal indexing — it is skipped, and so is the video, and neither ever
/// reaches the library. This page finds both, scores every plausible pairing,
/// and asks a person. Nothing is written until Apply, and what Apply wrote can
/// be undone.
class FunscriptMatchingPage extends StatefulWidget {
  const FunscriptMatchingPage({super.key, this.session});

  /// A session to review instead of scanning for one.
  ///
  /// Only tests pass this. A widget test has no database to scan, and this
  /// page's job is laying out a review — which cannot be checked at all
  /// against the empty state a failed scan leaves behind.
  @visibleForTesting
  final MatchingSessionModel? session;

  @override
  State<FunscriptMatchingPage> createState() => _FunscriptMatchingPageState();
}

class _FunscriptMatchingPageState extends State<FunscriptMatchingPage> {
  late final FunscriptMatchingSettings _options;
  late final MatchRulesStore _rules;
  late final MatchingSessionModel _session;

  /// Holds keyboard focus for the review shortcuts. The list is meant to be
  /// worked through without touching the mouse, so the page grabs focus on
  /// open and takes it back whenever a decision is made from a button.
  final FocusNode _keyboardFocus = FocusNode(debugLabel: 'match review');

  /// Layout width below which the master/detail split stops being readable and
  /// becomes two stacked panes.
  static const double _wideLayoutBreakpoint = 900;

  /// Width the reviewer dragged the list to, or null while it follows the
  /// window.
  double? _listWidthOverride;

  /// Width of the review list.
  ///
  /// A share of the window rather than a fixed size: the list holds release
  /// names, which are long, and a column narrow enough to ellipsize every one
  /// of them to its common prefix is a column that cannot be worked from. The
  /// lower bound is what fits a score, a name and a decision icon; the upper
  /// bound leaves the detail pane — where the evidence lives — readable.
  double _listWidth(double available) {
    final maximum = math.max(_minListWidth, available - _minDetailWidth);
    final preferred = _listWidthOverride ?? available * _listWidthShare;
    return preferred.clamp(_minListWidth, maximum);
  }

  /// Apply-bar width below which the buttons drop to their short labels.
  static const double _compactApplyBarWidth = 820;

  /// Toolbar width below which the page title is dropped so the controls and
  /// the counts keep their room.
  static const double _compactToolbarWidth = 760;

  static const double _minListWidth = 420;
  static const double _minDetailWidth = 460;
  static const double _listWidthShare = 0.34;

  /// Share of a short window's height the stacked list may take. The detail
  /// pane keeps the rest, and it is the one that has to lay out a decision.
  static const double _stackedListShare = 0.4;

  @override
  void initState() {
    super.initState();
    _options = FunscriptMatchingSettings();
    _rules = MatchRulesStore();
    _session =
        widget.session ??
        MatchingSessionModel(context.read<SettingsModel>(), _options, _rules);
    if (widget.session == null) _start();
  }

  /// Loads what persisted, then scans. Opening the tool is itself the explicit
  /// action that permits the scan, so it does not ask a second time.
  Future<void> _start() async {
    await Future.wait([_options.load(), _rules.load()]);
    if (!mounted) return;
    await _session.scan();
    if (mounted) _keyboardFocus.requestFocus();
  }

  @override
  void dispose() {
    _keyboardFocus.dispose();
    // An injected session belongs to whoever passed it in.
    if (widget.session == null) _session.dispose();
    _options.dispose();
    super.dispose();
  }

  // --- Actions ---

  /// Runs [action] on the selected proposal and returns focus to the keyboard
  /// handler, so a decision made by clicking does not end the keyboard rhythm.
  void _onSelected(void Function(MatchProposal proposal) action) {
    final proposal = _session.selectedProposal;
    if (proposal == null) return;
    action(proposal);
    _keyboardFocus.requestFocus();
  }

  void _acceptNth(int index) => _onSelected((proposal) {
    if (index < proposal.candidates.length) {
      _session.accept(proposal, proposal.candidates[index].candidateId);
    }
  });

  Future<void> _openSettings() async {
    await showDialog<void>(
      context: context,
      builder: (context) => MatchingSettingsDialog(session: _session),
    );
    if (mounted) _keyboardFocus.requestFocus();
  }

  void _acceptObvious() {
    final accepted = _session.acceptClearWinners();
    _keyboardFocus.requestFocus();
    AlertManager.showSuccess(
      accepted == 0
          ? 'Nothing was unambiguous enough to take without a look.'
          : 'Accepted $accepted clear '
                '${accepted == 1 ? 'match' : 'matches'}. Everything left needs '
                'a decision.',
    );
  }

  Future<void> _apply() async {
    final outcome = await _session.apply();
    if (outcome == null || !mounted) return;

    if (outcome.linkedScripts > 0) {
      AlertManager.showSuccess(
        'Linked ${outcome.linkedScripts} '
        '${outcome.linkedScripts == 1 ? 'funscript' : 'funscripts'} to '
        '${outcome.linkedMedia} '
        '${outcome.linkedMedia == 1 ? 'video' : 'videos'}.',
      );
    }
    if (outcome.invalidated.isNotEmpty) {
      AlertManager.showWarning(
        '${outcome.invalidated.length} '
        '${outcome.invalidated.length == 1 ? 'match was' : 'matches were'} '
        'skipped because the files changed since the scan:\n'
        '${outcome.invalidated.take(3).join('\n')}',
      );
    }
    _keyboardFocus.requestFocus();
  }

  Future<void> _undoApply() async {
    final removed = await _session.revertLastApply();
    if (!mounted || removed == 0) return;
    AlertManager.showSuccess(
      'Undone: $removed ${removed == 1 ? 'link' : 'links'} removed.',
    );
  }

  // --- Build ---

  @override
  Widget build(BuildContext context) {
    return CallbackShortcuts(
      bindings: {
        const SingleActivator(LogicalKeyboardKey.arrowDown): () =>
            _session.step(1),
        const SingleActivator(LogicalKeyboardKey.arrowUp): () =>
            _session.step(-1),
        const SingleActivator(LogicalKeyboardKey.keyJ): () => _session.step(1),
        const SingleActivator(LogicalKeyboardKey.keyK): () => _session.step(-1),
        const SingleActivator(LogicalKeyboardKey.enter): () =>
            _onSelected(_session.acceptBest),
        const SingleActivator(LogicalKeyboardKey.keyN): () =>
            _onSelected(_session.reject),
        const SingleActivator(LogicalKeyboardKey.keyS): () =>
            _onSelected(_session.skip),
        const SingleActivator(LogicalKeyboardKey.keyU): () =>
            _onSelected(_session.undecide),
        for (var i = 0; i < 9; i++)
          SingleActivator(_digitKeys[i]): () => _acceptNth(i),
      },
      child: Focus(
        focusNode: _keyboardFocus,
        autofocus: true,
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: SignalBuilder(
            builder: (context) => Column(
              children: [
                _buildToolbar(context),
                const SizedBox(height: 8),
                Expanded(child: _buildBody(context)),
                _buildApplyBar(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  static const List<LogicalKeyboardKey> _digitKeys = [
    LogicalKeyboardKey.digit1,
    LogicalKeyboardKey.digit2,
    LogicalKeyboardKey.digit3,
    LogicalKeyboardKey.digit4,
    LogicalKeyboardKey.digit5,
    LogicalKeyboardKey.digit6,
    LogicalKeyboardKey.digit7,
    LogicalKeyboardKey.digit8,
    LogicalKeyboardKey.digit9,
  ];

  Widget _buildToolbar(BuildContext context) {
    final theme = Theme.of(context);
    final busy = _session.isBusy;
    final obvious = _session.clearWinnerCount;
    // Built here rather than inside the LayoutBuilder below. A LayoutBuilder
    // runs its builder during layout, outside the build this SignalBuilder is
    // tracking, so a signal read in there is a signal the toolbar never hears
    // about again — the scan would run to completion behind a status line
    // still showing its first message.
    final status = _buildStatus(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(12.0),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      // The controls and the counts are what the toolbar is for; the page
      // title is the one thing in it a reviewer already knows. Below the
      // width where everything fits, the title goes and the accept button
      // drops to its short label, rather than the row running off the edge.
      child: LayoutBuilder(
        builder: (context, constraints) {
          final compact = constraints.maxWidth < _compactToolbarWidth;
          return Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back),
                tooltip: 'Back to library',
                onPressed: () => Navigator.of(context).maybePop(),
              ),
              const SizedBox(width: 4),
              // Title and status share one Expanded rather than sitting in
              // the outer row as two flex children. A loose Flexible beside
              // an Expanded is given an equal share of the free space and
              // hands back whatever it does not use — and a Row aligned to
              // the start drops that remainder on the floor, leaving the
              // trailing buttons short of the right edge. Nested like this
              // the title shrinks when it has to and the status absorbs
              // every pixel it leaves behind.
              Expanded(
                child: Row(
                  children: [
                    if (!compact) ...[
                      Flexible(
                        child: Text(
                          'Match funscripts',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.titleMedium,
                        ),
                      ),
                      const SizedBox(width: 16),
                    ],
                    Expanded(child: status),
                  ],
                ),
              ),
              if (obvious > 0) ...[
                Tooltip(
                  message:
                      'Accepts only where the top video scores well and '
                      'nothing else comes close — and never where the matcher '
                      'flagged a reason to doubt it. Everything else still '
                      'needs you.',
                  child: FilledButton.tonalIcon(
                    icon: const Icon(Icons.done_all, size: 18),
                    label: Text(
                      compact ? 'Accept $obvious' : 'Accept $obvious obvious',
                    ),
                    onPressed: busy ? null : _acceptObvious,
                  ),
                ),
                const SizedBox(width: 8),
              ],
              IconButton(
                icon: const Icon(Icons.tune),
                tooltip: 'Matching options',
                onPressed: busy ? null : _openSettings,
              ),
              IconButton(
                icon: const Icon(Icons.refresh),
                tooltip: 'Scan again',
                onPressed: busy ? null : _session.scan,
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildStatus(BuildContext context) {
    final theme = Theme.of(context);
    final mono = theme.textTheme.bodySmall?.merge(GoogleFonts.robotoMono());
    final status = _session.status.value;

    if (status != null) {
      // The spinner tracks whether work is actually running, not whether there
      // is a message: a failure leaves its explanation on screen, and spinning
      // beside it would claim the tool is still trying.
      final busy = _session.isBusy;
      return Row(
        children: [
          if (busy)
            SizedBox(
              width: 14,
              height: 14,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                value: _session.progress.value,
              ),
            )
          else
            Icon(Icons.error_outline, size: 14, color: theme.colorScheme.error),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              status,
              // One line, always. A status squeezed thin by the buttons
              // beside it would otherwise wrap into a column of single
              // characters and push the whole toolbar open.
              maxLines: 1,
              style: busy
                  ? mono
                  : mono?.copyWith(color: theme.colorScheme.error),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      );
    }

    final discovery = _session.discovery.value;
    final total = _session.draft.value?.proposals.length ?? 0;
    if (total == 0) return const SizedBox.shrink();

    return Text(
      '${_session.decidedCount} of $total decided · '
      '${discovery.media.length} unmatched '
      '${discovery.media.length == 1 ? 'video' : 'videos'} to choose from',
      style: mono,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildBody(BuildContext context) {
    final draft = _session.draft.value;

    if (_session.phase.value == MatchSessionPhase.scanning) {
      return const Center(child: CircularProgressIndicator());
    }
    if (draft == null || draft.proposals.isEmpty) {
      return _buildEmptyState(context);
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final list = _ReviewList(session: _session);
        final detail = _DetailPane(session: _session, draft: draft);

        if (constraints.maxWidth >= _wideLayoutBreakpoint) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(width: _listWidth(constraints.maxWidth), child: list),
              _ListDivider(
                onDrag: (delta) => setState(() {
                  _listWidthOverride =
                      _listWidth(constraints.maxWidth) + delta;
                }),
              ),
              Expanded(child: detail),
            ],
          );
        }
        // Stacked. The list takes a share of the height rather than a fixed
        // slice, so a short window shrinks it instead of leaving the detail
        // pane too small to lay out.
        return Column(
          children: [
            SizedBox(
              height: math.min(260, constraints.maxHeight * _stackedListShare),
              child: list,
            ),
            const Divider(height: 16, thickness: 1),
            Expanded(child: detail),
          ],
        );
      },
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final theme = Theme.of(context);
    final discovery = _session.discovery.value;
    final scanned = _session.phase.value != MatchSessionPhase.idle;

    final String headline;
    final String detail;
    if (!scanned) {
      headline = 'Nothing scanned yet.';
      detail = 'Press the refresh button to look through your library folders.';
    } else if (discovery.totalScriptFiles == 0) {
      headline = 'No funscripts found.';
      detail =
          'Nothing under your library folders has a .funscript extension. '
          'Check the search paths in Settings.';
    } else if (discovery.trieResolvableScripts > 0) {
      headline = 'Nothing left to match by hand.';
      detail =
          '${discovery.trieResolvableScripts} '
          '${discovery.trieResolvableScripts == 1 ? 'funscript matches a video' : 'funscripts match videos'} '
          'by name already — refresh the library and they will link '
          'themselves.';
    } else {
      headline = 'Every funscript is already matched.';
      detail = 'Nothing on disk is missing a video.';
    }

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 420),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.done_all,
              size: 48,
              color: theme.colorScheme.onSurfaceVariant,
            ),
            const SizedBox(height: 16),
            Text(headline, style: theme.textTheme.titleMedium),
            const SizedBox(height: 8),
            Text(
              detail,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            if (discovery.skippedPaths.isNotEmpty) ...[
              const SizedBox(height: 16),
              Text(
                '${discovery.skippedPaths.length} folders could not be read.',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.error,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildApplyBar(BuildContext context) {
    final theme = Theme.of(context);
    final draft = _session.draft.value;
    final undoable = _session.lastApply.value;

    // Even with nothing left to review, the undo has to stay reachable.
    if ((draft == null || draft.proposals.isEmpty) && undoable == null) {
      return const SizedBox.shrink();
    }

    final total = draft?.proposals.length ?? 0;
    final decided = _session.decidedCount;
    final accepted = draft?.acceptedCount.value ?? 0;
    final rejected = draft?.rejected.length ?? 0;
    final busy = _session.isBusy;

    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Container(
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainer,
          borderRadius: BorderRadius.circular(12.0),
        ),
        padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
        child: Column(
          children: [
            if (total > 0)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(2),
                  child: LinearProgressIndicator(
                    value: total == 0 ? 0 : decided / total,
                    minHeight: 3,
                    backgroundColor: theme.colorScheme.surfaceContainerHighest,
                  ),
                ),
              ),
            LayoutBuilder(
              builder: (context, constraints) {
                final compact = constraints.maxWidth < _compactApplyBarWidth;
                return Row(
                  children: [
                    Expanded(
                      child: Text(
                        accepted == 0 && rejected == 0
                            ? 'Nothing has been changed yet.'
                            : '$accepted to link, $rejected to remember as '
                                  '"no match".',
                        // One line, always. This is the widest thing in the
                        // bar and the first to be squeezed, and left to wrap
                        // it grows the bar tall enough to swallow the review
                        // panes above it.
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodySmall,
                      ),
                    ),
                    if (undoable != null)
                      TextButton.icon(
                        icon: const Icon(Icons.undo, size: 16),
                        label: Text(
                          compact
                              ? 'Undo (${undoable.linkedScripts})'
                              : 'Undo last apply '
                                    '(${undoable.linkedScripts})',
                        ),
                        onPressed: busy ? null : _undoApply,
                      ),
                    TextButton(
                      onPressed: busy || decided == 0
                          ? null
                          : _session.clearDecisions,
                      child: Text(compact ? 'Reset' : 'Reset decisions'),
                    ),
                    const SizedBox(width: 8),
                    FilledButton.icon(
                      icon: const Icon(Icons.check, size: 18),
                      label: Text(
                        accepted == 0 ? 'Apply' : 'Apply $accepted',
                      ),
                      onPressed: busy || (accepted == 0 && rejected == 0)
                          ? null
                          : _apply,
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

// --- Review list ---

class _ReviewList extends StatefulWidget {
  const _ReviewList({required this.session});

  final MatchingSessionModel session;

  @override
  State<_ReviewList> createState() => _ReviewListState();
}

class _ReviewListState extends State<_ReviewList> {
  final TextEditingController _search = TextEditingController();
  final ScrollController _scroll = ScrollController();

  /// Fixed row height, which is what lets the list jump straight to a row
  /// rather than measuring its way there. Set a little above Material's dense
  /// two-line minimum so a larger text scale grows into the slack instead of
  /// being clipped by it.
  static const double _rowExtent = 68;

  @override
  void dispose() {
    _search.dispose();
    _scroll.dispose();
    super.dispose();
  }

  /// Keeps the keyboard-driven selection on screen. Without this, holding the
  /// down arrow walks the selection straight out of the viewport.
  void _revealSelected(List<MatchProposal> visible, String? selected) {
    if (!_scroll.hasClients || selected == null) return;
    final index = visible.indexWhere(
      (p) => p.script.funscriptHash == selected,
    );
    if (index < 0) return;

    final top = index * _rowExtent;
    final bottom = top + _rowExtent;
    final viewTop = _scroll.offset;
    final viewBottom = viewTop + _scroll.position.viewportDimension;

    final double? target;
    if (top < viewTop) {
      target = top;
    } else if (bottom > viewBottom) {
      target = bottom - _scroll.position.viewportDimension;
    } else {
      target = null;
    }
    if (target == null) return;

    _scroll.jumpTo(
      target.clamp(
        _scroll.position.minScrollExtent,
        _scroll.position.maxScrollExtent,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final session = widget.session;

    return SignalBuilder(
      builder: (context) {
        final visible = session.visibleProposals;
        final selected = session.selectedScriptHash.value;
        final draft = session.draft.value;
        final decisions = draft?.decisions.value ?? const {};

        WidgetsBinding.instance.addPostFrameCallback(
          (_) => _revealSelected(visible, selected),
        );

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildFilters(context, session),
            const SizedBox(height: 6),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: TextField(
                controller: _search,
                decoration: InputDecoration(
                  isDense: true,
                  prefixIcon: const Icon(Icons.search, size: 18),
                  hintText: 'Filter by name',
                  suffixIcon: _search.text.isEmpty
                      ? null
                      : IconButton(
                          icon: const Icon(Icons.close, size: 16),
                          onPressed: () {
                            _search.clear();
                            session.listSearch.value = '';
                          },
                        ),
                ),
                onChanged: (value) => session.listSearch.value = value,
              ),
            ),
            const SizedBox(height: 6),
            Expanded(
              child: visible.isEmpty
                  ? _buildEmptyList(context, session)
                  : ListView.builder(
                      controller: _scroll,
                      padding: EdgeInsets.zero,
                      itemExtent: _rowExtent,
                      itemCount: visible.length,
                      itemBuilder: (context, index) {
                        final proposal = visible[index];
                        final hash = proposal.script.funscriptHash;
                        return _ProposalTile(
                          proposal: proposal,
                          path: session.scriptPathFor(hash),
                          decision: decisions[hash],
                          isSelected: hash == selected,
                          onTap: () => session.select(proposal),
                        );
                      },
                    ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildFilters(BuildContext context, MatchingSessionModel session) {
    final draft = session.draft.value;
    final proposals = draft?.proposals ?? const <MatchProposal>[];
    final decisions = draft?.decisions.value ?? const {};

    int count(MatchReviewFilter filter) => switch (filter) {
      MatchReviewFilter.all => proposals.length,
      MatchReviewFilter.decided => decisions.length,
      MatchReviewFilter.noCandidates =>
        proposals.where((p) => !p.hasCandidates).length,
      MatchReviewFilter.needsReview => session.needsReviewCount,
    };

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        children: [
          for (final filter in MatchReviewFilter.values) ...[
            ChoiceChip(
              label: Text('${filter.label} (${count(filter)})'),
              labelStyle: Theme.of(context).textTheme.bodySmall,
              visualDensity: VisualDensity.compact,
              selected: session.listFilter.value == filter,
              onSelected: (_) => session.listFilter.value = filter,
            ),
            const SizedBox(width: 6),
          ],
        ],
      ),
    );
  }

  Widget _buildEmptyList(BuildContext context, MatchingSessionModel session) {
    final theme = Theme.of(context);
    final filtered =
        session.listSearch.value.isNotEmpty ||
        session.listFilter.value != MatchReviewFilter.needsReview;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Text(
          filtered
              ? 'Nothing here.'
              : 'Everything with a suggestion has been decided. Switch to '
                    '"All" to look back over them, or Apply.',
          textAlign: TextAlign.center,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ),
    );
  }
}

/// The divider between the list and the detail pane, draggable so a reviewer
/// working through very long release names can give the list the room it
/// needs without leaving the tool.
class _ListDivider extends StatelessWidget {
  const _ListDivider({required this.onDrag});

  final ValueChanged<double> onDrag;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.resizeLeftRight,
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onHorizontalDragUpdate: (details) => onDrag(details.delta.dx),
        // A one-pixel line is impossible to grab, so the hit area is padded
        // well past what it draws.
        child: const SizedBox(
          width: 16,
          child: VerticalDivider(width: 16, thickness: 1),
        ),
      ),
    );
  }
}

class _ProposalTile extends StatelessWidget {
  const _ProposalTile({
    required this.proposal,
    required this.path,
    required this.decision,
    required this.isSelected,
    required this.onTap,
  });

  final MatchProposal proposal;
  final String? path;
  final MatchDecision? decision;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final best = proposal.best;
    final flagged = best != null && (best.isDoubtful || proposal.isCloseCall);

    return ListTile(
      dense: true,
      // Tighter than the Material default on purpose: every pixel taken by
      // padding is a pixel of release name that ellipsizes away.
      contentPadding: const EdgeInsets.symmetric(horizontal: 8),
      horizontalTitleGap: 8,
      minLeadingWidth: 0,
      selected: isSelected,
      selectedTileColor: theme.colorScheme.surfaceContainerHighest,
      onTap: onTap,
      // The full path as a tooltip, so two near-identical names in the list can
      // be told apart without selecting each in turn.
      title: Tooltip(
        message: path ?? proposal.script.basename,
        child: Text(
          proposal.script.basename,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: theme.textTheme.bodyMedium,
        ),
      ),
      subtitle: Row(
        children: [
          if (best == null)
            Text(
              'no video suggested',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            )
          else ...[
            Text(
              _percent(best.score),
              style: theme.textTheme.bodySmall?.copyWith(
                color: _scoreColor(theme, best.score),
              ),
            ),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                best.media.basename,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ),
            if (flagged)
              Tooltip(
                message: proposal.isCloseCall
                    ? 'The runner-up is almost as good — worth a look'
                    : best.blockingCautions.first.explanation,
                child: Icon(
                  Icons.priority_high,
                  size: 14,
                  color: theme.colorScheme.tertiary,
                ),
              ),
          ],
        ],
      ),
      leading: proposal.companions.isEmpty
          ? null
          : Tooltip(
              message:
                  '${proposal.companions.length} multi-axis companion '
                  '${proposal.companions.length == 1 ? 'script' : 'scripts'} '
                  'follow this decision',
              child: const Icon(Icons.link, size: 18),
            ),
      trailing: _DecisionChip(decision: decision),
    );
  }
}

class _DecisionChip extends StatelessWidget {
  const _DecisionChip({required this.decision});

  final MatchDecision? decision;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final (IconData icon, Color color, String tooltip) =
        switch (decision?.kind) {
          MatchDecisionKind.accept => (
            Icons.check_circle,
            scheme.primary,
            'Will be linked on Apply',
          ),
          MatchDecisionKind.reject => (
            Icons.block,
            scheme.onSurfaceVariant,
            'No match — remembered so it is not suggested again',
          ),
          MatchDecisionKind.skip => (
            Icons.schedule,
            scheme.onSurfaceVariant,
            'Skipped for now',
          ),
          MatchDecisionKind.error => (
            Icons.error_outline,
            scheme.error,
            decision?.error ?? 'That decision could not be recorded',
          ),
          null => (Icons.circle_outlined, scheme.outlineVariant, 'Undecided'),
        };

    return Tooltip(message: tooltip, child: Icon(icon, size: 18, color: color));
  }
}

// --- Detail pane ---

class _DetailPane extends StatelessWidget {
  const _DetailPane({required this.session, required this.draft});

  final MatchingSessionModel session;
  final MatchDraft draft;

  @override
  Widget build(BuildContext context) {
    return SignalBuilder(
      builder: (context) {
        final proposal = session.selectedProposal;
        if (proposal == null) {
          return const Center(child: Text('Pick a funscript on the left.'));
        }

        final decision = draft.decisions.value[proposal.script.funscriptHash];
        final theme = Theme.of(context);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.only(right: 4),
                children: [
                  _ScriptHeader(session: session, proposal: proposal),
                  if (decision != null) ...[
                    const SizedBox(height: 8),
                    _DecisionBanner(
                      decision: decision,
                      proposal: proposal,
                      onClear: () => session.undecide(proposal),
                    ),
                  ],
                  if (proposal.hasCandidates) ...[
                    const SizedBox(height: 8),
                    _JudgementHint(proposal: proposal),
                  ],
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const _KindBadge(kind: _FileKind.media),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'which video is this funscript for?',
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ),
                      TextButton.icon(
                        icon: const Icon(Icons.block, size: 16),
                        label: const Text('No match'),
                        onPressed: () => session.reject(proposal),
                      ),
                      TextButton.icon(
                        icon: const Icon(Icons.schedule, size: 16),
                        label: const Text('Skip'),
                        onPressed: () => session.skip(proposal),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  if (proposal.candidates.isEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 24),
                      child: Text(
                        'No unmatched video shares a word or an identifier '
                        'with this name, so there is nothing to suggest. The '
                        'video may already be linked to another funscript, or '
                        'it may not be in your library folders at all.',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    )
                  else
                    for (var i = 0; i < proposal.candidates.length; i++)
                      _CandidateCard(
                        session: session,
                        candidate: proposal.candidates[i],
                        rank: i + 1,
                        script: proposal.script,
                        isChosen:
                            decision?.isAccept == true &&
                            decision?.candidateId ==
                                proposal.candidates[i].candidateId,
                        onChoose: () => session.accept(
                          proposal,
                          proposal.candidates[i].candidateId,
                        ),
                      ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
            const _KeyboardHints(),
          ],
        );
      },
    );
  }
}

/// Says, in one line, how much the top suggestion should be trusted.
///
/// The number alone is not enough. A confident-looking score reached on words
/// half the library shares is exactly the shape of the mistake this tool can
/// make, and a reviewer should not have to reconstruct that from a percentage
/// and a row of evidence chips.
class _JudgementHint extends StatelessWidget {
  const _JudgementHint({required this.proposal});

  final MatchProposal proposal;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final best = proposal.best!;
    final cautions = best.blockingCautions;
    final closeCall = proposal.isCloseCall;

    if (cautions.isEmpty && !closeCall) {
      if (best.score < 0.5) return const SizedBox.shrink();
      return _banner(
        theme,
        icon: Icons.check_circle_outline,
        color: theme.colorScheme.primary,
        title: 'The top suggestion looks clear.',
        detail: proposal.leadOverRunnerUp == null
            ? 'It is the only candidate, and it matches on distinctive words.'
            : 'It is ${_percent(proposal.leadOverRunnerUp!)} ahead of the '
                  'next best, on distinctive words.',
      );
    }

    final reasons = <String>[
      if (closeCall)
        'The runner-up is only '
            '${_percent(proposal.leadOverRunnerUp ?? 0)} behind, so the '
            'ranking is not really choosing between them.',
      for (final caution in cautions) caution.explanation,
    ];

    return _banner(
      theme,
      icon: Icons.priority_high,
      color: theme.colorScheme.tertiary,
      title: 'Worth checking before you accept.',
      detail: reasons.join(' '),
    );
  }

  Widget _banner(
    ThemeData theme, {
    required IconData icon,
    required Color color,
    required String title,
    required String detail,
  }) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: color.withValues(alpha: 0.5)),
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.all(10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.bodyMedium?.copyWith(color: color),
                ),
                Text(detail, style: theme.textTheme.bodySmall),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ScriptHeader extends StatelessWidget {
  const _ScriptHeader({required this.session, required this.proposal});

  final MatchingSessionModel session;
  final MatchProposal proposal;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final script = proposal.script;
    final best = proposal.best;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const _KindBadge(kind: _FileKind.funscript),
            const SizedBox(width: 8),
            Expanded(
              child: _HighlightedName(
                name: script.basename,
                shared: best?.sharedTokens ?? const {},
                distinctive: best?.distinctiveTokens ?? const {},
                style: theme.textTheme.titleMedium,
              ),
            ),
          ],
        ),
        _PathLine(path: session.scriptPathFor(script.funscriptHash)),
        const SizedBox(height: 4),
        Wrap(
          spacing: 12,
          runSpacing: 4,
          children: [
            if (script.directoryLabel != null)
              _Fact(icon: Icons.folder_outlined, text: script.directoryLabel!),
            if (script.effectiveDurationSeconds case final duration?)
              _Fact(
                icon: Icons.schedule,
                text: formatDuration(duration),
                tooltip: script.metadataDurationSeconds != null
                    ? 'Duration declared in the funscript metadata'
                    : 'Timestamp of the last action — the script may stop '
                          'before the video does',
              ),
            if (script.metadataTitle case final title?)
              _Fact(icon: Icons.title, text: title),
            if (script.performers.isNotEmpty)
              _Fact(
                icon: Icons.person_outline,
                text: script.performers.join(', '),
              ),
          ],
        ),
        if (proposal.companions.isNotEmpty) ...[
          const SizedBox(height: 8),
          Text(
            'These follow the same decision: '
            '${proposal.companions.map((c) => c.basename).join(', ')}',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ],
    );
  }
}

class _DecisionBanner extends StatelessWidget {
  const _DecisionBanner({
    required this.decision,
    required this.proposal,
    required this.onClear,
  });

  final MatchDecision decision;
  final MatchProposal proposal;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isError = decision.kind == MatchDecisionKind.error;

    final chosen = decision.isAccept
        ? proposal.candidateById(decision.candidateId!)
        : null;
    final summary = switch (decision.kind) {
      MatchDecisionKind.accept =>
        'Will link to "${chosen?.media.basename ?? '(unknown)'}"',
      MatchDecisionKind.reject => 'Marked as no match',
      MatchDecisionKind.skip => 'Skipped',
      MatchDecisionKind.error => decision.error ?? 'Could not be recorded',
    };

    return Container(
      decoration: BoxDecoration(
        color: isError
            ? theme.colorScheme.errorContainer
            : theme.colorScheme.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.fromLTRB(12, 8, 8, 8),
      child: Row(
        children: [
          Expanded(
            child: Text(summary, style: theme.textTheme.bodyMedium),
          ),
          TextButton(onPressed: onClear, child: const Text('Undo (U)')),
        ],
      ),
    );
  }
}

class _CandidateCard extends StatelessWidget {
  const _CandidateCard({
    required this.session,
    required this.candidate,
    required this.rank,
    required this.script,
    required this.isChosen,
    required this.onChoose,
  });

  final MatchingSessionModel session;
  final ScoredCandidate candidate;
  final int rank;
  final dynamic script;
  final bool isChosen;
  final VoidCallback onChoose;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final media = candidate.media;
    final path = session.mediaPathFor(media.fileHash);

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      color: isChosen ? theme.colorScheme.primaryContainer : null,
      child: InkWell(
        onTap: onChoose,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (rank <= 9)
                    Padding(
                      padding: const EdgeInsets.only(right: 8, top: 2),
                      child: _RankKey(rank: rank),
                    ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const _KindBadge(kind: _FileKind.media),
                            const SizedBox(width: 8),
                            Expanded(
                              child: _HighlightedName(
                                name: media.basename,
                                shared: candidate.sharedTokens,
                                distinctive: candidate.distinctiveTokens,
                                style: theme.textTheme.bodyLarge,
                              ),
                            ),
                          ],
                        ),
                        _PathLine(path: path),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  _ScoreBadge(
                    score: candidate.score,
                    baseScore: candidate.baseScore,
                    demoted: candidate.penalties.isNotEmpty,
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Wrap(
                spacing: 12,
                runSpacing: 4,
                children: [
                  if (media.directoryLabel != null)
                    _Fact(
                      icon: Icons.folder_outlined,
                      text: media.directoryLabel!,
                    ),
                  if (media.durationSeconds case final duration?)
                    _Fact(icon: Icons.schedule, text: formatDuration(duration)),
                  if (media.width != null && media.height != null)
                    _Fact(
                      icon: Icons.aspect_ratio,
                      text: '${media.width}×${media.height}',
                    ),
                  if (!session.mediaIsInLibrary(media.fileHash))
                    const _Fact(
                      icon: Icons.add_circle_outline,
                      text: 'not in the library yet',
                      tooltip:
                          'Indexing drops videos with no funscript, so this '
                          'one gets imported when you apply.',
                    ),
                ],
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: [
                  for (final caution in candidate.cautions)
                    _Chip(
                      text: caution.label,
                      tooltip: caution.explanation,
                      tone: caution.blocksBulkAccept
                          ? _ChipTone.caution
                          : _ChipTone.neutral,
                    ),
                  for (final penalty in candidate.penalties)
                    _Chip(text: penalty.evidence, tone: _ChipTone.negative),
                  for (final feature in candidate.features)
                    _Chip(text: feature.evidence),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (path != null)
                    TextButton.icon(
                      icon: const Icon(Icons.folder_open, size: 16),
                      label: const Text('Show video'),
                      onPressed: () => PlatformUtils.openFileExplorer(path),
                    ),
                  const SizedBox(width: 8),
                  if (isChosen)
                    TextButton.icon(
                      onPressed: null,
                      icon: const Icon(Icons.check, size: 16),
                      label: const Text('Chosen'),
                    )
                  else
                    FilledButton.tonal(
                      onPressed: onChoose,
                      child: const Text('Use this video'),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// --- Small shared pieces ---

/// A filename with the words it shares with the other side picked out.
///
/// Turns the score into something checkable: a reviewer can see at a glance
/// that two names agree on the title, or that the only thing they have in
/// common is a studio name the whole library carries.
class _HighlightedName extends StatelessWidget {
  const _HighlightedName({
    required this.name,
    required this.shared,
    required this.distinctive,
    this.style,
  });

  final String name;
  final Set<String> shared;
  final Set<String> distinctive;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final base = style ?? theme.textTheme.bodyMedium;
    if (shared.isEmpty) {
      return Text(name, maxLines: 2, overflow: TextOverflow.ellipsis, style: base);
    }

    final dim = base?.copyWith(color: theme.colorScheme.onSurfaceVariant);

    return Text.rich(
      TextSpan(
        children: [
          for (final run in _split(name))
            TextSpan(
              text: run,
              style: switch (_classify(run)) {
                _Emphasis.distinctive => base?.copyWith(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.w700,
                ),
                _Emphasis.common => base,
                _Emphasis.none => dim,
              },
            ),
        ],
      ),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }

  _Emphasis _classify(String run) {
    final token = run.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]'), '');
    if (token.isEmpty) return _Emphasis.none;
    if (distinctive.contains(token)) return _Emphasis.distinctive;
    if (shared.contains(token)) return _Emphasis.common;
    return _Emphasis.none;
  }

  /// Splits into word and separator runs, keeping both so the name renders
  /// exactly as it is on disk.
  static List<String> _split(String name) =>
      RegExp(r'[A-Za-z0-9]+|[^A-Za-z0-9]+')
          .allMatches(name)
          .map((m) => m.group(0)!)
          .toList();
}

enum _Emphasis { distinctive, common, none }

/// The number key that accepts this candidate.
class _RankKey extends StatelessWidget {
  const _RankKey({required this.rank});

  final int rank;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Tooltip(
      message: 'Press $rank to choose this video',
      child: Container(
        width: 20,
        height: 20,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          border: Border.all(color: theme.colorScheme.outlineVariant),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Text(
          '$rank',
          style: theme.textTheme.labelSmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ),
    );
  }
}

class _KeyboardHints extends StatelessWidget {
  const _KeyboardHints();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(top: 4, bottom: 2),
      child: DefaultTextStyle(
        style:
            theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ) ??
            const TextStyle(),
        child: const Wrap(
          spacing: 14,
          children: [
            Text('↑↓ move'),
            Text('⏎ accept best'),
            Text('1–9 pick'),
            Text('N no match'),
            Text('S skip'),
            Text('U undo'),
          ],
        ),
      ),
    );
  }
}

enum _FileKind {
  funscript('FUNSCRIPT', Icons.show_chart),
  media('VIDEO', Icons.movie_outlined);

  final String label;
  final IconData icon;
  const _FileKind(this.label, this.icon);
}

/// Says which of the two kinds of file a name refers to.
///
/// Without it the page is two columns of similar-looking filenames, and the
/// question it is asking — which video does this funscript belong to — is left
/// for the reader to infer.
class _KindBadge extends StatelessWidget {
  const _KindBadge({required this.kind});

  final _FileKind kind;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = kind == _FileKind.funscript
        ? theme.colorScheme.secondary
        : theme.colorScheme.primary;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        border: Border.all(color: color),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(kind.icon, size: 11, color: color),
          const SizedBox(width: 4),
          Text(
            kind.label,
            style: theme.textTheme.labelSmall?.copyWith(
              color: color,
              fontSize: 10,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}

/// The full path, copyable and openable in the file manager.
///
/// A basename alone is not enough to tell two files apart when the whole reason
/// they are on this page is that their names nearly agree.
class _PathLine extends StatelessWidget {
  const _PathLine({required this.path});

  final String? path;

  @override
  Widget build(BuildContext context) {
    final path = this.path;
    if (path == null) return const SizedBox.shrink();
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(top: 2),
      child: Row(
        children: [
          Expanded(
            child: Tooltip(
              message: path,
              child: Text(
                elidePath(path),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.bodySmall
                    ?.merge(GoogleFonts.robotoMono())
                    .copyWith(color: theme.colorScheme.onSurfaceVariant),
              ),
            ),
          ),
          const SizedBox(width: 4),
          _IconAction(
            icon: Icons.copy,
            tooltip: 'Copy path',
            onPressed: () => Clipboard.setData(ClipboardData(text: path)),
          ),
          _IconAction(
            icon: Icons.folder_open,
            tooltip: 'Show in file manager',
            onPressed: () => PlatformUtils.openFileExplorer(path),
          ),
        ],
      ),
    );
  }
}

class _IconAction extends StatelessWidget {
  const _IconAction({
    required this.icon,
    required this.tooltip,
    required this.onPressed,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(icon, size: 14),
      tooltip: tooltip,
      onPressed: onPressed,
      visualDensity: VisualDensity.compact,
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(minWidth: 26, minHeight: 26),
      color: Theme.of(context).colorScheme.onSurfaceVariant,
    );
  }
}

class _ScoreBadge extends StatelessWidget {
  const _ScoreBadge({
    required this.score,
    required this.baseScore,
    required this.demoted,
  });

  final double score;
  final double baseScore;
  final bool demoted;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = _scoreColor(theme, score);

    return Tooltip(
      message: demoted
          ? 'Scored ${_percent(baseScore)} on name evidence, then demoted by a '
                'conflict'
          : 'How well this video matches the funscript',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            _percent(score),
            style: theme.textTheme.titleMedium?.copyWith(color: color),
          ),
          SizedBox(
            width: 64,
            child: LinearProgressIndicator(
              value: score.clamp(0.0, 1.0),
              minHeight: 4,
              color: color,
              backgroundColor: theme.colorScheme.surfaceContainerHighest,
            ),
          ),
        ],
      ),
    );
  }
}

enum _ChipTone { neutral, negative, caution }

class _Chip extends StatelessWidget {
  const _Chip({
    required this.text,
    this.tone = _ChipTone.neutral,
    this.tooltip,
  });

  final String text;
  final _ChipTone tone;
  final String? tooltip;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final (Color background, Color foreground) = switch (tone) {
      _ChipTone.negative => (
        theme.colorScheme.errorContainer,
        theme.colorScheme.onErrorContainer,
      ),
      _ChipTone.caution => (
        theme.colorScheme.tertiaryContainer,
        theme.colorScheme.onTertiaryContainer,
      ),
      _ChipTone.neutral => (
        theme.colorScheme.surfaceContainerHighest,
        theme.colorScheme.onSurfaceVariant,
      ),
    };

    final chip = Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        text,
        style: theme.textTheme.bodySmall?.copyWith(color: foreground),
      ),
    );
    return tooltip == null ? chip : Tooltip(message: tooltip!, child: chip);
  }
}

class _Fact extends StatelessWidget {
  const _Fact({required this.icon, required this.text, this.tooltip});

  final IconData icon;
  final String text;
  final String? tooltip;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final row = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: theme.colorScheme.onSurfaceVariant),
        const SizedBox(width: 4),
        // A fact is a folder name, a scene title or a cast list, any of which
        // can be longer than the pane is wide. Ellipsized rather than allowed
        // to run off the edge — the tooltip below still carries the whole of
        // it.
        Flexible(
          child: Text(
            text,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ),
      ],
    );
    // Falls back to the fact itself, so anything the ellipsis took is still
    // readable.
    return Tooltip(message: tooltip ?? text, child: row);
  }
}

/// Three bands rather than a gradient: the number is already on screen, and the
/// colour only needs to say "strong / worth a look / probably not".
Color _scoreColor(ThemeData theme, double score) => score >= 0.6
    ? theme.colorScheme.primary
    : score >= 0.35
    ? theme.colorScheme.tertiary
    : theme.colorScheme.onSurfaceVariant;

String _percent(double value) => '${(value * 100).round()}%';

/// Shortens a path by dropping the middle, keeping the root and the last few
/// segments.
///
/// Plain tail truncation hides exactly the part that tells two files apart, and
/// the usual trick of rendering right-to-left risks the bidi algorithm
/// reordering a drive letter or a separator. Cutting the middle out ourselves
/// is predictable on every platform, and the tooltip still carries the whole
/// path.
@visibleForTesting
String elidePath(String path, {int keepTail = 3}) {
  final separator = path.contains(r'\') ? r'\' : '/';
  final segments = path.split(separator);
  if (segments.length <= keepTail + 2) return path;

  return [
    segments.first,
    '…',
    ...segments.sublist(segments.length - keepTail),
  ].join(separator);
}
