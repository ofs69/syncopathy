import 'package:flutter_test/flutter_test.dart';
import 'package:syncopathy/heresphere/byte_range.dart';

void main() {
  group('resolveRange', () {
    const length = 1000;

    test('no header serves the whole file', () {
      expect(resolveRange(null, length), const FullContent());
    });

    test('open-ended range runs to the last byte', () {
      expect(
        resolveRange('bytes=500-', length),
        const PartialContent(ByteRange(500, 999)),
      );
    });

    test('closed range is taken as given', () {
      expect(
        resolveRange('bytes=0-99', length),
        const PartialContent(ByteRange(0, 99)),
      );
    });

    test('a range starting at zero is not mistaken for a missing one', () {
      // The first request a player makes. It has to come back as 206, because
      // some clients only trust byte-range support they have actually seen.
      expect(
        resolveRange('bytes=0-', length),
        const PartialContent(ByteRange(0, 999)),
      );
    });

    test('an end past the file clamps instead of failing', () {
      expect(
        resolveRange('bytes=900-5000', length),
        const PartialContent(ByteRange(900, 999)),
      );
    });

    test('suffix range takes the last bytes', () {
      // How a player reads an MP4 moov atom stored at the end of the file.
      expect(
        resolveRange('bytes=-100', length),
        const PartialContent(ByteRange(900, 999)),
      );
    });

    test('a suffix longer than the file yields the whole file', () {
      expect(
        resolveRange('bytes=-5000', length),
        const PartialContent(ByteRange(0, 999)),
      );
    });

    test('a zero-length suffix is unsatisfiable', () {
      expect(resolveRange('bytes=-0', length), const UnsatisfiableRange());
    });

    test('a start at or past the end is unsatisfiable', () {
      expect(resolveRange('bytes=1000-', length), const UnsatisfiableRange());
      expect(
        resolveRange('bytes=1500-1600', length),
        const UnsatisfiableRange(),
      );
    });

    test('every range over an empty file is unsatisfiable', () {
      expect(resolveRange('bytes=0-', 0), const UnsatisfiableRange());
      expect(resolveRange('bytes=-10', 0), const UnsatisfiableRange());
    });

    test('the last byte alone is satisfiable', () {
      expect(
        resolveRange('bytes=999-999', length),
        const PartialContent(ByteRange(999, 999)),
      );
    });

    group('headers that must be ignored rather than rejected', () {
      // RFC 9110: a recipient that cannot honour a Range header ignores it,
      // which means serving the full representation — not a 416.
      final ignored = {
        'end before start': 'bytes=100-50',
        'unknown unit': 'items=0-10',
        'no dash': 'bytes=100',
        'not a number': 'bytes=abc-def',
        'signed offset': 'bytes=+10-20',
        'empty spec': 'bytes=',
        'multiple ranges': 'bytes=0-99,200-299',
        'garbage': 'nonsense',
      };
      ignored.forEach((name, header) {
        test(name, () {
          expect(resolveRange(header, length), const FullContent());
        });
      });
    });

    test('whitespace around the spec is tolerated', () {
      expect(
        resolveRange('bytes = 10 - 20 ', length),
        const PartialContent(ByteRange(10, 20)),
      );
    });

    test('the unit is matched case-insensitively', () {
      expect(
        resolveRange('Bytes=0-9', length),
        const PartialContent(ByteRange(0, 9)),
      );
    });

    test('length is inclusive of both ends', () {
      expect(const ByteRange(0, 99).length, 100);
      expect(const ByteRange(999, 999).length, 1);
    });
  });
}
