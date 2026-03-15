import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:pool/pool.dart';
import 'package:syncopathy/logging.dart';
import 'package:syncopathy/persistence/entities/media_file.dart';

class ThumbnailGenerator {
  // A stack of pending requests
  static final List<(MediaFile, Completer<Uint8List?>)> _stack = [];
  static final Pool _pool = Pool(2);

  static Future<Uint8List?> addRequest(MediaFile media) {
    // Remove duplicate requests for the same file to keep the stack clean
    _stack.removeWhere((req) => req.$1.id == media.id);

    final completer = Completer<Uint8List?>();
    _stack.add((media, completer));

    // Kick off a processing attempt
    _processNext();

    return completer.future;
  }

  static void _processNext() {
    // We don't use a while loop or _isProcessing flag here.
    // We let the Pool handle the "slots" available.
    if (_stack.isEmpty) return;

    // Schedule a task in the pool
    _pool.withResource(() async {
      if (_stack.isEmpty) return;

      // LIFO: Always take the newest item from the stack
      final (media, completer) = _stack.removeLast();

      try {
        final bytes = await _generateThumbnail(media);
        if (!completer.isCompleted) completer.complete(bytes);
      } catch (e) {
        if (!completer.isCompleted) completer.completeError(e);
      }

      // If there's more work, try to trigger another worker
      if (_stack.isNotEmpty) _processNext();
    });
  }

  static Future<Uint8List?> _generateThumbnail(MediaFile media) async {
    final file = await generateThumbnailAndGetPath(media, 0.05);
    if (file != null && await file.exists()) {
      return file.readAsBytes();
    }
    return null;
  }

  static Future<File?> generateThumbnailAndGetPath(
    MediaFile media,
    double? seekFraction,
  ) async {
    try {
      final appDataPath = await getApplicationSupportDirectory();
      final thumbDir = Directory(p.join(appDataPath.path, 'thumbnails'));
      await thumbDir.create(recursive: true);

      // store the thumbnail file without an extension as jpg
      final filename = media.fileHash;
      if (filename == null) return null;

      final thumbnailFile = File(p.join(thumbDir.path, filename));
      if (await thumbnailFile.exists()) {
        return thumbnailFile;
      }

      if (seekFraction != null && media.duration == null) {
        Logger.error("Can't generate thumbnail because duration is unknown.");
        return null;
      }

      double? seekTimeSeconds;
      if (seekFraction != null) {
        final durationSeconds = media.duration;
        if (durationSeconds == null || durationSeconds <= 0) {
          Logger.warning(
            'Video duration not available for ${media.mediaPath}. Cannot generate thumbnail at 1% mark.',
          );
          return null;
        }
        seekTimeSeconds = durationSeconds * seekFraction;
      }

      List<String> ffmpegArgs = [
        '-xerror',
        '-y',
        if (seekTimeSeconds != null) '-ss',
        if (seekTimeSeconds != null) seekTimeSeconds.toString(),
        '-i',
        media.mediaPath,
        '-vf',
        "thumbnail,scale=640:-1",
        '-vframes',
        '1',
        '-an',
        '-q:v',
        '2',
        '-f',
        'image2',
        '-vcodec',
        'mjpeg',
        thumbnailFile.path,
      ];
      ProcessResult result = await Process.run('ffmpeg', ffmpegArgs);
      if (result.exitCode != 0 && seekTimeSeconds != null) {
        // Retry without -ss option
        ffmpegArgs.removeRange(2, 4); // Remove '-ss' and seekTimeSeconds
        result = await Process.run('ffmpeg', ffmpegArgs);
      }

      if (result.exitCode == 0 && await thumbnailFile.exists()) {
        return thumbnailFile;
      } else {
        Logger.error('ffmpeg error for ${media.mediaPath}: ${result.stderr}');
        return null;
      }
    } catch (e) {
      Logger.error('Error generating thumbnail for ${media.mediaPath}: $e');
      return null;
    }
  }
}
