import 'package:flutter_test/flutter_test.dart';
import 'package:syncopathy/model/json/funscript_json.dart';
import 'package:syncopathy/funscript_algo.dart';

/// Validates the dwell-aware + amplitude-merged speed metric and the
/// distance-weighted, winsorized min/max range metric. Expected values were
/// cross-checked against a Python reference over the full script library.
void main() {
  /// Build actions from (deltaMs, pos) steps.
  List<FunscriptAction> seq(List<List<int>> steps) {
    var t = 0;
    return steps.map((s) {
      t += s[0];
      return FunscriptAction(at: t, pos: s[1]);
    }).toList();
  }

  List<List<int>> repeat(List<List<int>> unit, int n) => [
    for (var i = 0; i < n; i++) ...unit,
  ];

  group('averageSpeed', () {
    test('clean fast full strokes (0<->100 every 250ms) -> ~400', () {
      final a = seq([
        [0, 0],
        ...repeat([
          [250, 100],
          [250, 0],
        ], 40),
      ]);
      expect(FunscriptAlgorithms.averageSpeed(a), closeTo(400.0, 1.0));
    });

    test('genuinely slow strokes (0<->100 every 1500ms) -> ~67', () {
      final a = seq([
        [0, 0],
        ...repeat([
          [1500, 100],
          [1500, 0],
        ], 20),
      ]);
      expect(FunscriptAlgorithms.averageSpeed(a), closeTo(66.667, 1.0));
    });

    test('snap-and-hold reads as fast, not impossible -> ~414', () {
      // 100 pos commanded in 67ms then held 1700ms: the device uses the hold to
      // complete the move, so it is fast — not the ~134 the snap alone implies.
      final a = seq([
        [0, 0],
        ...repeat([
          [67, 100],
          [1700, 100],
          [67, 0],
          [1700, 0],
        ], 20),
      ]);
      expect(FunscriptAlgorithms.averageSpeed(a), closeTo(413.793, 1.0));
    });

    test('fast jitter on a full-range stroke is not shattered -> ~120', () {
      // Sub-amplitude wiggle riding fast motion stays one coarse stroke.
      final a = seq([
        [0, 0],
        ...repeat([
          [60, 100],
          [60, 8],
          [60, 98],
          [60, 6],
        ], 40),
      ]);
      expect(FunscriptAlgorithms.averageSpeed(a), closeTo(120.0, 1.0));
    });

    test('fewer than two actions -> 0', () {
      expect(FunscriptAlgorithms.averageSpeed([]), 0.0);
      expect(
        FunscriptAlgorithms.averageSpeed([FunscriptAction(at: 0, pos: 50)]),
        0.0,
      );
    });
  });

  group('averageMin/averageMax', () {
    test('clean strokes report the true extremes', () {
      final a = seq([
        [0, 20],
        ...repeat([
          [250, 90],
          [250, 20],
        ], 8),
      ]);
      expect(FunscriptAlgorithms.averageMin(a), closeTo(20.0, 0.001));
      expect(FunscriptAlgorithms.averageMax(a), closeTo(90.0, 0.001));
    });

    test('sub-amplitude jitter does not compress the reported range', () {
      // A 10<->90 stroke carrying <10-pos wiggle at each extreme. The coarse
      // range is still 10..90; per-reversal splitting would report ~14..~86.
      final a = seq([
        [0, 10],
        ...repeat([
          [200, 90],
          [80, 84],
          [80, 90],
          [200, 10],
          [80, 16],
          [80, 10],
        ], 8),
      ]);
      expect(FunscriptAlgorithms.averageMin(a), closeTo(10.0, 0.001));
      expect(FunscriptAlgorithms.averageMax(a), closeTo(90.0, 0.001));
    });

    test('deep strokes define the range despite abundant shallow filler', () {
      // Four full 0<->100 strokes plus ten shallow 40<->60 wiggles. A plain
      // mean of the extremes would report ~[26.7, 71.4]; distance-weighting
      // lets the deep strokes dominate -> ~[11.4, 85.0].
      final a = seq([
        [0, 0],
        ...repeat([
          [250, 100],
          [250, 0],
        ], 4),
        ...repeat([
          [250, 60],
          [250, 40],
        ], 10),
      ]);
      expect(FunscriptAlgorithms.averageMin(a), closeTo(11.429, 0.01));
      expect(FunscriptAlgorithms.averageMax(a), closeTo(85.0, 0.01));
    });

    test('empty and single action', () {
      expect(FunscriptAlgorithms.averageMin([]), 0.0);
      expect(FunscriptAlgorithms.averageMax([]), 0.0);
      expect(
        FunscriptAlgorithms.averageMin([FunscriptAction(at: 0, pos: 42)]),
        42.0,
      );
      expect(
        FunscriptAlgorithms.averageMax([FunscriptAction(at: 0, pos: 42)]),
        42.0,
      );
    });
  });
}
