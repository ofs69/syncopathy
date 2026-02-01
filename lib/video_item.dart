import 'package:flutter/material.dart';
import 'package:syncopathy/helper/constants.dart';
import 'package:syncopathy/sqlite/models/user_category.dart';
import 'package:syncopathy/sqlite/models/video_model.dart';
import 'package:syncopathy/video_thumbnail.dart';
import 'package:syncopathy/helper/platform_utils.dart';
import 'package:provider/provider.dart';
import 'package:syncopathy/model/player_model.dart';

class VideoItem extends StatefulWidget {
  const VideoItem({
    super.key,
    required this.video,
    required this.onVideoTapped,
    required this.onFavoriteChanged,
    required this.onDislikeChanged,
    required this.onCategoryChanged,
    required this.onDelete,
    required this.showAverageSpeed,
    required this.showAverageMinMax,
    required this.showDuration,
    required this.showPlayCount,
    required this.showTitle,
    required this.isSelected,
    this.onLongPress,
  });

  final Video video;
  final void Function(Video) onVideoTapped;
  final void Function(Video) onFavoriteChanged;
  final void Function(Video) onDislikeChanged;
  final void Function(Video, UserCategory, bool) onCategoryChanged;
  final void Function(Video) onDelete;
  final bool showTitle;
  final bool isSelected;
  final VoidCallback? onLongPress;
  final bool showAverageSpeed;
  final bool showAverageMinMax;
  final bool showDuration;
  final bool showPlayCount;

  @override
  State<VideoItem> createState() => _VideoItemState();
}

class _VideoItemState extends State<VideoItem> {
  final GlobalKey<VideoThumbnailState> _thumbnailKey = GlobalKey();
  bool _isHovering = false;
  bool _isTapped = false;

  String _formatDuration(double? duration) {
    if (duration == null) return '--:--';
    final minutes = (duration ~/ 60).toString().padLeft(2, '0');
    final seconds = (duration % 60).toInt().toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  void _openFileDirectory(String path) async {
    await PlatformUtils.openFileExplorer(path);
  }

  void _showDeleteConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Deletion'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                const Text(
                  'Are you sure you want to delete the following files?',
                ),
                const SizedBox(height: 16),
                Text('Video: ${widget.video.videoPath}'),
                if (widget.video.funscriptPath.isNotEmpty)
                  Text('Script: ${widget.video.funscriptPath}'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Delete', style: TextStyle(color: Colors.red)),
              onPressed: () {
                Navigator.of(context).pop();
                widget.onDelete(widget.video);
              },
            ),
          ],
        );
      },
    );
  }

  void _showContextMenu(BuildContext context, TapUpDetails details) async {
    final List<PopupMenuEntry<String>> menuItems = [
      const PopupMenuItem<String>(
        value: 'regenerate_thumbnail',
        child: Text('Regenerate Thumbnail'),
      ),
      const PopupMenuItem<String>(
        value: 'open_video_dir',
        child: Text('Open video file directory'),
      ),
    ];

    if (widget.video.funscriptPath.isNotEmpty) {
      menuItems.add(
        const PopupMenuItem<String>(
          value: 'open_script_dir',
          child: Text('Open script file directory'),
        ),
      );
    }

    menuItems.add(const PopupMenuDivider());
    menuItems.add(
      const PopupMenuItem<String>(
        value: 'delete',
        child: Text(
          'Delete Script & Video',
          style: TextStyle(color: Colors.red),
        ),
      ),
    );

    final result = await showMenu<String>(
      context: context,
      position: RelativeRect.fromLTRB(
        details.globalPosition.dx,
        details.globalPosition.dy,
        details.globalPosition.dx,
        details.globalPosition.dy,
      ),
      items: menuItems,
    );

    if (result != null) {
      if (result == 'regenerate_thumbnail') {
        _thumbnailKey.currentState?.regenerateThumbnail();
      } else if (result == 'open_video_dir') {
        _openFileDirectory(widget.video.videoPath);
      } else if (result == 'open_script_dir') {
        _openFileDirectory(widget.video.funscriptPath);
      } else if (result == 'delete') {
        _showDeleteConfirmationDialog();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Scale icon size and padding based on the item's height.
        final double iconSize = (constraints.maxHeight / 7).clamp(16.0, 32.0);
        final double padding = (iconSize / 4).clamp(4.0, 16.0);

        final currentVideoId = context.select<PlayerModel, int?>(
          (p) => p.currentVideo.value?.id,
        );

        final BorderSide borderSide;
        if (widget.video.id == currentVideoId) {
          borderSide = BorderSide(color: Colors.green, width: 6.0);
        } else if (widget.video.isFavorite) {
          borderSide = BorderSide(color: favoriteColor, width: 3.0);
        } else if (widget.video.isDislike) {
          borderSide = BorderSide(color: dislikeColor, width: 3.0);
        } else {
          borderSide = BorderSide.none;
        }

        return MouseRegion(
          onEnter: (_) => setState(() => _isHovering = true),
          onExit: (_) => setState(() => _isHovering = false),
          child: GestureDetector(
            onTapDown: (_) => setState(() => _isTapped = true),
            onTapUp: (_) => setState(() => _isTapped = false),
            onTapCancel: () => setState(() => _isTapped = false),
            onTap: () => widget.onVideoTapped(widget.video),
            onLongPress: widget.onLongPress,
            onSecondaryTapUp: (details) => _showContextMenu(context, details),
            child: AnimatedScale(
              scale: _isTapped ? 0.95 : (_isHovering ? 1.03 : 1.0),
              duration: const Duration(milliseconds: 150),
              curve: Curves.easeOut,
              child: Card(
                clipBehavior: Clip.antiAlias,
                elevation: 2.0,
                shape: RoundedRectangleBorder(
                  side: widget.isSelected
                      ? BorderSide(
                          color: Theme.of(context).primaryColor,
                          width: 3.0,
                        )
                      : borderSide,
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    VideoThumbnail(key: _thumbnailKey, video: widget.video),
                    if (widget.isSelected)
                      Container(
                        color: Theme.of(context).primaryColor.withAlpha(130),
                        child: Icon(
                          Icons.check_circle,
                          color: Colors.white,
                          size: iconSize,
                        ),
                      ),
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: AnimatedOpacity(
                        opacity: widget.showTitle || _isHovering ? 1.0 : 0.0,
                        duration: const Duration(milliseconds: 200),
                        child: Container(
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [Colors.transparent, Colors.black],
                            ),
                          ),
                          padding: const EdgeInsets.all(8.0),
                          child: Tooltip(
                            message: getVideoTooltip(widget.video),
                            child: Text(
                              widget.video.title,
                              style: Theme.of(context).textTheme.titleSmall
                                  ?.copyWith(color: Colors.white),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 8.0,
                      right: 8.0,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          if (widget.showDuration)
                            _buildStatisticItem(
                              icon: Icons.timer,
                              text: _formatDuration(widget.video.duration),
                              tooltipMessage: "Duration",
                            ),
                          if (widget.showDuration) const SizedBox(height: 4.0),
                          if (widget.showAverageSpeed)
                            _buildStatisticItem(
                              icon: Icons.speed,
                              text: '${widget.video.averageSpeed.round()}',
                              tooltipMessage: "Average Speed",
                            ),
                          if (widget.showAverageSpeed)
                            const SizedBox(height: 4.0),
                          if (widget.showAverageMinMax)
                            _buildStatisticItem(
                              icon: Icons.stacked_line_chart,
                              text:
                                  '${widget.video.averageMin.round()}-${widget.video.averageMax.round()}',
                              tooltipMessage: "Average Min / Max",
                            ),
                          if (widget.showPlayCount) const SizedBox(height: 4.0),
                          // Play count indicator
                          if (widget.showPlayCount)
                            _buildStatisticItem(
                              icon: widget.video.playCount > 0
                                  ? Icons.play_arrow
                                  : Icons.visibility_off,
                              text: widget.video.playCount > 0
                                  ? widget.video.playCount > 999
                                        ? '999+'
                                        : '${widget.video.playCount}'
                                  : null,
                              tooltipMessage: widget.video.playCount > 0
                                  ? 'Watched ${widget.video.playCount} times'
                                  : 'Not watched yet',
                              color: Colors.black54,
                            ),
                        ],
                      ),
                    ),
                    Positioned(
                      top: 0,
                      left: 0,
                      child: AnimatedOpacity(
                        opacity:
                            _isHovering ||
                                widget.video.isFavorite ||
                                widget.video.isDislike
                            ? 1.0
                            : 0.0,
                        duration: const Duration(milliseconds: 200),
                        child: Column(
                          children: [
                            IconButton(
                              padding: EdgeInsets.all(padding),
                              constraints: const BoxConstraints(),
                              onPressed: () {
                                setState(() {
                                  widget.video.isFavorite =
                                      !widget.video.isFavorite;
                                  // If we just favorited it, it can't be disliked.
                                  if (widget.video.isFavorite) {
                                    widget.video.isDislike = false;
                                  }
                                });
                                widget.onFavoriteChanged(widget.video);
                              },
                              icon: Icon(
                                widget.video.isFavorite
                                    ? Icons.star
                                    : Icons.star_border,
                                shadows: const [
                                  Shadow(blurRadius: 3, color: Colors.black87),
                                ],
                              ),
                              color: favoriteColor,
                              iconSize: iconSize,
                            ),
                            if (!widget.video.isFavorite)
                              IconButton(
                                padding: EdgeInsets.all(padding),
                                constraints: const BoxConstraints(),
                                onPressed: () {
                                  setState(() {
                                    widget.video.isDislike =
                                        !widget.video.isDislike;
                                  });
                                  widget.onDislikeChanged(widget.video);
                                },
                                icon: Icon(
                                  widget.video.isDislike
                                      ? Icons.thumb_down
                                      : Icons.thumb_down_outlined,
                                  shadows: const [
                                    Shadow(
                                      blurRadius: 3,
                                      color: Colors.black87,
                                    ),
                                  ],
                                ),
                                color: dislikeColor,
                                iconSize: iconSize,
                              ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  String getVideoTooltip(Video video) {
    return video.title;
  }

  Widget _buildStatisticItem({
    required IconData icon,
    required String? text,
    required String tooltipMessage,
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
          children: [
            Icon(icon, color: Colors.white, size: 12),
            if (text != null) const SizedBox(width: 4.0),
            if (text != null)
              Text(
                text,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
