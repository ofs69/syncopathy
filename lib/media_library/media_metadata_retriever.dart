import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:collection/collection.dart';
import 'package:pool/pool.dart';
import 'package:syncopathy/logging.dart';
import 'package:syncopathy/persistence/entities/media_file.dart';

class MetadataRequest {
  final int id;
  final String mediaPath;

  MetadataRequest({required this.mediaPath, required this.id});

  static MetadataRequest fromMediaFile(MediaFile file) {
    return MetadataRequest(mediaPath: file.mediaPath, id: file.id);
  }
}

class MediaMetadata {
  final double mediaDuration;

  MediaMetadata({required this.mediaDuration});
}

class MediaMetadataRetriever {
  // A stack of pending requests
  static final List<(MetadataRequest, Completer<MediaMetadata?>)> _stack = [];
  static final Pool _pool = Pool(2);

  static Future<MediaMetadata?> addRequest(MetadataRequest request) {
    final found = _stack.firstWhereOrNull((req) => req.$1.id == request.id);
    if (found != null) {
      _stack.remove(found);
      _stack.add((request, found.$2));
      _processNext();
      return found.$2.future;
    }

    final completer = Completer<MediaMetadata?>();
    _stack.add((request, completer));

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
      final (request, completer) = _stack.removeLast();

      try {
        final metadata = await _retrieveMetadata(request);
        if (!completer.isCompleted) completer.complete(metadata);
      } catch (e) {
        if (!completer.isCompleted) completer.completeError(e);
      }

      // If there's more work, try to trigger another worker
      if (_stack.isNotEmpty) _processNext();
    });
  }

  static Future<MediaMetadata?> _retrieveMetadata(
    MetadataRequest request,
  ) async {
    try {
      final ffprobeResult = await Process.run('ffprobe', [
        '-v',
        'error',
        '-select_streams',
        'v:0',
        '-show_entries',
        'stream=width,height:format=duration',
        '-of',
        'json',
        request.mediaPath,
      ]).timeout(Duration(seconds: 5));

      if (ffprobeResult.exitCode != 0) {
        Logger.error('Failed to retrieve metadata: : ${ffprobeResult.stderr}');
        return null;
      }

      final Map<String, dynamic> jsonOutput =
          jsonDecode(ffprobeResult.stdout) as Map<String, dynamic>;

      final format = jsonOutput['format'];
      final duration = format != null
          ? double.tryParse(format['duration'] as String)
          : null;
      if (duration == null) return null;
      return MediaMetadata(mediaDuration: duration);
    } catch (e) {
      Logger.error(e.toString());
    }
    return null;
  }
}
