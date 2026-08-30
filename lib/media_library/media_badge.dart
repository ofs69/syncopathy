import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:syncopathy/helper/extensions.dart';
import 'package:syncopathy/persistence/entities/media_file.dart';

/// The rendered content of one badge for one media item.
class BadgeValue {
  /// `null` renders the badge icon-only, for markers that flag a state rather
  /// than report a measurement.
  final String? text;
  final String tooltip;

  /// Overrides [BadgeSpec.icon] when the glyph depends on the value — the play
  /// count uses it to distinguish "never watched" from a real count.
  final IconData? icon;

  /// Background fill, so state markers read differently from the neutral stat
  /// pills. Defaults to the shared translucent black.
  final Color? tint;

  const BadgeValue({this.text, required this.tooltip, this.icon, this.tint});
}

/// One entry in [availableBadges]: everything needed to offer a badge in the
/// view-options menu, persist whether it is on, and render it on a card.
///
/// Adding a badge means adding one entry to that list — the persisted setting,
/// the menu item and the card layout are all derived from it, so there is no
/// second site to keep in sync.
class BadgeSpec {
  /// Stable key used in persisted settings. Never rename it; [label] is the
  /// user-visible string and can change freely.
  final String id;
  final String label;
  final IconData icon;

  /// Whether the badge is on for a library that has never toggled it.
  final bool defaultOn;

  /// This badge's content for [media], or `null` to hide it for this item.
  /// Conditional badges return `null` for the common case so they only take up
  /// room when they carry information.
  final BadgeValue? Function(MediaFile media) build;

  /// A representative sample, used to draw this badge in the view-options
  /// picker. The picker shows the real badge rather than its name, and cannot
  /// call [build] — a conditional badge returns null for most media, and the
  /// picker has no media to ask about.
  final BadgeValue preview;

  const BadgeSpec({
    required this.id,
    required this.label,
    required this.icon,
    required this.build,
    required this.preview,
    this.defaultOn = true,
  });
}

/// Badge pill geometry, shared by the card overlay and by the copies drawn
/// onto the thumbnails published to HereSphere. One definition, so a badge
/// looks the same wherever it is rendered.
const double mediaBadgeIconSize = 12.0;
const double mediaBadgeFontSize = 12.0;
const double mediaBadgePadding = 4.0;
const double mediaBadgeRadius = 4.0;
const double mediaBadgeGap = 4.0;
const double mediaBadgeSpacing = 2.0;

/// The typeface a badge's value is set in.
TextStyle mediaBadgeTextStyle({
  required Color color,
  double fontSize = mediaBadgeFontSize,
}) => GoogleFonts.robotoMono(
  color: color,
  fontSize: fontSize,
  fontWeight: FontWeight.bold,
);

/// One rendered badge pill.
///
/// Icon-only and text badges must come out the same height, so the text is laid
/// out unconditionally — empty when there is none. Its line box, not the 12px
/// icon, is what sets the pill height; sizing an icon-only badge from the icon
/// alone leaves it a few pixels shorter than the badges beside it.
class MediaBadgeChip extends StatelessWidget {
  final BadgeSpec spec;
  final BadgeValue value;
  final Color foreground;

  /// Replaces [BadgeValue.tooltip]. The picker uses it to describe what
  /// clicking the chip does, rather than what the metric means.
  final String? tooltip;

  const MediaBadgeChip({
    super.key,
    required this.spec,
    required this.value,
    required this.foreground,
    this.tooltip,
  });

  static const double _iconSize = mediaBadgeIconSize;
  static const double _fontSize = mediaBadgeFontSize;

  @override
  Widget build(BuildContext context) {
    final text = value.text;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 4.0),
      decoration: BoxDecoration(
        color: value.tint ?? Colors.black54,
        borderRadius: BorderRadius.circular(4.0),
      ),
      child: Tooltip(
        message: tooltip ?? value.tooltip,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(value.icon ?? spec.icon, color: foreground, size: _iconSize),
            if (text != null) const SizedBox(width: 4.0),
            // Flexible so a pill too wide for the card ellipsizes its value
            // rather than overflowing: on a very narrow card the icon still
            // identifies the badge. Requires a bounded parent, which the
            // wrapping overlay always provides.
            Flexible(
              child: Text(
                text ?? '',
                maxLines: 1,
                softWrap: false,
                overflow: TextOverflow.ellipsis,
                style: mediaBadgeTextStyle(
                  color: foreground,
                  fontSize: _fontSize,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// The badge cluster drawn over a media card's thumbnail.
///
/// Each spec decides whether it applies to [media], so a conditional badge
/// (script count, AI marker) returns null and costs no space — there are no
/// per-badge visibility conditions to keep in sync here. Badges flow right to
/// left and wrap onto further rows when the card is too narrow to fit them all,
/// so enabling another badge degrades into a second row instead of overflowing.
class MediaBadgeOverlay extends StatelessWidget {
  final List<BadgeSpec> badges;
  final MediaFile media;
  final Color foreground;

  const MediaBadgeOverlay({
    super.key,
    required this.badges,
    required this.media,
    required this.foreground,
  });

  @override
  Widget build(BuildContext context) {
    final resolved = <(BadgeSpec, BadgeValue)>[
      for (final spec in badges)
        if (spec.build(media) case final value?) (spec, value),
    ];
    if (resolved.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Align(
        alignment: AlignmentGeometry.topRight,
        child: Wrap(
          alignment: WrapAlignment.end,
          spacing: 2.0,
          runSpacing: 2.0,
          children: [
            for (final (spec, value) in resolved)
              MediaBadgeChip(spec: spec, value: value, foreground: foreground),
          ],
        ),
      ),
    );
  }
}

/// Play counts above this render as "999+", so a much-watched item can't widen
/// its badge enough to push the others off a narrow card.
const int _playCountCap = 999;

/// Distinct fill for provenance markers, so they don't read as another stat.
final Color _aiBadgeTint = Colors.deepPurple.shade400.withAlphaF(0.75);

String _formatDuration(double? duration) {
  if (duration == null) return '--:--';
  final minutes = (duration ~/ 60).toString().padLeft(2, '0');
  final seconds = (duration % 60).toInt().toString().padLeft(2, '0');
  return '$minutes:$seconds';
}

/// Every badge a card can show, in the order they are rendered and listed in
/// the view-options menu. Position in this list *is* the sort order.
final List<BadgeSpec> availableBadges = [
  BadgeSpec(
    id: 'playCount',
    label: 'Play Count',
    icon: Icons.play_arrow,
    build: (media) {
      final count = media.playCount;
      if (count <= 0) {
        return const BadgeValue(
          icon: Icons.visibility_off,
          tooltip: 'Not watched yet',
        );
      }
      return BadgeValue(
        text: count > _playCountCap ? '$_playCountCap+' : '$count',
        tooltip: 'Watched $count times',
      );
    },
    preview: const BadgeValue(text: '12', tooltip: 'Play Count'),
  ),
  BadgeSpec(
    id: 'duration',
    label: 'Duration',
    icon: Icons.timer,
    build: (media) => BadgeValue(
      text: _formatDuration(media.metadata.target?.duration),
      tooltip: 'Duration',
    ),
    preview: const BadgeValue(text: '12:34', tooltip: 'Duration'),
  ),
  BadgeSpec(
    id: 'averageSpeed',
    label: 'Average Speed',
    icon: Icons.speed,
    build: (media) {
      final funscript = media.mainFunscript.target;
      if (funscript == null) return null;
      return BadgeValue(
        text: '${funscript.averageSpeed.round()}',
        tooltip: 'Average Speed',
      );
    },
    preview: const BadgeValue(text: '240', tooltip: 'Average Speed'),
  ),
  BadgeSpec(
    id: 'averageMinMax',
    label: 'Average Min/Max',
    icon: Icons.stacked_line_chart,
    build: (media) {
      final funscript = media.mainFunscript.target;
      if (funscript == null) return null;
      return BadgeValue(
        text: '${funscript.averageMin.round()}-${funscript.averageMax.round()}',
        tooltip: 'Average Min / Max',
      );
    },
    preview: const BadgeValue(text: '10-90', tooltip: 'Average Min / Max'),
  ),
  BadgeSpec(
    id: 'funscriptCount',
    label: 'Script Count',
    icon: Icons.layers,
    build: (media) {
      final count = media.funscripts.length;
      // A single script is the norm and says nothing; the badge exists to point
      // out that alternates are available in the player's script dropdown.
      if (count <= 1) return null;
      final main = media.mainFunscript.target;
      return BadgeValue(
        text: '$count',
        tooltip: main == null
            ? '$count funscripts'
            : '$count funscripts · main: ${main.fileName}',
      );
    },
    preview: const BadgeValue(text: '3', tooltip: 'Script Count'),
  ),
  BadgeSpec(
    id: 'aiGenerated',
    label: 'AI Generated',
    icon: Icons.auto_awesome,
    build: (media) {
      final main = media.mainFunscript.target;
      if (main == null || !main.isAiGenerated) return null;
      final alternates = media.funscripts
          .where((fs) => fs.id != main.id)
          .length;
      return BadgeValue(
        tooltip: alternates == 0
            ? 'AI-generated script'
            : 'Main script is AI-generated · $alternates '
                  'alternate${alternates == 1 ? '' : 's'}',
        tint: _aiBadgeTint,
      );
    },
    preview: BadgeValue(tooltip: 'AI Generated', tint: _aiBadgeTint),
  ),
];

/// Badge lookup by persisted id.
final Map<String, BadgeSpec> badgesById = {
  for (final spec in availableBadges) spec.id: spec,
};

/// The ids enabled for a library that has never touched the setting.
List<String> get defaultBadgeIds =>
    availableBadges.where((spec) => spec.defaultOn).map((s) => s.id).toList();

/// The specs for [enabledIds], in registry order.
///
/// Ids with no matching spec are dropped rather than throwing, so a badge
/// removed in a later version degrades the same way an unknown visibility
/// filter does instead of breaking the whole settings load.
List<BadgeSpec> resolveBadges(Iterable<String> enabledIds) {
  final enabled = enabledIds.toSet();
  return availableBadges.where((spec) => enabled.contains(spec.id)).toList();
}
