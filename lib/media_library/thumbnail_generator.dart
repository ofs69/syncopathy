import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:collection/collection.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:pool/pool.dart';
import 'package:syncopathy/logging.dart';
import 'package:syncopathy/persistence/entities/media_file.dart';

class ThumbnailRequest {
  final int id;
  final String mediaHash;
  final double duration;
  final String mediaPath;

  static ThumbnailRequest? fromMediaFile(MediaFile file) {
    final fileHash = file.fileHash;
    final duration = file.duration;
    if (fileHash == null || duration == null) return null;
    return ThumbnailRequest(
      id: file.id,
      mediaHash: fileHash,
      duration: duration,
      mediaPath: file.mediaPath,
    );
  }

  ThumbnailRequest({
    required this.id,
    required this.mediaHash,
    required this.duration,
    required this.mediaPath,
  });
}

class ThumbnailGenerator {
  // A stack of pending requests
  static final List<(ThumbnailRequest, Completer<Uint8List?>)> _stack = [];
  static final Pool _pool = Pool(2);

  static Future<Uint8List?> addRequest(ThumbnailRequest request) {
    final found = _stack.firstWhereOrNull((req) => req.$1.id == request.id);
    if (found != null) {
      _stack.remove(found);
      _stack.add((request, found.$2));
      _processNext();
      return found.$2.future;
    }

    final completer = Completer<Uint8List?>();
    _stack.add((request, completer));

    // Kick off a processing attempt
    _processNext();

    return completer.future;
  }

  static void _processNext() async {
    // We don't use a while loop or _isProcessing flag here.
    // We let the Pool handle the "slots" available.
    if (_stack.isEmpty) return;

    // Schedule a task in the pool
    if (_stack.isEmpty) return;

    // LIFO: Always take the newest item from the stack
    final (request, completer) = _stack.removeLast();

    try {
      final bytes = await _generateThumbnail(request);
      if (!completer.isCompleted) completer.complete(bytes);
    } catch (e) {
      if (!completer.isCompleted) completer.completeError(e);
    }

    // If there's more work, try to trigger another worker
    if (_stack.isNotEmpty) _processNext();
  }

  static Future<Uint8List?> _generateThumbnail(ThumbnailRequest request) async {
    final file = await generateThumbnailAndGetPath(request, 0.01);
    if (file != null && await file.exists()) {
      return file.readAsBytes();
    }
    return null;
  }

  static Future<File?> generateThumbnailAndGetPath(
    ThumbnailRequest request,
    double? seekFraction,
  ) async {
    try {
      final appDataPath = await getApplicationSupportDirectory();
      final thumbDir = Directory(p.join(appDataPath.path, 'thumbnails'));
      await thumbDir.create(recursive: true);

      // store the thumbnail file without an extension as jpg

      final thumbnailFile = File(p.join(thumbDir.path, request.mediaHash));
      if (await thumbnailFile.exists()) {
        return thumbnailFile;
      }

      double? seekTimeSeconds;
      if (seekFraction != null) {
        if (request.duration <= 0) {
          Logger.warning(
            'Video duration not available for ${request.mediaPath}.',
          );
          return null;
        }
        seekTimeSeconds = request.duration * seekFraction;
      }

      return _pool.withResource(() async {
        List<String> ffmpegArgs = [
          '-xerror',
          '-y',
          if (seekTimeSeconds != null) '-ss',
          if (seekTimeSeconds != null) seekTimeSeconds.toString(),
          '-discard',
          'nokey',
          '-i',
          request.mediaPath,
          '-vf',
          'thumbnail,scale=640:-1',
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
          Logger.error(
            'ffmpeg error for ${request.mediaPath}: ${result.stderr}',
          );
          return null;
        }
      });
    } catch (e) {
      Logger.error('Error generating thumbnail for ${request.mediaPath}: $e');
      return null;
    }
  }
}
