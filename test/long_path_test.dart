import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as p;
import 'package:syncopathy/helper/long_path.dart';

/// `toExtendedLengthPath` is what lets media indexing list directories whose
/// path is longer than Windows' MAX_PATH (260). Everything here is Windows-only
/// behaviour; on other platforms the function is required to be a no-op.
void main() {
  final windowsOnly = Platform.isWindows ? null : 'Windows-only behaviour';

  group('toExtendedLengthPath', () {
    test('leaves paths untouched off Windows', () {
      expect(toExtendedLengthPath('/home/user/media'), '/home/user/media');
    }, skip: Platform.isWindows ? 'POSIX-only behaviour' : null);

    test('prefixes a drive-absolute path', () {
      expect(toExtendedLengthPath(r'C:\media\clips'), r'\\?\C:\media\clips');
    }, skip: windowsOnly);

    test('normalizes separators and dot segments', () {
      expect(
        toExtendedLengthPath('C:/media/./sub/../clips'),
        r'\\?\C:\media\clips',
      );
    }, skip: windowsOnly);

    test('rewrites a UNC path to the UNC form', () {
      expect(
        toExtendedLengthPath(r'\\server\share\media'),
        r'\\?\UNC\server\share\media',
      );
    }, skip: windowsOnly);

    test('leaves an already prefixed path alone', () {
      expect(toExtendedLengthPath(r'\\?\C:\media'), r'\\?\C:\media');
      expect(toExtendedLengthPath(r'\\.\C:\media'), r'\\.\C:\media');
    }, skip: windowsOnly);

    test('leaves paths that are not fully qualified alone', () {
      // Extended-length paths are passed to the filesystem verbatim, so these
      // would not resolve if they were prefixed.
      expect(toExtendedLengthPath(r'media\clips'), r'media\clips');
      expect(toExtendedLengthPath(r'C:media'), r'C:media');
      expect(toExtendedLengthPath(r'\media'), r'\media');
    }, skip: windowsOnly);
  });

  group('listing beyond MAX_PATH', () {
    late Directory temp;

    setUp(() => temp = Directory.systemTemp.createTempSync('syncopathy_lp'));
    tearDown(() => temp.deleteSync(recursive: true));

    test('finds a file in a directory whose path exceeds MAX_PATH', () async {
      var deep = temp.path;
      while (deep.length < 280) {
        deep = p.join(deep, 'a' * 40);
      }
      Directory(deep).createSync(recursive: true);
      File(p.join(deep, 'clip.mp4')).writeAsStringSync('x');

      final listed = await Directory(
        toExtendedLengthPath(deep),
      ).list(recursive: false, followLinks: false).toList();

      expect(listed, hasLength(1));
      expect(p.basename(listed.single.path), 'clip.mp4');
    }, skip: windowsOnly);
  });
}
