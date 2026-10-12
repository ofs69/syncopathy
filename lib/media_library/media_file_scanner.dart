import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:syncopathy/helper/long_path.dart';
import 'package:syncopathy/logging.dart';
import 'package:syncopathy/persistence/entities/media_file.dart';

/// What walking the search paths turned up, plus the directories that could not
/// be read (missing search path, permissions, a path the platform refuses to
/// list) and were therefore skipped.
class MediaScanListing {
  final List<File> mediaFiles;
  final List<File> funscriptFiles;
  final List<String> skippedPaths;

  const MediaScanListing(
    this.mediaFiles,
    this.funscriptFiles,
    this.skippedPaths,
  );
}

/// Walks the configured search paths and splits what it finds into media and
/// funscripts.
///
/// Shared by normal indexing and by the funscript matching tool: both need the
/// same view of what is on disk, and a second copy of the extension sets is a
/// second place for the two to disagree about what counts as media.
class MediaFileScanner {
  static const Set<String> videoExtensions = {
    '.mp4',
    '.mkv',
    '.avi',
    '.mov',
    '.wmv',
    '.webm',
  };

  static const Set<String> audioExtensions = {
    '.mp3',
    '.aac',
    '.wav',
    '.flac',
    '.ogg',
    '.m4a',
    '.wma',
    '.opus',
  };

  static const String funscriptExtension = '.funscript';

  /// Media type implied by [path]'s extension.
  static MediaType typeForPath(String path) {
    final extension = p.extension(path).toLowerCase();
    if (videoExtensions.contains(extension)) return MediaType.video;
    if (audioExtensions.contains(extension)) return MediaType.audio;
    return MediaType.unknown;
  }

  /// Recursively lists [searchPaths], splitting entries into media files (by
  /// extension) and `.funscript` files.
  ///
  /// Walks the tree one directory at a time rather than using
  /// `list(recursive: true)`: a recursive listing reports the first directory
  /// it cannot read as a stream error, which aborts the walk of everything
  /// after it — the rest of that tree *and* every remaining search path — and
  /// leaves the scan with nothing at all. Here an unreadable directory costs
  /// only its own subtree, and is reported back so the user can be told.
  ///
  /// [onProgress] is called as the walk goes, with the directories visited so
  /// far and what has been found in them. A walk over a large or a remote tree
  /// takes long enough that a caller with no way to say so leaves the user
  /// watching a message that never changes.
  static Future<MediaScanListing> list(
    List<String> searchPaths, {
    void Function(int directories, int media, int funscripts)? onProgress,
  }) async {
    final combinedExtension = {...videoExtensions, ...audioExtensions};
    final List<File> mediaFiles = [];
    final List<File> funscriptFiles = [];
    final List<String> skippedPaths = [];
    var directories = 0;

    for (final searchPath in searchPaths) {
      if (!await Directory(searchPath).exists()) {
        skippedPaths.add(searchPath);
        continue;
      }

      final pending = <String>[searchPath];
      while (pending.isNotEmpty) {
        final dirPath = pending.removeLast();
        directories++;
        if (onProgress != null && directories % _progressInterval == 0) {
          onProgress(directories, mediaFiles.length, funscriptFiles.length);
        }
        try {
          // The listing itself goes through the extended-length form of the
          // path (Windows only); children are rebuilt from the plain [dirPath]
          // so the `\\?\` prefix never leaves this loop.
          final entities = Directory(
            toExtendedLengthPath(dirPath),
          ).list(recursive: false, followLinks: false);

          await for (final entity in entities) {
            final name = p.basename(entity.path);
            final path = p.join(dirPath, name);

            if (entity is Directory) {
              pending.add(path);
            } else if (entity is File) {
              final extension = p.extension(name).toLowerCase();
              if (combinedExtension.contains(extension)) {
                mediaFiles.add(File(path));
              } else if (extension == funscriptExtension) {
                funscriptFiles.add(File(path));
              }
            }
          }
        } catch (e, st) {
          Logger.error('Failed to list directory: $dirPath', e, st);
          skippedPaths.add(dirPath);
        }
      }
    }
    onProgress?.call(directories, mediaFiles.length, funscriptFiles.length);
    return MediaScanListing(mediaFiles, funscriptFiles, skippedPaths);
  }

  /// How often the walk reports in, in directories.
  static const int _progressInterval = 50;
}
