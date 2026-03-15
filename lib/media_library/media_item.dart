import 'package:flutter/material.dart';
import 'package:syncopathy/media_library/media_thumbnail.dart';
import 'package:syncopathy/persistence/entities/media_file.dart';

class MediaItem extends StatefulWidget {
  final MediaFile media;
  final bool isSelected;
  final bool showAverageMinMax;
  final bool showAverageSpeed;
  final bool showDuration;
  final bool showPlayCount;
  final bool showTitle;

  const MediaItem({
    super.key,
    required this.isSelected,
    required this.media,
    required this.showAverageMinMax,
    required this.showAverageSpeed,
    required this.showDuration,
    required this.showPlayCount,
    required this.showTitle,
  });

  @override
  State<MediaItem> createState() => _MediaItemState();
}

class _MediaItemState extends State<MediaItem> {
  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        side: BorderSide(color: Theme.of(context).colorScheme.primary),
        borderRadius: BorderRadiusGeometry.circular(8.0),
      ),
      child: Stack(
        fit: StackFit.expand,

        children: [
          MediaThumbnail(media: widget.media),
          if (widget.isSelected)
            Container(
              color: Theme.of(context).primaryColor.withAlpha(130),
              child: Icon(Icons.check_circle, color: Colors.white),
            ),

          AnimatedOpacity(
            opacity: widget.showTitle ? 1.0 : 0.0, //|| _isHovering ? 1.0 : 0.0,
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
                    ).textTheme.titleSmall?.copyWith(color: Colors.white),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
