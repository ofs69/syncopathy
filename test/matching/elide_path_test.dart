import 'package:flutter_test/flutter_test.dart';
import 'package:syncopathy/media_library/matching/funscript_matching_page.dart';

/// The path shown under each filename is what tells two near-identical files
/// apart, so how it shortens matters: the drive and the last few folders are
/// the informative parts, and the middle is what can go.
void main() {
  test('a short path is shown whole', () {
    expect(elidePath(r'Q:\Videos\scene.mp4'), r'Q:\Videos\scene.mp4');
  });

  test('a long Windows path keeps the root and the tail', () {
    expect(
      elidePath(r'Q:\Media\Library\2023\Studio\Series\scene.mp4'),
      r'Q:\…\Studio\Series\scene.mp4',
    );
  });

  test('a long POSIX path keeps its separators', () {
    expect(
      elidePath('/home/me/media/library/studio/series/scene.mp4'),
      '/…/studio/series/scene.mp4',
    );
  });

  test('the filename always survives', () {
    const path = r'C:\a\b\c\d\e\f\g\the-one-that-matters.funscript';
    expect(elidePath(path), endsWith('the-one-that-matters.funscript'));
  });

  test('a bare filename is left alone', () {
    expect(elidePath('scene.funscript'), 'scene.funscript');
  });

  test('separators are never turned into character splits', () {
    // A regression guard: splitting on an empty separator would explode the
    // path into single characters and render it as gibberish.
    expect(elidePath(r'Q:\a\b\c\d\e\f.mp4'), contains(r'\'));
    expect(elidePath(r'Q:\a\b\c\d\e\f.mp4'), isNot(contains('Q\\:')));
  });
}
