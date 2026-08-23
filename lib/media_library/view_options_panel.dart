import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:signals/signals_flutter.dart';
import 'package:syncopathy/media_library/filter/media_filter_logic.dart';
import 'package:syncopathy/media_library/media_badge.dart';
import 'package:syncopathy/model/media_library_settings_model.dart';

/// Bounds for the grid density stepper, matching what the grid delegate can
/// lay out sensibly.
const int _minPerRow = 2;
const int _maxPerRow = 10;

/// The contents of the toolbar's view-options popover.
///
/// Grouped under headings by what each control affects — the grid, a card, and
/// the library as a whole — because the three used to sit in one flat list
/// separated only by unlabelled dividers.
class ViewOptionsPanel extends StatelessWidget {
  const ViewOptionsPanel({super.key});

  static const double _width = 300.0;

  @override
  Widget build(BuildContext context) {
    final settings = context.read<MediaLibrarySettingsModel>();
    // Every signal is read here, inside the one SignalBuilder, and threaded
    // down as plain values. A read inside a child widget's own build would
    // belong to that element instead and would not rebuild this panel.
    return SignalBuilder(
      builder: (context) {
        final perRow = settings.videosPerRow.value;
        final showTitles = settings.showVideoTitles.value;
        final enabledBadges = settings.enabledBadges.value;
        final visibility = settings.visibilityFilters.value;
        final separateFavorites = settings.separateFavorites.value;
        final isCustomized = settings.isViewCustomized.value;
        return SizedBox(
          width: _width,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 8, 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _Header(
                  isCustomized: isCustomized,
                  onReset: settings.resetViewOptions,
                ),
                const _SectionLabel('Grid'),
                _DensityStepper(
                  perRow: perRow,
                  onChanged: (value) => settings.videosPerRow.value = value,
                ),
                _Toggle(
                  label: 'Show titles',
                  value: showTitles,
                  onTap: () => settings.showVideoTitles.value = !showTitles,
                ),
                const _SectionLabel('Card badges'),
                _BadgePicker(
                  enabled: enabledBadges,
                  onToggle: (id) {
                    final next = enabledBadges.toList();
                    if (!next.remove(id)) next.add(id);
                    settings.enabledBadges.value = next;
                  },
                ),
                const _SectionLabel('Library'),
                ...VideoFilter.values.map(
                  (filter) => _Toggle(
                    label: filter.label,
                    value: visibility.contains(filter),
                    onTap: () {
                      final next = visibility.toSet();
                      if (!next.remove(filter)) next.add(filter);
                      settings.visibilityFilters.value = next;
                    },
                  ),
                ),
                _Toggle(
                  label: 'Separate favorites/dislikes',
                  value: separateFavorites,
                  onTap: () =>
                      settings.separateFavorites.value = !separateFavorites,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

/// Title row, with the reset affordance enabled only when there is something to
/// reset — so it doubles as an indicator that the view has been customized.
class _Header extends StatelessWidget {
  final bool isCustomized;
  final VoidCallback onReset;
  const _Header({required this.isCustomized, required this.onReset});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            'View options',
            style: Theme.of(context).textTheme.titleSmall,
          ),
        ),
        TextButton.icon(
          onPressed: isCustomized ? onReset : null,
          icon: const Icon(Icons.restart_alt, size: 16),
          label: const Text('Reset'),
          style: TextButton.styleFrom(
            visualDensity: VisualDensity.compact,
            textStyle: Theme.of(context).textTheme.labelMedium,
          ),
        ),
      ],
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String label;
  const _SectionLabel(this.label);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 12.0, bottom: 4.0),
      child: Text(
        label.toUpperCase(),
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          color: Theme.of(context).colorScheme.primary,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.8,
        ),
      ),
    );
  }
}

/// Grid density as a stepper rather than a submenu of nine entries: it is the
/// most-adjusted view option, and stepping one row at a time is how it is
/// actually used.
class _DensityStepper extends StatelessWidget {
  final int perRow;
  final ValueChanged<int> onChanged;
  const _DensityStepper({required this.perRow, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(child: Text('Items per row')),
        IconButton(
          icon: const Icon(Icons.remove),
          iconSize: 18,
          visualDensity: VisualDensity.compact,
          tooltip: 'Fewer per row',
          onPressed: perRow > _minPerRow ? () => onChanged(perRow - 1) : null,
        ),
        SizedBox(
          width: 24,
          child: Text(
            '$perRow',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleSmall,
          ),
        ),
        IconButton(
          icon: const Icon(Icons.add),
          iconSize: 18,
          visualDensity: VisualDensity.compact,
          tooltip: 'More per row',
          onPressed: perRow < _maxPerRow ? () => onChanged(perRow + 1) : null,
        ),
      ],
    );
  }
}

/// The badges as themselves, dimmed when off, rather than a row of "Show ___"
/// checkboxes. One line instead of one row per badge, and it shows what each
/// badge actually looks like on a card.
class _BadgePicker extends StatelessWidget {
  final List<String> enabled;
  final ValueChanged<String> onToggle;
  const _BadgePicker({required this.enabled, required this.onToggle});

  @override
  Widget build(BuildContext context) {
    final onSurface = Theme.of(context).colorScheme.onSurface;
    return Wrap(
      spacing: 6.0,
      runSpacing: 6.0,
      children: [
        for (final spec in availableBadges)
          _BadgeToggle(
            spec: spec,
            isOn: enabled.contains(spec.id),
            foreground: onSurface,
            onTap: () => onToggle(spec.id),
          ),
      ],
    );
  }
}

class _BadgeToggle extends StatelessWidget {
  final BadgeSpec spec;
  final bool isOn;
  final Color foreground;
  final VoidCallback onTap;

  const _BadgeToggle({
    required this.spec,
    required this.isOn,
    required this.foreground,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(4.0),
      child: Opacity(
        opacity: isOn ? 1.0 : 0.35,
        child: MediaBadgeChip(
          spec: spec,
          value: spec.preview,
          foreground: foreground,
          tooltip: '${isOn ? 'Hide' : 'Show'} ${spec.label}',
        ),
      ),
    );
  }
}

class _Toggle extends StatelessWidget {
  final String label;
  final bool value;
  final VoidCallback onTap;

  const _Toggle({
    required this.label,
    required this.value,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(4.0),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        child: Row(
          children: [
            Icon(
              value ? Icons.check_box : Icons.check_box_outline_blank,
              size: 20,
              color: value ? scheme.primary : scheme.onSurfaceVariant,
            ),
            const SizedBox(width: 8),
            Expanded(child: Text(label)),
          ],
        ),
      ),
    );
  }
}
