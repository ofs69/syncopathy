import 'package:flutter/material.dart';
import 'package:syncopathy/media_library/media_thumbnail.dart';
import 'package:syncopathy/persistence/entities/media_file.dart';
import 'package:syncopathy/persistence/media_file_extension.dart';

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

  @override
  Widget build(BuildContext context) {
    final metadata = widget.media.retrieveMetadata();

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
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: Align(
              alignment: AlignmentGeometry.topRight,
              child: Column(
                children: [
                  if (widget.showDuration)
                    FutureBuilder(
                      future: metadata,
                      builder: (context, metadata) {
                        return _buildStatisticItem(
                          icon: Icons.timer,
                          text: _formatDuration(metadata.data?.duration),
                          tooltipMessage: "Duration",
                        );
                      },
                    ),
                ],
              ),
            ),
          ),
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
