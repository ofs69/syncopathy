import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:signals/signals_flutter.dart';
import 'package:syncopathy/helper/constants.dart';
import 'package:syncopathy/helper/extensions.dart';
import 'package:syncopathy/helper/platform_utils.dart';
import 'package:syncopathy/media_library/media_detail_page.dart';
import 'package:syncopathy/media_library/media_thumbnail.dart';
import 'package:syncopathy/model/player_model.dart';
import 'package:syncopathy/persistence/entities/funscript_file.dart';
import 'package:syncopathy/persistence/entities/media_file.dart';
import 'package:syncopathy/persistence/entities/media_metadata.dart';

class MediaItem extends StatefulWidget {
  final MediaFile media;
  final bool isSelected;
  final bool showAverageMinMax;
  final bool showAverageSpeed;
  final bool showDuration;
  final bool showPlayCount;
  final bool showTitle;
  final Function() onLongPress;
  final Function() onTap;
  final Function() toggleFavorite;
  final Function() toggleDislike;
  final Function() onDelete;

  const MediaItem({
    super.key,
    required this.isSelected,
    required this.media,
    required this.showAverageMinMax,
    required this.showAverageSpeed,
    required this.showDuration,
    required this.showPlayCount,
    required this.showTitle,
    required this.onLongPress,
    required this.onTap,
    required this.toggleFavorite,
    required this.toggleDislike,
    required this.onDelete,
  });

  @override
  State<MediaItem> createState() => _MediaItemState();
}

class _MediaItemState extends State<MediaItem> with SignalsMixin {
  late final Signal<bool> _isHovering = createSignal(false);
  late final Signal<bool> _isTapped = createSignal(false);
  final MediaThumbnailController _thumbnailController =
      MediaThumbnailController();

  late final PlayerModel _playerModel = context.read<PlayerModel>();
  // Whether this card's media is the one currently open. Watching this per-card
  // computed instead of `currentlyOpen` directly means opening/closing a video
  // only rebuilds the two affected cards, not every visible card.
  late final ReadonlySignal<bool> _isCurrentlyOpen = createComputed(
    () => _playerModel.currentlyOpen.value?.media.id == widget.media.id,
  );

  @override
  void dispose() {
    _thumbnailController.dispose();
    super.dispose();
  }

  // Thumbnail scale on hover, and play-count display cap.
  static const double _hoverScale = 1.10;
  static const int _playCountCap = 999;
  // Action-button icon/padding as a fraction of card width.
  static const double _actionIconScale = 0.07;
  static const double _actionPaddingScale = 0.03;

  /// Border reflecting selection / currently-open / rating state, most
  /// specific first.
  BorderSide _borderSideFor(BuildContext context, bool isCurrentlyOpen) {
    final scheme = Theme.of(context).colorScheme;
    return switch ((widget.media.rating, widget.isSelected, isCurrentlyOpen)) {
      (_, true, _) => BorderSide(
        color: scheme.primary,
        width: 3.0,
        strokeAlign: 1,
      ),
      (_, _, true) => const BorderSide(
        color: Colors.green,
        width: 5.0,
        strokeAlign: 1,
      ),
      (MediaRating.noRating, _, _) || (null, _, _) => BorderSide(
        color: scheme.onSecondary,
        width: 2.0,
        strokeAlign: 1,
      ),
      (MediaRating.like, _, _) => BorderSide(
        color: favoriteColor,
        width: 3.0,
        strokeAlign: 1,
      ),
      (MediaRating.dislike, _, _) => BorderSide(
        color: dislikeColor,
        width: 3.0,
        strokeAlign: 1,
      ),
    };
  }

  String _formatDuration(double? duration) {
    if (duration == null) return '--:--';
    final minutes = (duration ~/ 60).toString().padLeft(2, '0');
    final seconds = (duration % 60).toInt().toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  Widget _buildStatisticItem({
    required IconData icon,
    required String? text,
    required String tooltipMessage,
    required Color onSurface,
    Color color = Colors.black54, // Default to black54 for consistency
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 4.0),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(4.0),
      ),
      child: Tooltip(
        message: tooltipMessage,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(icon, color: onSurface, size: 12),
            if (text != null) const SizedBox(width: 4.0),
            if (text != null)
              Text(
                text,
                style: GoogleFonts.robotoMono(
                  color: onSurface,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final metadata = widget.media.metadata.target;
    final isTapped = _isTapped.watch(context);
    final isHovering = _isHovering.watch(context);
    return MouseRegion(
      onEnter: (_) => _isHovering.value = true,
      onExit: (_) => _isHovering.value = false,
      child: LayoutBuilder(
        builder: (context, constraints) =>
            _buildCard(context, constraints, isHovering, isTapped, metadata),
      ),
    );
  }

  Card _buildCard(
    BuildContext context,
    BoxConstraints constraints,
    bool isHovering,
    bool isTapped,
    MediaMetadata? metadata,
  ) {
    final hasRating = widget.media.rating != MediaRating.noRating;
    final isFavorite = widget.media.isFavorite;
    final isDislike = widget.media.isDislike;
    final isCurrentlyOpen = _isCurrentlyOpen.watch(context);
    final mainFunscript = widget.media.mainFunscript.target;

    final onSurface = Theme.of(context).colorScheme.onSurface;

    final borderSide = _borderSideFor(context, isCurrentlyOpen);

    return Card(
      clipBehavior: Clip.none,
      shape: RoundedRectangleBorder(
        side: borderSide,
        borderRadius: BorderRadiusGeometry.circular(4.0),
      ),
      child: Stack(
        fit: StackFit.expand,

        children: [
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTapDown: (_) => _isTapped.value = true,
            onTapUp: (_) => _isTapped.value = false,
            onLongPress: () {
              _isTapped.value = false;
              widget.onLongPress();
            },
            onTap: widget.onTap,
            onSecondaryTapUp: _showContextMenu,
            child: Stack(
              fit: StackFit.expand,
              children: [
                ClipRRect(
                  borderRadius: BorderRadiusGeometry.circular(4.0),
                  clipBehavior: Clip.hardEdge,
                  child: AnimatedScale(
                    scale: isTapped ? 1.0 : (isHovering ? _hoverScale : 1.00),
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.easeOut,
                    child: MediaThumbnail(
                      media: widget.media,
                      controller: _thumbnailController,
                    ),
                  ),
                ),
                if (widget.isSelected)
                  Container(
                    color: Theme.of(context).primaryColor.withAlphaF(0.5),
                    child: Icon(
                      Icons.check_circle,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                if (widget.media.fileNotFound ||
                    (mainFunscript?.fileNotFound ?? false))
                  _buildStatusOverlay(
                    icon: Icons.file_open_outlined,
                    badgeColor: Colors.red,
                    label: "FILE NOT FOUND",
                  )
                else if (mainFunscript == null)
                  _buildStatusOverlay(
                    icon: Icons.description_outlined,
                    badgeColor: Colors.orange,
                    label: "NO SCRIPT",
                  )
                else if (mainFunscript.isScriptToken)
                  _buildStatusOverlay(
                    icon: Icons.generating_tokens,
                    badgeColor: Colors.blue,
                    label: "SCRIPT TOKEN",
                  ),
                _buildStatisticsOverlay(metadata, mainFunscript, onSurface),
                _buildTitleGradient(isHovering, onSurface),
              ],
            ),
          ),
          _buildActionColumn(
            context,
            constraints,
            isHovering: isHovering,
            hasRating: hasRating,
            isFavorite: isFavorite,
            isDislike: isDislike,
            onSurface: onSurface,
          ),
        ],
      ),
    );
  }

  /// Top-right column of stat badges (duration, play count, average speed,
  /// average min/max), each gated by its corresponding `show*` flag.
  Widget _buildStatisticsOverlay(
    MediaMetadata? metadata,
    FunscriptFile? mainFunscript,
    Color onSurface,
  ) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Align(
        alignment: AlignmentGeometry.topRight,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (widget.showDuration)
                  _buildStatisticItem(
                    icon: Icons.timer,
                    onSurface: onSurface,
                    text: _formatDuration(metadata?.duration),
                    tooltipMessage: "Duration",
                  ),
                if (widget.showPlayCount)
                  const SizedBox(height: 0.0, width: 2.0),

                // Play count indicator
                if (widget.showPlayCount)
                  _buildStatisticItem(
                    onSurface: onSurface,
                    icon: widget.media.playCount > 0
                        ? Icons.play_arrow
                        : Icons.visibility_off,
                    text: widget.media.playCount > 0
                        ? widget.media.playCount > _playCountCap
                              ? '$_playCountCap+'
                              : '${widget.media.playCount}'
                        : null,
                    tooltipMessage: widget.media.playCount > 0
                        ? 'Watched ${widget.media.playCount} times'
                        : 'Not watched yet',
                    color: Colors.black54,
                  ),
              ],
            ),
            if (widget.showAverageSpeed) const SizedBox(height: 2.0),
            if (widget.showAverageSpeed && mainFunscript != null)
              _buildStatisticItem(
                onSurface: onSurface,
                icon: Icons.speed,
                text: '${mainFunscript.averageSpeed.round()}',
                tooltipMessage: "Average Speed",
              ),
            if (widget.showAverageMinMax)
              const SizedBox(height: 2.0, width: 0.0),
            if (widget.showAverageMinMax && mainFunscript != null)
              _buildStatisticItem(
                onSurface: onSurface,
                icon: Icons.stacked_line_chart,
                text:
                    '${mainFunscript.averageMin.round()}-${mainFunscript.averageMax.round()}',
                tooltipMessage: "Average Min / Max",
              ),
          ],
        ),
      ),
    );
  }

  /// Bottom title bar over a transparent-to-black gradient; fades in on hover
  /// or when titles are pinned on.
  Widget _buildTitleGradient(bool isHovering, Color onSurface) {
    return AnimatedOpacity(
      opacity: widget.showTitle || isHovering ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 200),
      child: Align(
        alignment: AlignmentGeometry.bottomCenter,
        child: Container(
          width: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.transparent, Colors.black],
            ),
          ),
          padding: const EdgeInsets.all(8.0),
          child: Tooltip(
            message: widget.media.name,
            child: Text(
              widget.media.name,
              style: Theme.of(
                context,
              ).textTheme.titleSmall?.copyWith(color: onSurface),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }

  /// Top-left column of hover actions: detail page, favorite, dislike. Fades in
  /// on hover, or stays visible while the card carries a rating.
  Widget _buildActionColumn(
    BuildContext context,
    BoxConstraints constraints, {
    required bool isHovering,
    required bool hasRating,
    required bool isFavorite,
    required bool isDislike,
    required Color onSurface,
  }) {
    return Positioned(
      top: 4,
      left: 4,
      child: AnimatedOpacity(
        opacity: isHovering || hasRating ? 1.0 : 0.0,
        duration: const Duration(milliseconds: 100),
        child: Column(
          children: [
            _buildActionButton(
              constraints: constraints,
              icon: Icons.more_vert,
              color: onSurface,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MediaDetailPage(media: widget.media),
                  ),
                );
              },
            ),
            if (!hasRating) const SizedBox(height: 4),
            if (isFavorite || !hasRating)
              _buildActionButton(
                constraints: constraints,
                icon: isFavorite ? Icons.star : Icons.star_border,
                color: isFavorite ? favoriteColor : onSurface,
                onTap: widget.toggleFavorite,
              ),
            if (!hasRating) const SizedBox(height: 4),
            if (isDislike || !hasRating)
              _buildActionButton(
                constraints: constraints,
                icon: isDislike
                    ? Icons.thumb_down
                    : Icons.thumb_down_outlined,
                color: isDislike ? dislikeColor : onSurface,
                onTap: widget.toggleDislike,
              ),
          ],
        ),
      ),
    );
  }

  /// Full-thumbnail dimmed overlay with a centered icon and a colored badge,
  /// used for the "file not found" / "no script" / "script token" states.
  Widget _buildStatusOverlay({
    required IconData icon,
    required Color badgeColor,
    required String label,
  }) {
    return Container(
      color: Colors.black45,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: Colors.white, size: 32),
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: badgeColor.withAlphaF(0.8),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 10,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
    required BoxConstraints constraints,
  }) {
    // Calculate sizes based on the width of the card
    final double iconSize = constraints.maxWidth * _actionIconScale;
    final double paddingSize = constraints.maxWidth * _actionPaddingScale;

    return IconButton(
      onPressed: onTap,
      icon: Icon(icon),
      iconSize: iconSize.clamp(12.0, 24.0),
      color: color,
      constraints: const BoxConstraints(),
      padding: EdgeInsets.all(paddingSize.clamp(2.0, 8.0)),
      style: IconButton.styleFrom(
        backgroundColor: Colors.black45,
        shape: const CircleBorder(),
        side: const BorderSide(color: Colors.white10, width: 1.0),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
    );
  }

  List<PopupMenuEntry<dynamic>> _buildMenuItems(BuildContext context) {
    final playerModel = context.read<PlayerModel>();
    final isCurrentlyOpen =
        playerModel.currentlyOpen.value?.media.id == widget.media.id;

    return [
      PopupMenuItem(
        onTap: () => _thumbnailController.regenerateThumbnail(),
        child: const Text('Regenerate Thumbnail'),
      ),
      if (isCurrentlyOpen)
        PopupMenuItem(
          onTap: () => _thumbnailController.currentFrameAsThumbnail(),
          child: const Text('Current frame as thumbnail'),
        ),
      PopupMenuItem(
        onTap: () async {
          await PlatformUtils.openFileExplorer(widget.media.mediaPath);
        },
        child: const Text('Open media file directory'),
      ),
      const PopupMenuDivider(height: 1, thickness: 1),
      PopupMenuItem(
        onTap: widget.onDelete,
        child: const Text(
          'Remove from Library',
          style: TextStyle(color: Colors.red),
        ),
      ),
    ];
  }

  void _showContextMenu(TapUpDetails details) async {
    final RenderBox overlay =
        Overlay.of(context).context.findRenderObject() as RenderBox;

    final RelativeRect position = RelativeRect.fromRect(
      Rect.fromLTWH(details.globalPosition.dx, details.globalPosition.dy, 0, 0),
      overlay.localToGlobal(Offset.zero) & overlay.size,
    );

    await showMenu(
      context: context,
      position: position,
      menuPadding: EdgeInsets.zero,
      items: _buildMenuItems(context),
      elevation: 8.0,
    );
  }
}
