import 'package:flutter/material.dart';
import 'package:signals/signals_flutter.dart';
import 'package:syncopathy/helper/constants.dart';
import 'package:syncopathy/media_library/matching/matching_settings.dart';
import 'package:syncopathy/media_library/matching/name_normalizer.dart';

/// Which words matching throws away before it compares two names.
///
/// The built-in list is a guess about filenames in general, and every library
/// eventually contradicts it in both directions: a studio that repeats its own
/// name in every file needs a word added, and a series actually called `Quest`
/// needs one taken back. Both halves live here rather than in two places,
/// because to a reviewer they are one question — which words mean nothing.
class NoiseWordsDialog extends StatefulWidget {
  const NoiseWordsDialog({super.key, required this.options});

  final FunscriptMatchingSettings options;

  @override
  State<NoiseWordsDialog> createState() => _NoiseWordsDialogState();
}

class _NoiseWordsDialogState extends State<NoiseWordsDialog> {
  final TextEditingController _entry = TextEditingController();
  final TextEditingController _search = TextEditingController();
  final FocusNode _entryFocus = FocusNode();

  /// Whether anything changed, so the caller only re-ranks when it has to.
  bool _dirty = false;

  String _filter = '';

  @override
  void dispose() {
    _entry.dispose();
    _search.dispose();
    _entryFocus.dispose();
    super.dispose();
  }

  void _add() {
    final added = widget.options.addNoiseWord(_entry.text);
    // Cleared either way: re-typing an entry that was already in the list is
    // not a correction, and leaving it in the field reads as a failure.
    _entry.clear();
    _entryFocus.requestFocus();
    if (added != null) _dirty = true;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final options = widget.options;

    return AlertDialog(
      title: const Text('Words to ignore'),
      // One scroll for the whole dialog rather than a fixed header over a
      // scrolling list: the header alone is taller than a 520px window can
      // give it, and a header that cannot fit is worse than one that scrolls.
      content: SizedBox(
        width: 560,
        child: SignalBuilder(
          builder: (context) => SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Ignored words are removed from both filenames before they '
                  'are compared, so two files can agree on them without that '
                  'counting as evidence.',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 12),
                _buildOwnWords(theme, options),
                const Divider(height: 24),
                _buildBuiltinHeader(theme, options),
                const SizedBox(height: 8),
                ..._buildBuiltinGroups(theme, options),
              ],
            ),
          ),
        ),
      ),
      actions: [
        FilledButton(
          onPressed: () => Navigator.of(context).pop(_dirty),
          child: const Text('Done'),
        ),
      ],
    );
  }

  Widget _buildOwnWords(ThemeData theme, FunscriptMatchingSettings options) {
    final words = options.extraNoiseWords.value.toList()..sort();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text('Your words', style: theme.textTheme.titleSmall),
        const SizedBox(height: 6),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _entry,
                focusNode: _entryFocus,
                decoration: const InputDecoration(
                  isDense: true,
                  hintText: 'A word every file of yours carries',
                ),
                onSubmitted: (_) => _add(),
              ),
            ),
            const SizedBox(width: 8),
            FilledButton.tonal(onPressed: _add, child: const Text('Add')),
          ],
        ),
        if (words.isEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              'Nothing yet. The matcher already discounts words most of your '
              'library shares; add one here when it should be dropped '
              'outright.',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          )
        else
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Wrap(
              spacing: 6,
              runSpacing: 6,
              children: [
                for (final word in words)
                  InputChip(
                    label: Text(word),
                    onDeleted: () {
                      options.removeNoiseWord(word);
                      _dirty = true;
                    },
                  ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildBuiltinHeader(
    ThemeData theme,
    FunscriptMatchingSettings options,
  ) {
    final excused = options.matchedBuiltinWords.value.length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: Text('Built-in words', style: theme.textTheme.titleSmall),
            ),
            if (excused > 0)
              TextButton(
                onPressed: () {
                  options.restoreBuiltinNoiseWords();
                  _dirty = true;
                },
                child: const Text('Ignore all again'),
              ),
          ],
        ),
        Text(
          excused == 0
              ? 'All of these are ignored. Turn one off to match on it — a '
                    'library whose titles really do say "quest" or "final" '
                    'needs the word back.'
              : '$excused turned off, so ${excused == 1 ? 'it counts' : 'they count'} '
                    'as part of a title again.',
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _search,
          decoration: InputDecoration(
            isDense: true,
            prefixIcon: const Icon(Icons.search, size: 18),
            prefixIconConstraints: denseFieldIconBox,
            suffixIconConstraints: denseFieldIconBox,
            hintText: 'Find a word',
            suffixIcon: _filter.isEmpty
                ? null
                : IconButton(
                    icon: const Icon(Icons.close, size: 16),
                    padding: EdgeInsets.zero,
                    constraints: denseFieldIconBox,
                    style: IconButton.styleFrom(
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    onPressed: () {
                      _search.clear();
                      setState(() => _filter = '');
                    },
                  ),
          ),
          onChanged: (value) =>
              setState(() => _filter = value.trim().toLowerCase()),
        ),
      ],
    );
  }

  List<Widget> _buildBuiltinGroups(
    ThemeData theme,
    FunscriptMatchingSettings options,
  ) {
    final groups = [
      for (final group in builtinNoiseWordGroups)
        (
          label: group.label,
          words: _filter.isEmpty
              ? group.words
              : group.words.where((w) => w.contains(_filter)).toList(),
        ),
    ].where((group) => group.words.isNotEmpty).toList();

    if (groups.isEmpty) {
      return [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Text(
            'No built-in word contains "$_filter". Add it under "Your words" '
            'to have it ignored.',
            textAlign: TextAlign.center,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ),
      ];
    }

    return [
      for (final group in groups) ...[
        Padding(
          padding: const EdgeInsets.only(top: 4, bottom: 6),
          child: Text(
            group.label,
            style: theme.textTheme.labelMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ),
        Wrap(
          spacing: 6,
          runSpacing: 6,
          children: [
            for (final word in group.words)
              FilterChip(
                label: Text(word),
                // Selected means ignored, which is the default for every one
                // of these: the list reads as "what is currently thrown away",
                // and the odd one out is the word a reviewer put back.
                selected: options.builtinIsNoise(word),
                showCheckmark: false,
                onSelected: (isNoise) {
                  options.setBuiltinIsNoise(word, isNoise);
                  _dirty = true;
                },
              ),
          ],
        ),
        const SizedBox(height: 4),
      ],
    ];
  }
}
