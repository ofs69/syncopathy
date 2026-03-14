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
      child: Stack(children: [MediaThumbnail(media: widget.media)]),
    );
  }
}
