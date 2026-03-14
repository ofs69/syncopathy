import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:syncopathy/media_library/thumbnail_generator.dart';
import 'package:syncopathy/persistence/entities/media_file.dart';

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
    ThumbnailGenerator.addRequest(widget.media).then((bytes) {
      if (mounted) {
        setState(() {
          _thumbnail = bytes;
          _loading = false;
        });
      }
    });
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
