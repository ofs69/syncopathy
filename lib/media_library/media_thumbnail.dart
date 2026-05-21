import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:signals/signals_flutter.dart';
import 'package:syncopathy/helper/extensions.dart';
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

class _MediaThumbnailState extends State<MediaThumbnail> with SignalsMixin {
  late final Signal<bool> _loading = createSignal(true);
  late final Signal<Uint8List?> _thumbnail = createSignal(null);

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
      _loading.value = true;
      final bytes = await bytesFuture;

      if (mounted) {
        _thumbnail.value = bytes;
      }
    } catch (e) {
      Logger.warning("Thumbnail error: $e");
    } finally {
      if (mounted) {
        _loading.value = false;
      }
    }
  }

  Future<void> _generateThumbnail(double seekFraction, bool regenerate) async {
    if (_thumbnail.value != null && !regenerate) return;
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
    final mediaIcon = widget.media.type == MediaType.audio
        ? Icons.audiotrack
        : Icons.movie;

    final loading = _loading.watch(context);
    final thumbnail = _thumbnail.watch(context);

    final thumbnailWidget = switch ((loading, thumbnail)) {
      (false, null) => Center(
        child: Icon(
          mediaIcon,
          size: 48,
          color: Theme.of(context).colorScheme.onSurface.withAlphaF(0.5),
        ),
      ),
      (true, _) => const Center(child: CircularProgressIndicator()),
      (false, Uint8List bytes) => Image.memory(bytes, fit: BoxFit.cover),
    };

    return Stack(fit: StackFit.expand, children: [thumbnailWidget]);
  }
}
