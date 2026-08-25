import 'package:flutter_test/flutter_test.dart';
import 'package:syncopathy/persistence/entities/funscript_file.dart';

FunscriptFile _script(
  String path, {
  bool isScriptToken = false,
  bool fileNotFound = false,
}) {
  return FunscriptFile(
    path: path,
    averageSpeed: 100,
    averageMin: 0,
    averageMax: 100,
    isScriptToken: isScriptToken,
    fileNotFound: fileNotFound,
    funscriptHash: path,
  );
}

void main() {
  group('funscriptAxisRank', () {
    test('an unsuffixed script ranks best', () {
      expect(funscriptAxisRank(r'C:\media\clip.funscript'), 0);
      expect(funscriptAxisRank('/media/clip.funscript'), 0);
    });

    test('a suffix that is not an axis name stays a regular script', () {
      for (final path in [
        'clip.part2.funscript',
        'clip - extended.funscript',
        'clip_final.funscript',
      ]) {
        expect(funscriptAxisRank(path), 0, reason: path);
      }
    });

    test('an explicit stroke suffix ranks below an unsuffixed script', () {
      expect(funscriptAxisRank('clip.L0.funscript'), 1);
      expect(funscriptAxisRank('clip_stroke.funscript'), 1);
    });

    test('secondary axes rank last, in both naming conventions', () {
      for (final path in [
        'clip.twist.funscript',
        'clip.roll.funscript',
        'clip.pitch.funscript',
        'clip.sway.funscript',
        'clip.surge.funscript',
        'clip.suck.funscript',
        'clip.vib.funscript',
        'clip_R1.funscript',
        'clip.L2.funscript',
        'clip - V0.funscript',
      ]) {
        expect(funscriptAxisRank(path), 2, reason: path);
      }
    });

    test('axis matching ignores case', () {
      expect(funscriptAxisRank('clip.Twist.funscript'), 2);
      expect(funscriptAxisRank('clip.r0.FUNSCRIPT'), 2);
    });

    test('an axis word inside the name is not a suffix', () {
      expect(funscriptAxisRank('clip.twist.scene2.funscript'), 0);
      expect(funscriptAxisRank('rollercoaster.funscript'), 0);
    });
  });

  group('pickMainFunscript', () {
    test('returns null for no candidates', () {
      expect(pickMainFunscript(const []), isNull);
    });

    test('prefers the regular script over auxiliary axes', () {
      final twist = _script('clip.twist.funscript');
      final main = _script('clip.funscript');
      final roll = _script('clip.roll.funscript');

      expect(pickMainFunscript([twist, main, roll]), same(main));
      expect(pickMainFunscript([roll, twist, main]), same(main));
    });

    test('falls back to the stroke-suffixed script when there is no plain '
        'one', () {
      final twist = _script('clip.twist.funscript');
      final stroke = _script('clip.L0.funscript');

      expect(pickMainFunscript([twist, stroke]), same(stroke));
    });

    test('takes an auxiliary script when it is all there is', () {
      final twist = _script('clip.twist.funscript');
      expect(pickMainFunscript([twist]), same(twist));
    });

    test('a present auxiliary script beats a missing regular one', () {
      final missing = _script('clip.funscript', fileNotFound: true);
      final twist = _script('clip.twist.funscript');

      expect(pickMainFunscript([missing, twist]), same(twist));
    });

    test('a script token loses to a real script of the same rank', () {
      final token = _script('clip.funscript', isScriptToken: true);
      final real = _script('clip - extended.funscript');

      expect(pickMainFunscript([token, real]), same(real));
    });

    test('rank beats the token check: a plain token wins over a real '
        'auxiliary', () {
      final token = _script('clip.funscript', isScriptToken: true);
      final twist = _script('clip.twist.funscript');

      expect(pickMainFunscript([token, twist]), same(token));
    });

    test('ties keep the incoming order', () {
      final first = _script('clip.funscript');
      final second = _script('clip2.funscript');

      expect(pickMainFunscript([first, second]), same(first));
      expect(pickMainFunscript([second, first]), same(second));
    });
  });
}
