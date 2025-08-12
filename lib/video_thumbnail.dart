import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
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
  State<VideoThumbnail> createState() => VideoThumbnailState();
}

class VideoThumbnailState extends State<VideoThumbnail> {
  Uint8List? _thumbnailBytes;
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
      _getThumbnail();
    }
  }

  void regenerateThumbnail() async {
    // Temporarily set thumbnail path to null to force widget rebuild
    setState(() {
      _thumbnailBytes = null; // Clear bytes too
    });

    // Delete the existing thumbnail file to force regeneration
    final appDataPath = await getApplicationSupportDirectory();
    final thumbDir = Directory(p.join(appDataPath.path, 'thumbnails'));
    final filename = widget.video.videoHash;
    final thumbnailFile = File(p.join(thumbDir.path, filename));

    if (await thumbnailFile.exists()) {
      try {
        await thumbnailFile.delete();
        await Future.delayed(
          const Duration(milliseconds: 50),
        ); // Add a small delay
      } catch (e) {
        Logger.error('Error deleting thumbnail file: $e');
      }
    }

    // Clear the existing thumbnail path and remove from cache to force regeneration
    setState(() {
      _thumbnailFutures.remove(widget.video.videoHash);
    });

    final random = Random();
    final seekFraction = 0.05 + random.nextInt(90) * 0.01;
    _getThumbnail(seekFraction: seekFraction);
  }

  void _getThumbnail({double seekFraction = 0.05}) async {
    if (!mounted) return;

    setState(() {
      _isGenerating = true;
    });

    final videoHash = widget.video.videoHash;
    final future = _thumbnailFutures.putIfAbsent(
      videoHash,
      () => generateThumbnailAndGetPath(
        widget.video,
        seekFraction,
        _ffmpegSemaphore,
      ),
    );

    try {
      final path = await future;
      if (path != null) {
        final bytes = await File(path).readAsBytes();
        if (mounted) {
          setState(() {
            _thumbnailBytes = bytes;
          });
        }
      } else {
        if (mounted) {
          setState(() {
            _thumbnailBytes = null;
          });
        }
      }
    } catch (e) {
      Logger.error('Error in _getThumbnail for ${widget.video.title}: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isGenerating = false;
        });
      }
    }
  }

  static Future<String?> generateThumbnailAndGetPath(
    Video video,
    double seekFraction,
    Semaphore ffmpegSemaphore,
  ) async {
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

      final seekTimeSeconds = durationSeconds * seekFraction;

      await ffmpegSemaphore.acquire();
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
          Logger.error('ffmpeg error for ${video.videoPath}: ${result.stderr}');
          return null;
        }
      } finally {
        ffmpegSemaphore.release();
      }
    } catch (e) {
      Logger.error('Error generating thumbnail for ${video.videoPath}: $e');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_thumbnailBytes != null) {
      return Image.memory(
        _thumbnailBytes!,
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
