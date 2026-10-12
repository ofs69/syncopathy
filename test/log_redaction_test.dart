import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:syncopathy/logging.dart';

/// The user's library never belongs in a log: not as a message, and not inside
/// an exception that happens to carry a path.
void main() {
  test('redacts a Windows path, spaces and all', () {
    expect(
      redactPaths(r'Failed on Q:\My Videos\Some Title (2020).mp4'),
      'Failed on <path>',
    );
  });

  test('redacts a quoted path and keeps the text around it', () {
    final e = FileSystemException(
      'Cannot open file',
      r'C:\Users\someone\Videos\secret name.funscript',
      const OSError('The system cannot find the file specified', 2),
    );
    final redacted = redactPaths('$e');
    expect(redacted, isNot(contains('secret')));
    expect(redacted, contains("path = '<path>'"));
    expect(redacted, contains('cannot find the file'));
  });

  test('redacts forward-slash, UNC, file URI and home paths', () {
    for (final text in [
      'at C:/Users/someone/clip.mp4',
      r'at \\nas\share\clip.mp4',
      'at file:///C:/Users/someone/clip.mp4',
      'at /home/someone/clip.mp4',
      'at /Users/someone/clip.mp4',
    ]) {
      expect(redactPaths(text), 'at <path>', reason: text);
    }
  });

  test('leaves ordinary log text alone', () {
    for (final text in [
      'Handy is on HSP stream 4, expected 5; setting the stream up again',
      'Reconnect attempt 2 of 6',
      'RTD: 74\tOffset: 37.0',
      'HereSphere GET request failed',
      'ratio 3/4 and a/b',
    ]) {
      expect(redactPaths(text), text);
    }
  });

  test('a log entry redacts its message and its error', () {
    final entry = LogEntry(
      LogLevel.error,
      r'Failed to list D:\Private\folder',
      error: FileSystemException(
        'Directory listing failed',
        r'D:\Private\folder',
      ),
    );
    expect('$entry', isNot(contains('Private')));
  });
}
