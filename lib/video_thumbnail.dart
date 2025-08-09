import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;
import "package:async_locks/async_locks.dart";
import 'package:path_provider/path_provider.dart';
import 'package:syncopathy/logging.dart';

import 'package:syncopathy/model/video_model.dart';

class VideoThumbnail extends StatefulWidget {
  final Video video;
  const VideoThumbnail({super.key, required this.video});

  @override
  State<VideoThumbnail> createState() => _VideoThumbnailState();
}

class _VideoThumbnailState extends State<VideoThumbnail> {
  String? _thumbnailPath;
  bool _isGenerating = false;
  static final _ffmpegSemaphore = Semaphore(2);
  static final _thumbnailFutures = <String, Future<String?>>{};

  @override
  void initState() {
    super.initState();
    _getThumbnail();
  }

  @override
  void didUpdateWidget(covariant VideoThumbnail oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.video.videoPath != oldWidget.video.videoPath) {
      // If the video path changes, we might need to re-fetch.
      _thumbnailPath = null;
      _getThumbnail();
    }
  }

  void _getThumbnail() async {
    if (!mounted) return;

    setState(() {
      _isGenerating = true;
    });

    final videoHash = widget.video.videoHash;
    final future = _thumbnailFutures.putIfAbsent(
      videoHash,
      () => _generateThumbnailAndGetPath(widget.video),
    );

    try {
      final path = await future;
      if (mounted) {
        setState(() {
          _thumbnailPath = path;
        });
      }
    } catch (e) {
      // error is logged in _generateThumbnailAndGetPath
    } finally {
      if (mounted) {
        setState(() {
          _isGenerating = false;
        });
      }
    }
  }

  static Future<String?> _generateThumbnailAndGetPath(Video video) async {
    try {
      final appDataPath = await getApplicationSupportDirectory();
      final thumbDir = Directory(p.join(appDataPath.path, 'thumbnails'));
      await thumbDir.create(recursive: true);

      // store the thumbnail file without an extension as jpg
      final filename = video.videoHash;
      final thumbnailFile = File(p.join(thumbDir.path, filename));

      if (await thumbnailFile.exists()) {
        return thumbnailFile.path;
      }

      final durationSeconds = video.duration;
      if (durationSeconds == null || durationSeconds <= 0) {
        Logger.warning(
          'Video duration not available for ${video.videoPath}. Cannot generate thumbnail at 1% mark.',
        );
        return null;
      }

      // Calculate seek time (5% of duration)
      final seekTimeSeconds = durationSeconds * 0.05;

      await _ffmpegSemaphore.acquire();
      try {
        List<String> ffmpegArgs = [
          '-xerror',
          '-y',
          '-ss', // Seek to the calculated time
          seekTimeSeconds.toString(),
          '-i',
          video.videoPath,
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
        ];

        ProcessResult result = await Process.run('ffmpeg', ffmpegArgs);

        if (result.exitCode != 0) {
          Logger.warning(
            'ffmpeg failed with -ss option for ${video.videoPath}: ${result.stderr}. Retrying without -ss.',
          );
          // Retry without -ss option
          ffmpegArgs.removeRange(2, 4); // Remove '-ss' and seekTimeSeconds
          result = await Process.run('ffmpeg', ffmpegArgs);
        }
        if (result.exitCode == 0 && await thumbnailFile.exists()) {
          return thumbnailFile.path;
        } else {
          Logger.error(
            'ffmpeg error for ${video.videoPath}: ${result.stderr}',
          );
          return null;
        }
      } finally {
        _ffmpegSemaphore.release();
      }
    } catch (e) {
      Logger.error(
        'Error generating thumbnail for ${video.videoPath}: $e',
      );
      return null;
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
