import 'dart:convert';
import 'dart:io';

import 'package:pool/pool.dart';
import 'package:syncopathy/helper/constants.dart';
import 'package:syncopathy/helper/task_queue.dart';
import 'package:syncopathy/persistence/entities/media_file.dart';

class MetadataRequest extends BaseRequest {
  @override
  final int id;
  final String mediaPath;

  static MetadataRequest fromMediaFile(MediaFile file) {
    return MetadataRequest(mediaPath: file.mediaPath, id: file.id);
  }

  MetadataRequest({required this.id, required this.mediaPath});
}

class MediaMetadataRetrieved {
  final double duration;
  final int? width;
  final int? height;
  final String? videoCodec;
  final String? audioCodec;
  final int? bitRate;
  final int? rotation;
  final double? frameRate;
  final int? audioChannels;
  final String? pixelFormat;
  final String? aspectRatio;
  final DateTime? creationTime;

  MediaMetadataRetrieved({
    required this.duration,
    this.width,
    this.height,
    this.videoCodec,
    this.audioCodec,
    this.bitRate,
    this.rotation,
    this.frameRate,
    this.audioChannels,
    this.pixelFormat,
    this.aspectRatio,
    this.creationTime,
  });
}

class MediaMetadataRetriever
    extends TaskQueue<MetadataRequest, MediaMetadataRetrieved> {
  static final MediaMetadataRetriever _instance =
      MediaMetadataRetriever._internal();
  late final Pool _pool = Pool(maxConcurrent);

  MediaMetadataRetriever._internal()
    : super(maxConcurrent: maxConcurrentProcess);
  factory MediaMetadataRetriever() => _instance;

  @override
  Future<MediaMetadataRetrieved?> processRequest(MetadataRequest request) {
    return _pool.withResource(() async {
      return await runFFprobe(request.mediaPath);
    });
  }

  static Future<MediaMetadataRetrieved?> runFFprobe(String mediaPath) async {
    Process? process;
    try {
      process = await Process.start('ffprobe', [
        '-v',
        'error',
        '-show_format',
        '-show_streams',
        '-of',
        'json',
        mediaPath,
      ]);

      final results = await Future.wait([
        process.stdout.transform(utf8.decoder).join(),
        process.stderr.transform(utf8.decoder).join(),
      ]).timeout(const Duration(seconds: 5));

      if (await process.exitCode != 0) return null;

      final data = jsonDecode(results[0]) as Map<String, dynamic>;
      final format = data['format'] ?? {};
      final streams = data['streams'] as List? ?? [];

      // Find first video and audio streams
      final video = streams.firstWhere(
        (s) => s['codec_type'] == 'video',
        orElse: () => null,
      );
      final audio = streams.firstWhere(
        (s) => s['codec_type'] == 'audio',
        orElse: () => null,
      );

      final duration = double.tryParse(format['duration']?.toString() ?? '');
      if (duration == null) return null;

      var rotation = int.tryParse(video?['tags']?['rotate']?.toString() ?? '0');
      if (rotation == 0 && video?['side_data_list'] != null) {
        final sideData = video?['side_data_list'] as List;
        final displayMatrix = sideData.firstWhere(
          (d) => d['side_data_type'] == 'Display Matrix',
          orElse: () => null,
        );
        rotation = displayMatrix?['rotation'] ?? 0;
      }
      double? avgFrameRate;
      if (video?['avg_frame_rate'] case String avgFrameRateString) {
        var split = avgFrameRateString.split('/');
        var d1 = double.tryParse(split[0]);
        var d2 = double.tryParse(split[1]);
        if (d1 != null && d2 != null) {
          avgFrameRate = d1 / d2;
        }
      }

      return MediaMetadataRetrieved(
        duration: duration,
        width: video?['width'],
        height: video?['height'],
        videoCodec: video?['codec_name'],
        audioCodec: audio?['codec_name'],
        bitRate: int.tryParse(format['bit_rate']?.toString() ?? ''),
        rotation: rotation,
        frameRate: avgFrameRate,
        audioChannels: audio?['channels'],
        pixelFormat: video?['pix_fmt'],
        aspectRatio: video?['display_aspect_ratio'],
        creationTime: DateTime.tryParse(
          format['tags']?['creation_time']?.toString() ?? '',
        ),
      );
    } catch (e) {
      process?.kill();
      return null;
    }
  }
}
