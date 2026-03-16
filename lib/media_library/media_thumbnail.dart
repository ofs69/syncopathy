import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:syncopathy/ioc.dart';
import 'package:syncopathy/media_library/thumbnail_generator.dart';
import 'package:syncopathy/persistence/entities/media_file.dart';
import 'package:syncopathy/persistence/media_file_extension.dart';

class MediaThumbnail extends StatefulWidget {
  final MediaFile media;
  const MediaThumbnail({super.key, required this.media});

  @override
  State<MediaThumbnail> createState() => _MediaThumbnailState();
}

class _MediaThumbnailState extends State<MediaThumbnail> {
  bool _loading = true;
  Uint8List? _thumbnail;

  @override
  void initState() {
    super.initState();

    widget.media
        .retrieveDuration()
        .then((duration) async {
          final media = oBox.mediaService.getById(widget.media.id);
          if (media == null) return;
          final thumbnailRequest = ThumbnailRequest.fromMediaFile(media);
          if (thumbnailRequest != null) {
            if (mounted) {}
            await ThumbnailGenerator.addRequest(thumbnailRequest).then((bytes) {
              if (mounted) {
                setState(() {
                  _thumbnail = bytes;
                  _loading = false;
                });
              }
            });
          }
        })
        .then(
          (_) {
            if (!mounted) return;
            setState(() {
              _loading = false;
            });
          },
          onError: (_) {
            if (!mounted) return;
            setState(() {
              _loading = false;
            });
          },
        );
  }

  @override
  Widget build(BuildContext context) {
    final widget = switch ((_loading, _thumbnail)) {
      (false, null) => Center(child: Icon(Icons.image)),
      (true, _) => Center(child: CircularProgressIndicator()),
      (false, Uint8List bytes) => Image.memory(bytes, fit: BoxFit.cover),
    };

    return Stack(fit: StackFit.expand, children: [widget]);
  }
}
