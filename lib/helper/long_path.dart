import 'dart:io';

import 'package:path/path.dart' as p;

final _driveAbsolute = RegExp(r'^[A-Za-z]:\\');

/// Rewrites [path] into the Windows extended-length form (`\\?\C:\...`), which
/// is exempt from the 260 character `MAX_PATH` limit.
///
/// `dart:io`'s file APIs already use that form internally, but the directory
/// lister does not: it hands `<dir>\*` to `FindFirstFileW`, so listing a
/// directory whose own path is ~258 characters or longer fails with a
/// misleading "path not found" — even though every file inside it can still be
/// opened, hashed and handed to ffmpeg.
///
/// Use the result for the listing call only, and keep deriving paths from the
/// original string: entity paths that come back out of a prefixed call carry
/// the prefix, and it must not reach the database, the UI or a subprocess.
///
/// [path] is returned unchanged wherever the prefix does not apply or would not
/// resolve: on every non-Windows platform, and for paths that are already
/// prefixed or are not fully qualified — extended-length paths are passed to
/// the filesystem verbatim, so a relative or drive-relative one would break.
String toExtendedLengthPath(String path) {
  if (!Platform.isWindows) return path;
  if (path.startsWith(r'\\?\') || path.startsWith(r'\\.\')) return path;

  // The verbatim form skips all normalization, so it has to happen here: no
  // forward slashes, no `.` or `..` segments.
  final normalized = p.normalize(path).replaceAll('/', r'\');

  // \\server\share -> \\?\UNC\server\share
  if (normalized.startsWith(r'\\')) return r'\\?\UNC' + normalized.substring(1);

  if (!_driveAbsolute.hasMatch(normalized)) return path;
  return r'\\?\' + normalized;
}
