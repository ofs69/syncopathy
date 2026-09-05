import 'package:flutter/material.dart';
import 'package:signals/signals_flutter.dart';
import 'package:syncopathy/focus_numeric_input.dart';
import 'package:syncopathy/media_library/matching/matching_session_model.dart';
import 'package:syncopathy/media_library/matching/matching_settings.dart';
import 'package:syncopathy/media_library/matching/name_normalizer.dart';
import 'package:syncopathy/media_library/matching/noise_words_dialog.dart';

/// How the tool decides what to suggest, configured inside the tool.
///
/// Every knob here changes the ranking, so closing the dialog re-ranks what is
/// already on screen rather than leaving a list built by rules that no longer
/// apply.
class MatchingSettingsDialog extends StatefulWidget {
  const MatchingSettingsDialog({super.key, required this.session});

  final MatchingSessionModel session;

  @override
  State<MatchingSettingsDialog> createState() => _MatchingSettingsDialogState();
}

class _MatchingSettingsDialogState extends State<MatchingSettingsDialog> {
  FunscriptMatchingSettings get _options => widget.session.options;

  /// Set as soon as a knob that changes the ranking is touched, so the dialog
  /// can re-rank on close rather than leaving a stale list on screen.
  bool _rankingDirty = false;

  void _markDirty() => _rankingDirty = true;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AlertDialog(
      title: const Text('Matching options'),
      content: SizedBox(
        width: 520,
        child: SingleChildScrollView(
          child: SignalBuilder(
            builder: (context) => Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _numberRow(
                  label: 'Candidates per funscript',
                  help:
                      'Nothing outside this list can be chosen. A longer list '
                      'finds more, and hides the right answer further down.',
                  value: _options.maxCandidates.value.toDouble(),
                  min: 1,
                  max: 50,
                  onChanged: (value) {
                    _options.maxCandidates.value = value.round();
                    _markDirty();
                  },
                ),
                const SizedBox(height: 8),
                _scoreFloorRow(theme),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  dense: true,
                  title: const Text('Use folder names'),
                  subtitle: const Text(
                    'A funscript and a video in the same folder is weak '
                    'evidence, but real.',
                  ),
                  value: _options.useDirectoryLabels.value,
                  onChanged: (value) {
                    _options.useDirectoryLabels.value = value;
                    _markDirty();
                  },
                ),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  dense: true,
                  title: const Text('Use funscript metadata'),
                  subtitle: const Text(
                    'Title and performers written into the funscript itself.',
                  ),
                  value: _options.useScriptMetadata.value,
                  onChanged: (value) {
                    _options.useScriptMetadata.value = value;
                    _markDirty();
                  },
                ),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  dense: true,
                  title: const Text('Require a distinctive word'),
                  subtitle: const Text(
                    'Hide suggestions whose only agreement is words much of '
                    'the library uses. Fewer rows, and none of them guesses.',
                  ),
                  value: _options.requireDistinctiveEvidence.value,
                  onChanged: (value) {
                    _options.requireDistinctiveEvidence.value = value;
                    _markDirty();
                  },
                ),
                _wordFilterRow(theme),
                const Divider(height: 24),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  dense: true,
                  title: const Text('Move on after each decision'),
                  subtitle: const Text(
                    'Deciding a row selects the next one that needs review.',
                  ),
                  value: widget.session.autoAdvance.value,
                  onChanged: (value) =>
                      widget.session.autoAdvance.value = value,
                ),
              ],
            ),
          ),
        ),
      ),
      // Destructive on the left, done on the right. Set through the dialog's
      // own alignment rather than a Spacer: these go into an OverflowBar, not
      // a Row, and a Spacer there is a flex child with nowhere to flex.
      actionsAlignment: MainAxisAlignment.spaceBetween,
      actions: [
        TextButton(
          onPressed: _confirmForgetRejections,
          child: const Text('Forget rejections'),
        ),
        FilledButton(
          onPressed: () {
            if (_rankingDirty) widget.session.rerank();
            Navigator.of(context).pop();
          },
          child: const Text('Done'),
        ),
      ],
    );
  }

  /// Opens the noise-word list. A row rather than an inline list: there are a
  /// couple of hundred built-in words, and none of them is what someone came
  /// into this dialog for.
  Widget _wordFilterRow(ThemeData theme) {
    final own = _options.extraNoiseWords.value.length;
    final excused = _options.matchedBuiltinWords.value.length;

    final summary = switch ((own, excused)) {
      (0, 0) => 'Using the built-in list of ${builtinNoiseWords.length} words.',
      (final o, 0) => '$o of your own, on top of the built-in list.',
      (0, final e) => '$e built-in ${e == 1 ? 'word' : 'words'} turned off.',
      (final o, final e) =>
        '$o of your own, $e built-in ${e == 1 ? 'word' : 'words'} turned off.',
    };

    return ListTile(
      contentPadding: EdgeInsets.zero,
      dense: true,
      title: const Text('Words to ignore'),
      subtitle: Text(
        summary,
        style: theme.textTheme.bodySmall?.copyWith(
          color: theme.colorScheme.onSurfaceVariant,
        ),
      ),
      trailing: const Icon(Icons.chevron_right),
      onTap: _openWordFilter,
    );
  }

  Future<void> _openWordFilter() async {
    final changed = await showDialog<bool>(
      context: context,
      builder: (context) => NoiseWordsDialog(options: _options),
    );
    if (changed == true) _markDirty();
  }

  Widget _numberRow({
    required String label,
    required double value,
    required double min,
    required double max,
    required ValueChanged<double> onChanged,
    String? help,
  }) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: theme.textTheme.bodyMedium),
              if (help != null)
                Text(
                  help,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        SizedBox(
          width: 96,
          child: FocusNumericInput(
            value: value,
            min: min,
            max: max,
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }

  Widget _scoreFloorRow(ThemeData theme) {
    final score = _options.minimumScore.value;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text('Minimum score', style: theme.textTheme.bodyMedium),
            ),
            Text('${(score * 100).round()}%'),
          ],
        ),
        Slider(
          value: score,
          max: 0.9,
          divisions: 90,
          onChanged: (value) {
            _options.minimumScore.value = value;
            _markDirty();
          },
        ),
        Text(
          'Anything weaker is dropped rather than shown. A list of rubbish is '
          'a list nobody reads.',
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  Future<void> _confirmForgetRejections() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Forget rejections?'),
        content: const Text(
          'Pairs you previously marked as "no match" will be suggested again '
          'on the next scan.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Forget'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    await widget.session.rules.clear();
    _markDirty();
  }
}
