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
import 'package:syncopathy/persistence/entities/media_metadata.dart';

/// Decode threads per ffmpeg job. Frame-threading gives each thread its own set
/// of reference frames, so the decoder's frame pool — not the filter graph —
/// dominates peak memory on high-resolution sources. Measured on an 8K source:
/// 1552 MB with ffmpeg's default thread count vs 337 MB at 2.
const int _decodeThreads = 2;

/// Width every thumbnail is scaled down to before analysis and encoding.
const int _thumbnailWidth = 640;

/// Source-size tiers, in megapixels: roughly 1080p and 4K.
const double _hdMegapixels = 2.5;
const double _uhdMegapixels = 9.0;

/// Per-job cost, derived from the source resolution.
///
/// [slots] is how much of the [maxConcurrentProcess] budget the job occupies,
/// so a handful of 8K sources can't all run at once; [frames] is how many
/// frames the `thumbnail` filter analyses before picking one, which sets the
/// job's CPU cost far more than its quality.
class _JobProfile {
  final int slots;
  final int frames;

  const _JobProfile({required this.slots, required this.frames});

  factory _JobProfile.forMetadata(MediaMetadata? metadata) {
    final width = metadata?.width;
    final height = metadata?.height;
    // Unknown resolution: assume the common case rather than the worst one, so
    // a library missing metadata doesn't thumbnail at a crawl.
    if (width == null || height == null || width <= 0 || height <= 0) {
      return const _JobProfile(slots: 1, frames: 100);
    }

    final megapixels = (width * height) / 1000000;
    if (megapixels <= _hdMegapixels) {
      return const _JobProfile(slots: 1, frames: 100);
    }
    if (megapixels <= _uhdMegapixels) {
      return const _JobProfile(slots: 1, frames: 50);
    }
    return const _JobProfile(slots: 2, frames: 25);
  }
}

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

  /// Budget of concurrent ffmpeg work, spent in whole slots per job.
  late final Pool _budget = Pool(maxConcurrent);

  /// Slots are taken under a single-entry gate so a multi-slot job acquires all
  /// of them atomically. Without it, several large jobs can each hold part of
  /// the budget while waiting for the rest, and none of them ever proceeds.
  final Pool _acquireGate = Pool(1);

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

  /// Runs [action] holding [slots] of the budget, releasing them afterwards.
  Future<T> _withSlots<T>(int slots, Future<T> Function() action) async {
    final wanted = slots.clamp(1, maxConcurrent);
    final held = await _acquireGate.withResource(() async {
      final resources = <PoolResource>[];
      for (var i = 0; i < wanted; i++) {
        resources.add(await _budget.request());
      }
      return resources;
    });

    try {
      return await action();
    } finally {
      for (final resource in held) {
        resource.release();
      }
    }
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

    // Only cache misses reach ffmpeg, so the budget is taken here rather than
    // around the cache read above.
    final profile = _JobProfile.forMetadata(request.file.metadata.target);

    return await _withSlots(profile.slots, () async {
      final file = await _generateThumbnailAndGetPath(request, profile);
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

  Future<File?> _generateThumbnailAndGetPath(
    ThumbnailRequest request,
    _JobProfile profile,
  ) async {
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
        // Applies to the decoder (it precedes -i); see _decodeThreads.
        '-threads',
        '$_decodeThreads',
        if (seek != null) ...['-ss', seek.toString()],
        '-i',
        request.file.mediaPath,
        // Scale before `thumbnail`, not after: the filter buffers `n` frames
        // before choosing one, and buffering them at 640px instead of source
        // resolution is what keeps a 4K/8K job from allocating gigabytes.
        // -2 (rather than -1) keeps the derived height even, which the yuv420p
        // mjpeg encoder requires.
        '-vf',
        'scale=$_thumbnailWidth:-2,thumbnail=n=${profile.frames}',
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

      // Note: we already hold our slots of the budget, so run the process
      // directly.
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
