import 'package:flutter_test/flutter_test.dart';
import 'package:syncopathy/helper/trie.dart';

/// The Trie backs funscript<->media filename matching in the indexer
/// (`findLongestPrefix` is called per funscript basename against the media
/// filename trie). These tests pin the "longest media prefix wins" contract.
void main() {
  group('Trie.findLongestPrefix', () {
    test('returns null when no inserted word is a prefix', () {
      final t = Trie();
      t.insert('movie');
      expect(t.findLongestPrefix('other.funscript'), isNull);
    });

    test('matches an inserted word that is a prefix of the query', () {
      final t = Trie();
      t.insert('clip01');
      expect(t.findLongestPrefix('clip01.funscript'), 'clip01');
    });

    test('picks the LONGEST inserted prefix when several match', () {
      final t = Trie();
      t.insert('clip');
      t.insert('clip01');
      t.insert('clip01_scene');
      // Query shares the full 'clip01_scene' prefix, so that one wins over the
      // shorter 'clip' and 'clip01'.
      expect(t.findLongestPrefix('clip01_scene.funscript'), 'clip01_scene');
    });

    test('stops at the divergence point and returns the best match so far', () {
      final t = Trie();
      t.insert('clip');
      t.insert('clip01_alpha');
      // The query diverges after 'clip01_b', so the long alpha branch cannot
      // match; only the short 'clip' prefix does.
      expect(t.findLongestPrefix('clip01_beta.funscript'), 'clip');
    });

    test('an exact full-length match is returned', () {
      final t = Trie();
      t.insert('exact');
      expect(t.findLongestPrefix('exact'), 'exact');
    });

    test('a word longer than the query is not a prefix', () {
      final t = Trie();
      t.insert('clip01longname');
      expect(t.findLongestPrefix('clip01'), isNull);
    });

    test('empty query yields null', () {
      final t = Trie();
      t.insert('clip');
      expect(t.findLongestPrefix(''), isNull);
    });

    test('matching is case sensitive', () {
      final t = Trie();
      t.insert('Clip');
      expect(t.findLongestPrefix('clip.funscript'), isNull);
      expect(t.findLongestPrefix('Clip.funscript'), 'Clip');
    });
  });
}
