import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'package:path/path.dart' as p;
import "package:async_locks/async_locks.dart";
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:syncopathy/logging.dart';
import 'package:syncopathy/persistence/entities/media_file.dart';
import 'package:syncopathy/player/media_kit_player.dart';

class MediaThumbnail extends StatefulWidget {
  final MediaFile mediaFile;
  const MediaThumbnail({super.key, required this.mediaFile});

  @override
  State<MediaThumbnail> createState() => MediaThumbnailState();
}

class MediaThumbnailState extends State<MediaThumbnail> {
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
  void didUpdateWidget(covariant MediaThumbnail oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.mediaFile.mediaPath != oldWidget.mediaFile.mediaPath) {
      // If the video path changes, we might need to re-fetch.
      _getThumbnail();
    }
  }

  // TODO: refactor me
  void currentFrameAsThumbnail() async {
    final player = context.read<MediaKitPlayer>();
    final appDataPath = await getApplicationSupportDirectory();
    final screenshot = p.join(appDataPath.path, "tmp.jpg");

    final thumbDir = Directory(p.join(appDataPath.path, 'thumbnails'));
    final filename = await widget.mediaFile.mediaHash;
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
      _thumbnailFutures.remove(filename);
    });

    if (!mounted) return;

    setState(() {
      _isGenerating = true;
    });

    player.screenshot(screenshot);
    try {
      // 1. Load the file from the path
      final File file = File(screenshot);
      final Uint8List bytes = await file.readAsBytes();

      // 2. Decode the JPG data
      final img.Image? originalImage = img.decodeImage(bytes);

      if (originalImage != null) {
        // 3. Resize to 300 width (Aspect ratio is kept if height is omitted)
        final img.Image resizedImage = img.copyResize(
          originalImage,
          width: 300,
          interpolation:
              img.Interpolation.average, // Better quality for downscaling
        );

        // 4. Encode back to JPG
        final List<int> jpgBytes = img.encodeJpg(resizedImage, quality: 85);
        // 5. Save to the new path
        await File(thumbnailFile.path).writeAsBytes(jpgBytes);

        final path = thumbnailFile.path;
        final bytes = await File(path).readAsBytes();
        if (mounted) {
          setState(() {
            _thumbnailBytes = bytes;
          });
        }
      }
    } catch (_) {
      if (mounted) {
        setState(() {
          _thumbnailBytes = null;
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          _isGenerating = false;
        });
      }
    }
  }

  // TODO: refactor me
  void regenerateThumbnail() async {
    // Temporarily set thumbnail path to null to force widget rebuild
    setState(() {
      _thumbnailBytes = null; // Clear bytes too
    });

    // Delete the existing thumbnail file to force regeneration
    final mediaHash = await widget.mediaFile.mediaHash;
    final appDataPath = await getApplicationSupportDirectory();
    final thumbDir = Directory(p.join(appDataPath.path, 'thumbnails'));
    final filename = mediaHash;
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
      _thumbnailFutures.remove(mediaHash);
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

    final mediaHash = await widget.mediaFile.mediaHash;
    final future = _thumbnailFutures.putIfAbsent(
      mediaHash,
      () => generateThumbnailAndGetPath(
        widget.mediaFile,
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
      Logger.error('Error in _getThumbnail for ${widget.mediaFile.name}: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isGenerating = false;
        });
      }
    }
  }

  // TODO: refactor me
  static Future<String?> generateThumbnailAndGetPath(
    MediaFile media,
    double seekFraction,
    Semaphore ffmpegSemaphore,
  ) async {
    try {
      final appDataPath = await getApplicationSupportDirectory();
      final thumbDir = Directory(p.join(appDataPath.path, 'thumbnails'));
      await thumbDir.create(recursive: true);

      // store the thumbnail file without an extension as jpg
      final filename = await media.mediaHash;
      final thumbnailFile = File(p.join(thumbDir.path, filename));

      if (await thumbnailFile.exists()) {
        return thumbnailFile.path;
      }

      final durationSeconds = media.duration;
      if (durationSeconds == null || durationSeconds <= 0) {
        Logger.warning(
          'Video duration not available for ${media.mediaPath}. Cannot generate thumbnail at 1% mark.',
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
          media.mediaPath,
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
            'ffmpeg failed with -ss option for ${media.mediaPath}: ${result.stderr}. Retrying without -ss.',
          );
          // Retry without -ss option
          ffmpegArgs.removeRange(2, 4); // Remove '-ss' and seekTimeSeconds
          result = await Process.run('ffmpeg', ffmpegArgs);
        }
        if (result.exitCode == 0 && await thumbnailFile.exists()) {
          return thumbnailFile.path;
        } else {
          Logger.error('ffmpeg error for ${media.mediaPath}: ${result.stderr}');
          return null;
        }
      } finally {
        ffmpegSemaphore.release();
      }
    } catch (e) {
      Logger.error('Error generating thumbnail for ${media.mediaPath}: $e');
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
