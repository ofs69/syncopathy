import 'dart:io';
import 'dart:typed_data';

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:pool/pool.dart';
import 'package:syncopathy/helper/constants.dart';
import 'package:syncopathy/logging.dart';
import 'package:syncopathy/helper/task_queue.dart';
import 'package:syncopathy/ioc.dart';
import 'package:syncopathy/persistence/entities/media_file.dart';

class ThumbnailRequest extends BaseRequest {
  @override
  int get id => file.id;
  final MediaFile file;
  final double seekFraction;
  final bool regenerate;
  final bool retryFailed;

  ThumbnailRequest({
    required this.file,
    this.seekFraction = 0.01,
    this.regenerate = false,
    this.retryFailed = false,
  });
}

class ThumbnailGenerator extends TaskQueue<ThumbnailRequest, Uint8List> {
  static final ThumbnailGenerator _instance = ThumbnailGenerator._internal();
  late final Pool _pool = Pool(maxConcurrent);

  ThumbnailGenerator._internal() : super(maxConcurrent: maxConcurrentProcess);
  factory ThumbnailGenerator() => _instance;

  Future<File?> _getThumbnailFile(String? fileHash) async {
    if (fileHash == null || fileHash.length < 4) return null;
    final appDataPath = await getApplicationSupportDirectory();
    final thumbDir = Directory(p.join(appDataPath.path, 'thumbnails'));

    // Sharding: use first 2 characters then next 2 characters
    // abcdef... -> thumbnails/ab/cd/abcdef...
    final shard1 = fileHash.substring(0, 2);
    final shard2 = fileHash.substring(2, 4);
    final shardedPath = p.join(thumbDir.path, shard1, shard2, fileHash);
    return File(shardedPath);
  }

  @override
  Future<Uint8List?> processRequest(ThumbnailRequest request) async {
    final fileHash = request.file.fileHash;
    final thumbnailFile = await _getThumbnailFile(fileHash);

    if (thumbnailFile != null &&
        !request.regenerate &&
        await thumbnailFile.exists()) {
      return await thumbnailFile.readAsBytes();
    }

    if (!request.regenerate &&
        !request.retryFailed &&
        request.file.thumbnailGenerationFailed) {
      return null;
    }

    return await _pool.withResource(() async {
      final file = await _generateThumbnailAndGetPath(request);
      final bytes = await file?.readAsBytes();

      if (bytes != null) {
        if (request.file.thumbnailGenerationFailed) {
          oBox.mediaRepository.setThumbnailGenerationFailed(
            request.file,
            false,
          );
        }
      } else {
        if (!request.file.thumbnailGenerationFailed) {
          oBox.mediaRepository.setThumbnailGenerationFailed(request.file, true);
        }
      }

      return bytes;
    });
  }

  Future<File?> _generateThumbnailAndGetPath(ThumbnailRequest request) async {
    try {
      final fileHash = request.file.fileHash;
      if (fileHash.isEmpty) return null;
      var metadata = request.file.metadata.target;
      if (metadata == null) return null;

      final thumbnailFile = await _getThumbnailFile(fileHash);
      if (thumbnailFile == null) return null;

      if (!request.regenerate && await thumbnailFile.exists()) {
        return thumbnailFile;
      }

      try {
        await thumbnailFile.parent.create(recursive: true);
      } on FileSystemException {
        // Directory.create(recursive: true) is not atomic: concurrent
        // requests can race on a shared intermediate dir (e.g. the base
        // thumbnails/ dir on first scan) and one throws "File exists".
        // If the directory now exists the race is benign; otherwise rethrow.
        if (!await thumbnailFile.parent.exists()) rethrow;
      }

      double? seekTimeSeconds;
      if (metadata.duration > 0) {
        seekTimeSeconds = metadata.duration * request.seekFraction;
      }

      List<String> buildFfmpegArgs({double? seek}) => [
        '-xerror',
        '-y',
        if (seek != null) ...['-ss', seek.toString()],
        '-i',
        request.file.mediaPath,
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

      // Note: We are already inside a Pool resource from the base class,
      // so we just run the process directly.
      var result = await Process.run(
        'ffmpeg',
        buildFfmpegArgs(seek: seekTimeSeconds),
      );

      if (result.exitCode != 0 && seekTimeSeconds != null) {
        // Retry without the seek in case the seek point is unreadable.
        result = await Process.run('ffmpeg', buildFfmpegArgs());
      }

      if (result.exitCode == 0 && await thumbnailFile.exists()) {
        return thumbnailFile;
      } else {
        // A per-file failure is expected for unreadable/unsupported media; it is
        // recorded via thumbnailGenerationFailed and shown as a fallback icon,
        // so log it rather than alerting the user once per file during a scan.
        Logger.error('ffmpeg thumbnail generation failed: ${result.stderr}');
      }
    } catch (e, st) {
      Logger.error('Error generating thumbnail', e, st);
    }
    return null;
  }
}
