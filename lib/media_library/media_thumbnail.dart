import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:syncopathy/logging.dart';
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
    _generateThumbnail();
  }

  Future<void> _generateThumbnail() async {
    try {
      final bytes = await ThumbnailGenerator().addRequest(
        ThumbnailRequest(file: widget.media),
      );

      if (mounted) {
        setState(() {
          _thumbnail = bytes;
        });
      }
    } catch (e) {
      Logger.warning("Thumbnail error: $e");
    } finally {
      if (mounted) {
        setState(() {
          _loading = false;
        });
      }
    }
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
