import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;
import "package:async_locks/async_locks.dart";
import 'package:path_provider/path_provider.dart';
import 'package:syncopathy/logging.dart';

class VideoThumbnail extends StatefulWidget {
  final String videoPath;
  final String videoHash;
  const VideoThumbnail({
    super.key,
    required this.videoPath,
    required this.videoHash,
  });

  @override
  State<VideoThumbnail> createState() => _VideoThumbnailState();
}

class _VideoThumbnailState extends State<VideoThumbnail> {
  String? _thumbnailPath;
  bool _isGenerating = false;
  static final _ffmpegSemaphore = Semaphore(2);

  @override
  void initState() {
    super.initState();
    _generateThumbnail();
  }

  @override
  void didUpdateWidget(covariant VideoThumbnail oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.videoPath != oldWidget.videoPath) {
      // If the video path changes, reset and generate a new thumbnail.
      _thumbnailPath = null;
      _generateThumbnail();
    }
  }

  Future<void> _generateThumbnail() async {
    if (!mounted) return;
    setState(() {
      _isGenerating = true;
    });

    try {
      final appDataPath = await getApplicationSupportDirectory();
      final thumbDir = Directory(p.join(appDataPath.path, 'thumbnails'));
      await thumbDir.create(recursive: true);

      // store the thumbnail file without an extension as jpg
      final filename = widget.videoHash;
      final thumbnailFile = File(p.join(thumbDir.path, filename));

      if (await thumbnailFile.exists()) {
        if (mounted) {
          setState(() {
            _thumbnailPath = thumbnailFile.path;
          });
        }
        return;
      }

      await _ffmpegSemaphore.acquire();
      try {
        final result = await Process.run('ffmpeg', [
          '-xerror',
          '-y',
          '-i',
          widget.videoPath,
          '-vf',
          "thumbnail,scale=300:-1",
          '-vframes',
          '1',
          '-q:v',
          '2',
          '-f',
          'image2',
          '-vcodec',
          'mjpeg',
          thumbnailFile.path,
        ]);
        if (result.exitCode == 0 && await thumbnailFile.exists()) {
          if (mounted) {
            setState(() {
              _thumbnailPath = thumbnailFile.path;
            });
          }
        } else {
          Logger.error(
            'ffmpeg error for ${widget.videoPath}: ${result.stderr}',
          );
        }
      } finally {
        _ffmpegSemaphore.release();
      }
    } catch (e) {
      Logger.error('Error generating thumbnail for ${widget.videoPath}: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isGenerating = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_thumbnailPath != null) {
      return Image.file(
        File(_thumbnailPath!),
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          // This can happen if the file gets deleted from the cache.
          return const Center(child: Icon(Icons.broken_image_outlined));
        },
      );
    }

    return Container(
      color: Colors.black38,
      child: Center(
        child: _isGenerating
            ? const CircularProgressIndicator()
            : const Icon(Icons.movie_outlined, color: Colors.white70),
      ),
    );
  }
}
