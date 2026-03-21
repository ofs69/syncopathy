import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:syncopathy/ioc.dart';
import 'package:syncopathy/logging.dart';
import 'package:syncopathy/media_library/thumbnail_generator.dart';
import 'package:syncopathy/persistence/entities/media_file.dart';
import 'package:syncopathy/player/video_player.dart';

class MediaThumbnailController {
  Function(double, bool)? _regenerateCallback;
  Function(Future<Uint8List?>)? _setThumbnailCallback;

  void regenerateThumbnail() {
    final seekFraction = 0.01 + Random().nextInt(94) * 0.01;
    _regenerateCallback?.call(seekFraction, true);
  }

  void _dispose() {
    _regenerateCallback = null;
    _setThumbnailCallback = null;
  }

  void currentFrameAsThumbnail() {
    _setThumbnailCallback?.call(getIt.get<VideoPlayer>().screenshot());
  }
}

class MediaThumbnail extends StatefulWidget {
  final MediaThumbnailController controller;
  final MediaFile media;
  const MediaThumbnail({
    super.key,
    required this.media,
    required this.controller,
  });

  @override
  State<MediaThumbnail> createState() => _MediaThumbnailState();
}

class _MediaThumbnailState extends State<MediaThumbnail> {
  bool _loading = true;
  Uint8List? _thumbnail;

  @override
  void initState() {
    super.initState();
    widget.controller._regenerateCallback = _generateThumbnail;
    widget.controller._setThumbnailCallback = _setThumbnail;
    _generateThumbnail(0.01, false);
  }

  @override
  void dispose() {
    super.dispose();
    widget.controller._dispose();
  }

  Future<void> _setThumbnail(Future<Uint8List?> bytesFuture) async {
    try {
      setState(() {
        _loading = true;
      });
      final bytes = await bytesFuture;

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

  Future<void> _generateThumbnail(double seekFraction, bool regenerate) async {
    if (_thumbnail != null && !regenerate) return;
    await _setThumbnail(
      ThumbnailGenerator().addRequest(
        ThumbnailRequest(
          file: widget.media,
          seekFraction: seekFraction,
          regenerate: regenerate,
        ),
      ),
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
