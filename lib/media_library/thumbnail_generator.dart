import 'dart:io';
import 'dart:typed_data';

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:pool/pool.dart';
import 'package:syncopathy/helper/constants.dart';
import 'package:syncopathy/helper/task_queue.dart';
import 'package:syncopathy/logging.dart';
import 'package:syncopathy/persistence/entities/media_file.dart';
import 'package:syncopathy/persistence/media_file_extension.dart';

class ThumbnailRequest extends BaseRequest {
  @override
  int get id => file.id;
  final MediaFile file;

  ThumbnailRequest({required this.file});
}

class ThumbnailGenerator extends TaskQueue<ThumbnailRequest, Uint8List> {
  static final ThumbnailGenerator _instance = ThumbnailGenerator._internal();
  late final Pool _pool = Pool(maxConcurrent);

  ThumbnailGenerator._internal() : super(maxConcurrent: maxConcurrentProcess);
  factory ThumbnailGenerator() => _instance;

  @override
  Future<Uint8List?> addRequest(ThumbnailRequest request) {
    request.file.retrieveMetadata();
    return super.addRequest(request);
  }

  @override
  Future<Uint8List?> processRequest(ThumbnailRequest request) async {
    final fileHash = request.file.fileHash;
    final appDataPath = await getApplicationSupportDirectory();
    final thumbnailFile = File(
      p.join(appDataPath.path, 'thumbnails', fileHash!),
    );

    if (await thumbnailFile.exists()) {
      return await thumbnailFile.readAsBytes();
    }

    return await _pool.withResource(() async {
      final file = await _generateThumbnailAndGetPath(request, 0.01);
      return await file?.readAsBytes();
    });
  }

  Future<File?> _generateThumbnailAndGetPath(
    ThumbnailRequest request,
    double? seekFraction,
  ) async {
    try {
      final fileHash = request.file.fileHash;
      if (fileHash == null) return null;
      var metadata = await request.file.retrieveMetadata();
      if (metadata == null) return null;

      final appDataPath = await getApplicationSupportDirectory();
      final thumbDir = Directory(p.join(appDataPath.path, 'thumbnails'));
      await thumbDir.create(recursive: true);
      final thumbnailFile = File(p.join(thumbDir.path, fileHash));
      if (await thumbnailFile.exists()) return thumbnailFile;

      double? seekTimeSeconds;
      if (seekFraction != null && metadata.duration > 0) {
        seekTimeSeconds = metadata.duration * seekFraction;
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
        result = await Process.run(
          'ffmpeg',
          ffmpegArgs,
        ).timeout(const Duration(seconds: 10));
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
