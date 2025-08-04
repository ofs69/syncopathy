import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:syncopathy/main.dart';
import 'package:syncopathy/model/user_category.dart';
import 'package:syncopathy/model/video_model.dart';
import 'package:syncopathy/video_thumbnail.dart';

class VideoItem extends StatefulWidget {
  const VideoItem({
    super.key,
    required this.video,
    required this.onVideoTapped,
    required this.onFavoriteChanged,
    required this.onDislikeChanged,
    required this.onCategoryChanged,
  });

  final Video video;
  final void Function(Video) onVideoTapped;
  final void Function(Video) onFavoriteChanged;
  final void Function(Video) onDislikeChanged;
  final void Function(Video, UserCategory, bool) onCategoryChanged;

  @override
  State<VideoItem> createState() => _VideoItemState();
}

class _VideoItemState extends State<VideoItem> {
  bool _isHovering = false;
  bool _isTapped = false;

  String _formatDuration(double? duration) {
    if (duration == null) return '--:--';
    final minutes = (duration ~/ 60).toString().padLeft(2, '0');
    final seconds = (duration % 60).toInt().toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  void _showContextMenu(BuildContext context, TapUpDetails details) async {
    final categories = await isar.userCategorys.where().findAll();
    if (!context.mounted) return;

    if (categories.isEmpty) {
      return;
    }

    final result = await showMenu<UserCategory>(
      context: context,
      position: RelativeRect.fromLTRB(
        details.globalPosition.dx,
        details.globalPosition.dy,
        details.globalPosition.dx,
        details.globalPosition.dy,
      ),
      items: categories.map((category) {
        return PopupMenuItem<UserCategory>(
          value: category,
          child: widget.video.categories.any((c) => c.id == category.id)
              ? Text("Remove: ${category.name}")
              : Text(category.name),
        );
      }).toList(),
    );

    if (result != null) {
      bool removeCategory = widget.video.categories.any(
        (c) => c.id == result.id,
      );
      widget.onCategoryChanged(widget.video, result, removeCategory);
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Scale icon size and padding based on the item's height.
        final double iconSize = (constraints.maxHeight / 7).clamp(16.0, 32.0);
        final double padding = (iconSize / 4).clamp(4.0, 16.0);

        final BorderSide borderSide;
        if (widget.video.isFavorite) {
          borderSide = BorderSide(color: Colors.yellow.shade600, width: 3.0);
        } else if (widget.video.isDislike) {
          borderSide = BorderSide(color: Colors.blue.shade300, width: 3.0);
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
            onSecondaryTapUp: (details) => _showContextMenu(context, details),
            child: AnimatedScale(
              scale: _isTapped ? 0.95 : (_isHovering ? 1.03 : 1.0),
              duration: const Duration(milliseconds: 150),
              curve: Curves.easeOut,
              child: Card(
                clipBehavior: Clip.antiAlias,
                elevation: 2.0,
                shape: RoundedRectangleBorder(
                  side: borderSide,
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    VideoThumbnail(video: widget.video),
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
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
                    Positioned(
                      top: 8.0,
                      right: 8.0,
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8.0,
                              vertical: 4.0,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.black54,
                              borderRadius: BorderRadius.circular(4.0),
                            ),
                            child: Tooltip(
                              message: "Duration",
                              child: Text(
                                _formatDuration(widget.video.duration),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 4.0),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8.0,
                              vertical: 4.0,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.black54,
                              borderRadius: BorderRadius.circular(4.0),
                            ),
                            child: Tooltip(
                              message: "Average Speed",
                              child: Text(
                                '${widget.video.averageSpeed.round()}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 4.0),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8.0,
                              vertical: 4.0,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.black54,
                              borderRadius: BorderRadius.circular(4.0),
                            ),
                            child: Tooltip(
                              message: "Average Min / Max",
                              child: Text(
                                '${widget.video.averageMin.round()}-${widget.video.averageMax.round()}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      top: 0,
                      left: 0,
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
                            color: Colors.yellow.shade600,
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
                                  Shadow(blurRadius: 3, color: Colors.black87),
                                ],
                              ),
                              color: Colors.blue.shade300,
                              iconSize: iconSize,
                            ),
                        ],
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
    if (video.funscriptMetadata?.tags.isNotEmpty ?? false) {
      return "${video.title}\n${video.funscriptMetadata!.tags.join(', ')}";
    }
    return video.title;
  }
}
