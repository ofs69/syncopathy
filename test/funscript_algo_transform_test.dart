import 'package:flutter/material.dart' show RangeValues;
import 'package:flutter_test/flutter_test.dart';
import 'package:syncopathy/funscript_algo.dart';
import 'package:syncopathy/model/json/funscript_json.dart';

/// Covers the pure funscript transforms that shape real device motion:
/// range remapping, inversion, intensity, slew rate limiting, RDP thinning,
/// first-stroke detection and the full [processForHandy] pipeline. These are
/// the transforms the refactor touched; locking them down guards against
/// silent behavioural drift in what gets sent to the hardware.
void main() {
  List<FunscriptAction> acts(List<List<int>> pairs) =>
      pairs.map((p) => FunscriptAction(at: p[0], pos: p[1])).toList();

  List<List<int>> dump(List<FunscriptAction> a) =>
      a.map((e) => [e.at, e.pos]).toList();

  group('remapRange', () {
    test('linearly maps the observed range onto the target range', () {
      final out = FunscriptAlgorithms.remapRange(
        acts([
          [0, 0],
          [100, 50],
          [200, 100],
        ]),
        (10, 90),
      );
      expect(dump(out), [
        [0, 10],
        [100, 50],
        [200, 90],
      ]);
    });

    test('maps a partial source range across the full target range', () {
      // Source spans 40..60; remapping to 0..100 stretches it to the extremes.
      final out = FunscriptAlgorithms.remapRange(
        acts([
          [0, 40],
          [100, 50],
          [200, 60],
        ]),
        (0, 100),
      );
      expect(dump(out), [
        [0, 0],
        [100, 50],
        [200, 100],
      ]);
    });

    test('constant input maps every point to the target midpoint', () {
      final out = FunscriptAlgorithms.remapRange(
        acts([
          [0, 40],
          [100, 40],
        ]),
        (10, 90),
      );
      // No range to normalise against -> midpoint (10 + 80/2) = 50.
      expect(dump(out), [
        [0, 50],
        [100, 50],
      ]);
    });

    test('empty input yields empty output', () {
      expect(FunscriptAlgorithms.remapRange([], (0, 100)), isEmpty);
    });
  });

  group('invert', () {
    test('mirrors position about 100 and leaves timestamps untouched', () {
      final out = FunscriptAlgorithms.invert(
        acts([
          [0, 0],
          [100, 30],
          [200, 100],
        ]),
      );
      expect(dump(out), [
        [0, 100],
        [100, 70],
        [200, 0],
      ]);
    });
  });

  group('intensity', () {
    test('factor of 1.0 is the identity', () {
      final input = acts([
        [0, 10],
        [500, 90],
        [1000, 20],
      ]);
      expect(dump(FunscriptAlgorithms.intensity(input, 1.0)), dump(input));
    });

    test('fewer than two actions is returned unchanged', () {
      final input = acts([
        [0, 42],
      ]);
      expect(dump(FunscriptAlgorithms.intensity(input, 2.0)), dump(input));
    });

    test('a constant signal is unchanged (no deviation to amplify)', () {
      final input = acts([
        [0, 50],
        [500, 50],
        [1000, 50],
      ]);
      expect(dump(FunscriptAlgorithms.intensity(input, 3.0)), dump(input));
    });

    test('amplified output stays clamped within 0..100', () {
      final input = acts([
        [0, 0],
        [200, 100],
        [400, 0],
        [600, 100],
      ]);
      final out = FunscriptAlgorithms.intensity(input, 5.0);
      for (final a in out) {
        expect(a.pos, inInclusiveRange(0, 100));
      }
    });
  });

  group('slew', () {
    test('caps a change that exceeds the max rate of change', () {
      // Full stroke range, 1x speed: maxChange = rate(50) * 1s = 50 pos.
      final out = FunscriptAlgorithms.slew(
        acts([
          [0, 0],
          [1000, 100],
        ]),
        50.0,
        1.0,
        const RangeValues(0, 100),
      );
      expect(dump(out), [
        [0, 0],
        [1000, 50],
      ]);
    });

    test('leaves a change within the rate limit untouched', () {
      final input = acts([
        [0, 0],
        [1000, 40],
      ]);
      final out = FunscriptAlgorithms.slew(
        input,
        50.0,
        1.0,
        const RangeValues(0, 100),
      );
      expect(dump(out), dump(input));
    });

    test('fewer than two actions returned unchanged', () {
      final input = acts([
        [0, 30],
      ]);
      expect(
        dump(FunscriptAlgorithms.slew(input, 10.0, 1.0, const RangeValues(0, 100))),
        dump(input),
      );
    });
  });

  group('rdp', () {
    test('fewer than three points are returned unchanged', () {
      final input = acts([
        [0, 0],
        [100, 100],
      ]);
      expect(dump(FunscriptAlgorithms.rdp(input, 1.0)), dump(input));
    });

    test('collinear midpoints are dropped', () {
      final out = FunscriptAlgorithms.rdp(
        acts([
          [0, 0],
          [1000, 50],
          [2000, 100],
        ]),
        1.0,
      );
      expect(dump(out), [
        [0, 0],
        [2000, 100],
      ]);
    });

    test('a peak far from the endpoint line is kept', () {
      final out = FunscriptAlgorithms.rdp(
        acts([
          [0, 0],
          [1000, 100],
          [2000, 0],
        ]),
        1.0,
      );
      expect(dump(out), [
        [0, 0],
        [1000, 100],
        [2000, 0],
      ]);
    });
  });

  group('findFirstStroke', () {
    test('returns the timestamp where position first changes', () {
      final at = FunscriptAlgorithms.findFirstStroke(
        acts([
          [0, 50],
          [100, 50],
          [200, 80],
        ]),
      );
      expect(at, 100);
    });

    test('all-flat script has no first stroke -> 0', () {
      final at = FunscriptAlgorithms.findFirstStroke(
        acts([
          [0, 50],
          [100, 50],
          [200, 50],
        ]),
      );
      expect(at, 0);
    });

    test('two or fewer actions -> 0', () {
      expect(
        FunscriptAlgorithms.findFirstStroke(acts([
          [0, 0],
          [100, 100],
        ])),
        0,
      );
    });
  });

  group('processForHandy', () {
    FunscriptProcessParams params(
      List<FunscriptAction> actions, {
      required double totalDuration,
    }) => FunscriptProcessParams(
      actions: actions,
      invert: false,
      totalDuration: totalDuration,
      playbackSpeed: 1.0,
      strokeRange: const RangeValues(0, 100),
    );

    test('empty input returns empty', () {
      expect(
        FunscriptAlgorithms.processForHandy(params([], totalDuration: 1.0)),
        isEmpty,
      );
    });

    test('inserts anchor points at 0 and at end for correct looping', () {
      final out = FunscriptAlgorithms.processForHandy(
        params(
          acts([
            [100, 20],
            [500, 80],
          ]),
          totalDuration: 1.0,
        ),
      );
      // end = 1000ms + 50ms padding = 1050. Front anchor mirrors first pos,
      // tail anchor mirrors last pos.
      expect(dump(out), [
        [0, 20],
        [100, 20],
        [500, 80],
        [1050, 80],
      ]);
    });

    test('drops actions beyond the video duration', () {
      final out = FunscriptAlgorithms.processForHandy(
        params(
          acts([
            [0, 0],
            [2000, 100],
          ]),
          totalDuration: 1.0,
        ),
      );
      // The 2000ms action is past end(1050) and removed; a tail anchor remains.
      expect(dump(out), [
        [0, 0],
        [1050, 100],
      ]);
    });

    test('strips negative timestamps', () {
      final out = FunscriptAlgorithms.processForHandy(
        params(
          acts([
            [-50, 10],
            [100, 40],
            [500, 60],
          ]),
          totalDuration: 1.0,
        ),
      );
      expect(out.any((a) => a.at < 0), isFalse);
      expect(out.first.at, 0);
    });

    test('applies inversion at the end of the pipeline', () {
      final out = FunscriptAlgorithms.processForHandy(
        FunscriptProcessParams(
          actions: acts([
            [0, 20],
            [500, 80],
          ]),
          invert: true,
          totalDuration: 0.5,
          playbackSpeed: 1.0,
          strokeRange: const RangeValues(0, 100),
        ),
      );
      // Positions mirrored about 100: 20->80, 80->20.
      expect(out.map((a) => a.pos), everyElement(anyOf(80, 20)));
      expect(out.first.pos, 80);
    });
  });

  group('kinematics helpers', () {
    test('kinematicMinTime is zero for no movement and grows with distance', () {
      expect(FunscriptAlgorithms.kinematicMinTime(0), 0.0);
      final small = FunscriptAlgorithms.kinematicMinTime(10);
      final large = FunscriptAlgorithms.kinematicMinTime(100);
      expect(small, greaterThan(0));
      expect(large, greaterThan(small));
    });

    test('strokeSpeed never exceeds the device max and floors at min', () {
      // A large distance in a tiny time is capped at the physical maximum.
      final fast = FunscriptAlgorithms.strokeSpeed(100, 0.05);
      expect(fast, lessThanOrEqualTo(FunscriptAlgorithms.maxSpeed));
      // A tiny distance over a long time is floored at the minimum sustainable.
      final slow = FunscriptAlgorithms.strokeSpeed(1, 5.0);
      expect(slow, FunscriptAlgorithms.minSpeed);
    });

    test('a trailing hold lets a snapped move read as fast, not impossible', () {
      // 100 pos snapped in 60ms then held ~1700ms: the hold completes the move.
      final withHold = FunscriptAlgorithms.dwellSpeed(100, 0.06, 1.7);
      final snapOnly = FunscriptAlgorithms.strokeSpeed(100, 0.06);
      expect(withHold, greaterThan(snapOnly));
      expect(withHold, lessThanOrEqualTo(FunscriptAlgorithms.maxSpeed));
    });
  });
}
