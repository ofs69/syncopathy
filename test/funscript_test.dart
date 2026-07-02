import 'package:flutter_test/flutter_test.dart';
import 'package:syncopathy/model/funscript.dart';
import 'package:syncopathy/model/json/funscript_json.dart';

/// Covers the [Funscript] wrapper's construction-time behaviour: timestamp
/// deduplication, script-token detection and the binary-search action lookup.
void main() {
  Funscript build(List<FunscriptAction> actions) =>
      Funscript(json: FunscriptJson(actions: actions), filePath: 'test.funscript');

  group('deduplication', () {
    test('keeps the first action for each timestamp and drops later dupes', () {
      final fs = build([
        FunscriptAction(at: 0, pos: 0),
        FunscriptAction(at: 0, pos: 50),
        FunscriptAction(at: 100, pos: 100),
        FunscriptAction(at: 100, pos: 40),
        FunscriptAction(at: 200, pos: 20),
      ]);
      expect(
        fs.originalActions.map((a) => [a.at, a.pos]).toList(),
        [
          [0, 0],
          [100, 100],
          [200, 20],
        ],
      );
    });

    test('originalActions is unmodifiable', () {
      final fs = build([FunscriptAction(at: 0, pos: 0)]);
      expect(
        () => fs.originalActions.add(FunscriptAction(at: 1, pos: 1)),
        throwsUnsupportedError,
      );
    });
  });

  group('isScriptToken', () {
    test('empty action list is never a token', () {
      expect(Funscript.isScriptToken([]), isFalse);
    });

    test('more than 100 actions is never a token', () {
      final many = List.generate(101, (i) => FunscriptAction(at: i, pos: 0));
      expect(Funscript.isScriptToken(many), isFalse);
    });

    test('token marker (pos 0 at magic % length) is detected', () {
      // length 1 -> magic % 1 == 0, so a single (at:0, pos:0) is the marker.
      expect(
        Funscript.isScriptToken([FunscriptAction(at: 0, pos: 0)]),
        isTrue,
      );
    });

    test('ordinary script without the marker is not a token', () {
      expect(
        Funscript.isScriptToken([
          FunscriptAction(at: 0, pos: 50),
          FunscriptAction(at: 100, pos: 80),
        ]),
        isFalse,
      );
    });

    test('likelyScriptToken is computed on construction', () {
      final token = build([FunscriptAction(at: 0, pos: 0)]);
      expect(token.likelyScriptToken, isTrue);

      final normal = build([
        FunscriptAction(at: 0, pos: 50),
        FunscriptAction(at: 100, pos: 80),
      ]);
      expect(normal.likelyScriptToken, isFalse);
    });
  });

  group('getActionBefore', () {
    final actions = [
      FunscriptAction(at: 0, pos: 0),
      FunscriptAction(at: 100, pos: 100),
      FunscriptAction(at: 200, pos: 0),
    ];

    test('an exact timestamp returns its own index', () {
      expect(Funscript.getActionBefore(100, actions), 1);
    });

    test('past the last action clamps to the final index', () {
      expect(Funscript.getActionBefore(500, actions), 2);
    });
  });
}
