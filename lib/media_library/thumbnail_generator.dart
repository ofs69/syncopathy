import 'dart:io';
import 'dart:typed_data';

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:pool/pool.dart';
import 'package:syncopathy/helper/constants.dart';
import 'package:syncopathy/helper/task_queue.dart';
import 'package:syncopathy/ioc.dart';
import 'package:syncopathy/logging.dart';
import 'package:syncopathy/persistence/entities/media_file.dart';

class ThumbnailRequest extends BaseRequest {
  @override
  int get id => file.id;
  final MediaFile file;
  final double seekFraction;
  final bool regenerate;

  ThumbnailRequest({
    required this.file,
    this.seekFraction = 0.01,
    this.regenerate = false,
  });
}

class ThumbnailGenerator extends TaskQueue<ThumbnailRequest, Uint8List> {
  static final ThumbnailGenerator _instance = ThumbnailGenerator._internal();
  late final Pool _pool = Pool(maxConcurrent);

  ThumbnailGenerator._internal() : super(maxConcurrent: maxConcurrentProcess);
  factory ThumbnailGenerator() => _instance;

  @override
  Future<Uint8List?> processRequest(ThumbnailRequest request) async {
    final fileHash = request.file.fileHash;
    final appDataPath = await getApplicationSupportDirectory();
    final thumbnailFile = File(
      p.join(appDataPath.path, 'thumbnails', fileHash!),
    );

    if (!request.regenerate && await thumbnailFile.exists()) {
      return await thumbnailFile.readAsBytes();
    }

    if (!request.regenerate && request.file.thumbnailGenerationFailed) {
      return null;
    }

    return await _pool.withResource(() async {
      final file = await _generateThumbnailAndGetPath(request);
      final bytes = await file?.readAsBytes();

      if (bytes != null) {
        if (request.file.thumbnailGenerationFailed) {
          request.file.thumbnailGenerationFailed = false;
          oBox.mediaService.save(request.file);
        }
      } else {
        if (!request.file.thumbnailGenerationFailed) {
          request.file.thumbnailGenerationFailed = true;
          oBox.mediaService.save(request.file);
        }
      }

      return bytes;
    });
  }

  Future<File?> _generateThumbnailAndGetPath(ThumbnailRequest request) async {
    try {
      final fileHash = request.file.fileHash;
      if (fileHash == null) return null;
      var metadata = request.file.metadata.target;
      if (metadata == null) return null;

      final appDataPath = await getApplicationSupportDirectory();
      final thumbDir = Directory(p.join(appDataPath.path, 'thumbnails'));
      await thumbDir.create(recursive: true);
      final thumbnailFile = File(p.join(thumbDir.path, fileHash));
      if (!request.regenerate && await thumbnailFile.exists()) {
        return thumbnailFile;
      }

      double? seekTimeSeconds;
      if (metadata.duration > 0) {
        seekTimeSeconds = metadata.duration * request.seekFraction;
      }

      List<String> ffmpegArgs = [
        '-xerror',
        '-y',
        if (seekTimeSeconds != null) ...['-ss', seekTimeSeconds.toString()],
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
      ProcessResult result = await Process.run(
        'ffmpeg',
        ffmpegArgs,
      ).timeout(const Duration(seconds: 10));

      if (result.exitCode != 0 && seekTimeSeconds != null) {
        // Retry logic: Remove -ss args (indices 2 and 3)
        ffmpegArgs.removeAt(2);
        ffmpegArgs.removeAt(2);
        result = await Process.run('ffmpeg', ffmpegArgs);
      }

      if (result.exitCode == 0 && await thumbnailFile.exists()) {
        return thumbnailFile;
      } else {
        Logger.error('ffmpeg error: ${result.stderr}');
      }
    } catch (e) {
      Logger.error('Error generating thumbnail: $e');
    }
    return null;
  }
}
