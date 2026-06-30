import 'dart:math';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:syncopathy/model/json/funscript_json.dart';

class FunscriptProcessParams {
  final List<FunscriptAction> actions;
  final double? slewMaxRateOfChangePerSecond;
  final double? rdpEpsilon;
  final (int minRange, int maxRange)? remapRange;
  final bool invert;
  final double totalDuration;
  final double playbackSpeed;
  final RangeValues strokeRange;
  final int? smoothIntervalMs;
  final double? intensity;

  FunscriptProcessParams({
    required this.actions,
    this.slewMaxRateOfChangePerSecond,
    this.rdpEpsilon,
    this.remapRange,
    required this.invert,
    required this.totalDuration,
    required this.playbackSpeed,
    required this.strokeRange,
    this.smoothIntervalMs,
    this.intensity,
  });
}

class FunscriptAlgorithms {
  // Bump when averageSpeed, averageMin, averageMax, or isScriptToken logic changes.
  // Existing DB entries with a lower version will be re-parsed on the next scan.
  static const int algorithmVersion = 6;

  static List<FunscriptAction> slew(
    List<FunscriptAction> actions,
    double maxRateOfChangePerSecond,
    double playbackSpeed,
    RangeValues strokeRange,
  ) {
    if (actions.length < 2) {
      return actions;
    }

    List<FunscriptAction> slewActions = [actions.first];

    for (int i = 1; i < actions.length; i++) {
      final prevAction = slewActions.last;
      final currentAction = actions[i];

      final timeDiffMs =
          (currentAction.at - prevAction.at).toDouble() / playbackSpeed;

      final maxChange =
          (maxRateOfChangePerSecond /
              ((strokeRange.start - strokeRange.end).abs() / 100.0)) *
          (timeDiffMs / 1000.0); // Max change in 'pos' for this time difference

      final actualChange = (currentAction.pos - prevAction.pos).toDouble();

      if (actualChange.abs() > maxChange) {
        // Slew is needed
        final newPos = prevAction.pos + (actualChange.sign * maxChange);
        slewActions.add(
          FunscriptAction(
            at: currentAction.at,
            pos: newPos.round().clamp(0, 100),
          ),
        );
      } else {
        // No slew needed, add the original action
        slewActions.add(currentAction);
      }
    }
    return slewActions;
  }

  static List<FunscriptAction> rdp(
    List<FunscriptAction> actions,
    double epsilon,
  ) {
    final int n = actions.length;
    if (n < 3) return actions;
    // final stopwatch = Stopwatch()..start();

    // 1. Flatten coordinates
    final Float64List coords = Float64List(n * 2);
    for (int i = 0; i < n; i++) {
      coords[i * 2] = actions[i].at.toDouble();
      coords[i * 2 + 1] = actions[i].pos.toDouble();
    }

    final double epsilonSq = epsilon * epsilon;
    final Uint8List keep = Uint8List(n);
    keep[0] = 1;
    keep[n - 1] = 1;

    // 2. Pre-allocate Uint32List stack
    // n * 4 is the safe theoretical limit for the iterative stack
    final Uint32List stack = Uint32List(n * 4);
    int stackPtr = 0;

    stack[stackPtr++] = 0;
    stack[stackPtr++] = n - 1;

    while (stackPtr > 0) {
      final int end = stack[--stackPtr];
      final int start = stack[--stackPtr];

      double dmaxSq = 0.0;
      int index = start;

      final double x1 = coords[start * 2];
      final double y1 = coords[start * 2 + 1];
      final double x2 = coords[end * 2];
      final double y2 = coords[end * 2 + 1];

      final double dx = x2 - x1;
      final double dy = y2 - y1;
      final double magSq = dx * dx + dy * dy;

      for (int i = start + 1; i < end; i++) {
        final double x0 = coords[i * 2];
        final double y0 = coords[i * 2 + 1];

        double dSq;
        if (magSq == 0) {
          dSq = (x0 - x1) * (x0 - x1) + (y0 - y1) * (y0 - y1);
        } else {
          final double num = (dy * x0 - dx * y0 + x2 * y1 - y2 * x1);
          dSq = (num * num) / magSq;
        }

        if (dSq > dmaxSq) {
          index = i;
          dmaxSq = dSq;
        }
      }

      if (dmaxSq > epsilonSq) {
        keep[index] = 1;
        stack[stackPtr++] = start;
        stack[stackPtr++] = index;
        stack[stackPtr++] = index;
        stack[stackPtr++] = end;
      }
    }

    final List<FunscriptAction> result = [];
    for (int i = 0; i < n; i++) {
      if (keep[i] == 1) result.add(actions[i]);
    }

    // stopwatch.stop();
    // debugPrint(
    //   'RDP processed $n points in ${stopwatch.elapsedMicroseconds}μs (${stopwatch.elapsedMilliseconds}ms). ',
    // );

    return result;
  }

  // Approximate Handy kinematic limits used to model real device motion.
  // The motor cannot move infinitely fast: it ramps up at `acceleration` and
  // tops out at `maxSpeed`. At every stroke reversal velocity must pass
  // through zero, so each stroke is modeled as a rest-to-rest accelerate /
  // (optionally cruise) / decelerate profile. It also cannot sustain
  // arbitrarily slow motion, so a stroke commanded slower than `minSpeed` is
  // really executed at `minSpeed`.
  static const acceleration = 8000.0; // pos/s²
  static const maxSpeed = 600.0; // pos/s
  static const minSpeed = 30.0; // pos/s — slowest motion the motor can sustain

  /// Effective average speed (pos/s) achievable over a single monotonic
  /// stroke of total distance [dist] (pos) and duration [tau] (seconds),
  /// starting and ending at rest. While the commanded motion is within reach
  /// the stroke is covered fully (speed == dist / tau); once the acceleration
  /// or top-speed limit is hit the device falls short and the speed is capped
  /// at what it can physically deliver. Slow commands are floored at
  /// [minSpeed], the slowest the hardware can actually move.
  static double strokeSpeed(double dist, double tau) {
    final double maxDist;
    if (tau <= 2 * maxSpeed / acceleration) {
      // Triangular profile: accelerate to a peak then brake; never reaches maxSpeed.
      maxDist = acceleration * tau * tau / 4.0;
    } else {
      // Trapezoidal profile: ramp to maxSpeed, cruise, then brake to rest.
      maxDist = maxSpeed * tau - maxSpeed * maxSpeed / acceleration;
    }
    final actualDist = dist < maxDist ? dist : maxDist;
    return (actualDist / tau).clamp(minSpeed, maxSpeed);
  }

  static double averageSpeed(List<FunscriptAction> actions) {
    if (actions.length < 2) {
      return 0.0;
    }

    // Sort actions by time; strip negative timestamps (invalid data).
    final sortedActions = actions.where((a) => a.at >= 0).toList()..sort();

    // Break the script into monotonic strokes delimited by direction
    // reversals and pauses. The device comes to rest at every reversal, so
    // each stroke is an independent rest-to-rest motion described purely by
    // its total distance and duration.
    final List<({double speed, double weight})> strokes = [];

    void addStroke(int startIdx, int endIdx) {
      if (endIdx <= startIdx) return;
      final p0 = sortedActions[startIdx];
      final pN = sortedActions[endIdx];
      final tauMs = (pN.at - p0.at).toDouble();
      if (tauMs <= 0) return;
      final dist = (pN.pos - p0.pos).abs().toDouble();
      if (dist == 0) return;
      // Weight each stroke by the distance it travels (pos units), NOT by its
      // duration. Time-weighting lets a single long idle drift (e.g. a 150s gap
      // covering 20 pos) swamp the score and pin it to minSpeed, even when the
      // actual strokes are fast. Distance-weighting measures the average speed
      // per unit of physical motion the device performs, so idle time — which
      // covers little distance — contributes negligibly and the score reflects
      // how fast the script actually moves.
      strokes.add((speed: strokeSpeed(dist, tauMs / 1000.0), weight: dist));
    }

    int runStart = 0;
    int runDir = 0;
    for (int i = 1; i < sortedActions.length; i++) {
      final diff = sortedActions[i].pos - sortedActions[i - 1].pos;
      final dir = diff == 0 ? 0 : (diff > 0 ? 1 : -1);

      if (dir == 0) {
        // Pause — close any open stroke; the flat section is rest.
        if (runDir != 0) addStroke(runStart, i - 1);
        runDir = 0;
        runStart = i;
      } else if (runDir == 0) {
        // Begin a new stroke at the previous point.
        runStart = i - 1;
        runDir = dir;
      } else if (dir != runDir) {
        // Reversal at point i-1 — close this stroke and start the next there.
        addStroke(runStart, i - 1);
        runStart = i - 1;
        runDir = dir;
      }
    }
    if (runDir != 0) addStroke(runStart, sortedActions.length - 1);

    if (strokes.isEmpty) {
      return 0.0;
    }

    final totalWeight = strokes.fold<double>(0, (a, s) => a + s.weight);
    if (totalWeight <= 0) return 0.0;

    // Robust distance-weighted mean. Speeds are already physically bounded to
    // [minSpeed, maxSpeed], so we only damp atypical strokes rather than hard
    // outliers. Quartiles are taken over the distance-weighted distribution
    // (consistent with the weighted mean), and a loose 3.0x IQR fence
    // winsorizes — clamps, not drops — extreme strokes so no motion is
    // discarded. Needs >= 4 strokes for the quartiles to mean anything.
    if (strokes.length >= 4) {
      final sorted = [...strokes]..sort((a, b) => a.speed.compareTo(b.speed));
      final q1 = _weightedQuantile(sorted, totalWeight, 0.25);
      final q3 = _weightedQuantile(sorted, totalWeight, 0.75);
      final iqr = q3 - q1;
      final lower = q1 - 3.0 * iqr;
      final upper = q3 + 3.0 * iqr;

      double sum = 0;
      for (final s in strokes) {
        sum += s.speed.clamp(lower, upper) * s.weight;
      }
      return sum / totalWeight;
    }

    double sum = 0;
    for (final s in strokes) {
      sum += s.speed * s.weight;
    }
    return sum / totalWeight;
  }

  /// Quantile [q] (0..1) over a weight (distance) distribution. [sorted] must
  /// be ascending by speed.
  static double _weightedQuantile(
    List<({double speed, double weight})> sorted,
    double totalWeight,
    double q,
  ) {
    final target = totalWeight * q;
    double cumulative = 0;
    for (final s in sorted) {
      cumulative += s.weight;
      if (cumulative >= target) return s.speed;
    }
    return sorted.last.speed;
  }

  static double averageMin(List<FunscriptAction> actions) {
    if (actions.length < 2) {
      if (actions.isEmpty) return 0.0;
      return actions.map((a) => a.pos).reduce(min).toDouble();
    }

    final sortedActions = List<FunscriptAction>.from(actions)..sort();
    final mins = <double>[];
    int lastDir = 0;
    for (int i = 1; i < sortedActions.length; i++) {
      final dir = (sortedActions[i].pos - sortedActions[i - 1].pos).sign;
      if (dir == 0) continue;

      if (dir == 1 && lastDir <= 0) {
        mins.add(sortedActions[i - 1].pos.toDouble());
      }
      lastDir = dir;
    }

    if (lastDir == -1) {
      mins.add(sortedActions.last.pos.toDouble());
    }

    if (mins.isEmpty) {
      return sortedActions.map((a) => a.pos).reduce(min).toDouble();
    }

    return mins.reduce((a, b) => a + b) / mins.length;
  }

  static double averageMax(List<FunscriptAction> actions) {
    if (actions.length < 2) {
      if (actions.isEmpty) return 0.0;
      return actions.map((a) => a.pos).reduce(max).toDouble();
    }

    final sortedActions = List<FunscriptAction>.from(actions)..sort();
    final maxes = <double>[];
    int lastDir = 0;
    for (int i = 1; i < sortedActions.length; i++) {
      final dir = (sortedActions[i].pos - sortedActions[i - 1].pos).sign;
      if (dir == 0) continue;

      if (dir == -1 && lastDir >= 0) {
        maxes.add(sortedActions[i - 1].pos.toDouble());
      }
      lastDir = dir;
    }

    if (lastDir == 1) {
      maxes.add(sortedActions.last.pos.toDouble());
    }

    if (maxes.isEmpty) {
      return sortedActions.map((a) => a.pos).reduce(max).toDouble();
    }

    return maxes.reduce((a, b) => a + b) / maxes.length;
  }

  static List<FunscriptAction> invert(List<FunscriptAction> actions) {
    return actions
        .map((e) => FunscriptAction(at: e.at, pos: 100 - e.pos))
        .toList();
  }

  static List<FunscriptAction> intensity(
    List<FunscriptAction> actions,
    double intensityFactor,
  ) {
    if (actions.length < 2 || intensityFactor == 1.0) {
      return actions;
    }

    final sortedActions = List<FunscriptAction>.from(actions)..sort();
    final int n = sortedActions.length;

    // Use a centered moving average to find the local baseline.
    // A 2-second window (1000ms before, 1000ms after) is good for separating
    // stroke oscillations from baseline shifts.
    const int halfWindowMs = 1000;

    final List<double> baselines = List.filled(n, 0.0);
    double sum = 0;
    int left = 0;
    int right = 0;

    for (int i = 0; i < n; i++) {
      final t = sortedActions[i].at;
      while (right < n && sortedActions[right].at <= t + halfWindowMs) {
        sum += sortedActions[right].pos;
        right++;
      }
      while (left < n && sortedActions[left].at < t - halfWindowMs) {
        sum -= sortedActions[left].pos;
        left++;
      }
      // Safety check: right - left should always be >= 1 because sortedActions[i] is in the window.
      baselines[i] = sum / (right - left);
    }

    return List.generate(n, (i) {
      final a = sortedActions[i];
      final b = baselines[i];
      final newPos = b + (a.pos - b) * intensityFactor;
      return FunscriptAction(at: a.at, pos: newPos.round().clamp(0, 100));
    });
  }

  static List<FunscriptAction> processForHandy(FunscriptProcessParams params) {
    var actions = params.actions;
    final totalDuration = params.totalDuration;
    final remapRange = params.remapRange;
    final slewMaxRateOfChangePerSecond = params.slewMaxRateOfChangePerSecond;
    final playbackSpeed = params.playbackSpeed;
    final strokeRange = params.strokeRange;
    final rdpEpsilon = params.rdpEpsilon;
    final smoothIntervalMs = params.smoothIntervalMs;
    final invert = params.invert;
    final intensity = params.intensity;

    if (actions.isEmpty) {
      return actions;
    }

    actions = List.of(actions);
    actions.removeWhere((a) => a.at < 0);

    // Insert point at 0
    // Important for looping correctly
    if (actions.first.at != 0) {
      actions.insert(0, FunscriptAction(at: 0, pos: actions.first.pos));
    }
    // Insert point at end of video
    // Important for looping correctly
    final end = (totalDuration * 1000.0).round() + 50; // +50ms extra
    if (actions.last.at != end) {
      actions.add(FunscriptAction(at: end, pos: actions.last.pos));
    }
    // remove anything beyond the video duration
    actions.removeWhere((a) => a.at > end);

    if (remapRange != null) {
      actions = FunscriptAlgorithms.remapRange(actions, remapRange);
    }

    if (intensity != null && intensity != 1.0) {
      actions = FunscriptAlgorithms.intensity(actions, intensity);
    }

    if (slewMaxRateOfChangePerSecond != null) {
      actions = FunscriptAlgorithms.slew(
        actions,
        slewMaxRateOfChangePerSecond,
        playbackSpeed,
        strokeRange,
      );
    }

    if (rdpEpsilon != null) {
      actions = FunscriptAlgorithms.rdp(actions, rdpEpsilon);
    }

    if (smoothIntervalMs != null) {
      actions = FunscriptAlgorithms.pchipSmooth(actions, smoothIntervalMs, 5);
      // apply rdp again with epsilon 1.0
      actions = FunscriptAlgorithms.rdp(actions, 1.0);
    }

    if (invert) {
      actions = FunscriptAlgorithms.invert(actions);
    }

    return actions;
  }

  static List<FunscriptAction> remapRange(
    List<FunscriptAction> actions,
    (int, int) remapRange,
  ) {
    if (actions.isEmpty) {
      return [];
    }

    final positions = actions.map((a) => a.pos);
    final double currentMin = positions.reduce(min).toDouble();
    final double currentMax = positions.reduce(max).toDouble();

    final double remapMin = remapRange.$1.toDouble();
    final double remapMax = remapRange.$2.toDouble();

    final double currentRange = currentMax - currentMin;
    final double remapRangeSize = remapMax - remapMin;

    // Handle the edge case where all actions have the same position.
    // This avoids division by zero and maps all points to the new midpoint.
    if (currentRange == 0) {
      final int middlePosition = (remapMin + remapRangeSize / 2).round();
      return actions
          .map((action) => FunscriptAction(at: action.at, pos: middlePosition))
          .toList();
    }

    // Create a new list with remapped `pos` values.
    return actions.map((action) {
      // 1. Normalize the current position to a value between 0.0 and 1.0.
      final double normalizedValue =
          (action.pos.toDouble() - currentMin) / currentRange;

      // 2. Scale the normalized value to the new range and round to the nearest integer.
      final int newPos = (remapMin + (normalizedValue * remapRangeSize))
          .round();

      // 3. Create a new FunscriptAction with the remapped position.
      return FunscriptAction(at: action.at, pos: newPos);
    }).toList();
  }

  static int findFirstStroke(List<FunscriptAction> actions) {
    if (actions.length <= 2) {
      return 0;
    }

    for (int i = 1; i < actions.length; i++) {
      final from = actions[i - 1];
      final to = actions[i];

      if (from.pos != to.pos) {
        return from.at;
      }
    }
    return 0;
  }

  static List<FunscriptAction> pchipSmooth(
    List<FunscriptAction> actions,
    int minIntervalMs,
    int maxIntermediatePoints,
  ) {
    if (actions.length < 2) return List.from(actions);

    List<FunscriptAction> smoothed = [];

    for (int i = 0; i < actions.length - 1; i++) {
      final p1 = actions[i];
      final p2 = actions[i + 1];
      final p0 = (i == 0) ? p1 : actions[i - 1];
      final p3 = (i + 2 >= actions.length) ? p2 : actions[i + 2];

      smoothed.add(p1);

      int duration = p2.at - p1.at;

      // 1. Determine how many points we CAN fit based on minIntervalMs
      int absoluteMaxPossible = (duration / minIntervalMs).floor() - 1;
      if (absoluteMaxPossible < 0) absoluteMaxPossible = 0;

      // 2. Take the lesser of your preferred max points and the absolute hardware max
      int pointsToInsert = maxIntermediatePoints < absoluteMaxPossible
          ? maxIntermediatePoints
          : absoluteMaxPossible;

      if (pointsToInsert > 0) {
        // Calculate the time step for even spacing
        // We divide by (pointsToInsert + 1) to get the gaps between points
        double stepSize = duration / (pointsToInsert + 1);

        for (int j = 1; j <= pointsToInsert; j++) {
          int currentTime = p1.at + (stepSize * j).round();
          double t = (currentTime - p1.at) / duration;

          double interpolatedPos = _pchip(p0, p1, p2, p3, t);

          smoothed.add(
            FunscriptAction(
              at: currentTime,
              pos: interpolatedPos.clamp(0, 100).round(),
            ),
          );
        }
      }
    }

    smoothed.add(actions.last);
    return smoothed;
  }

  static double _pchip(
    FunscriptAction p0,
    FunscriptAction p1,
    FunscriptAction p2,
    FunscriptAction p3,
    double t,
  ) {
    double h0 = (p1.at - p0.at).toDouble();
    double h1 = (p2.at - p1.at).toDouble();
    double h2 = (p3.at - p2.at).toDouble();

    double d0 = h0 > 0 ? (p1.pos - p0.pos) / h0 : 0.0;
    double d1 = h1 > 0 ? (p2.pos - p1.pos) / h1 : 0.0;
    double d2 = h2 > 0 ? (p3.pos - p2.pos) / h2 : 0.0;

    double m1;
    if (h0 == 0) {
      m1 = d1;
    } else if (d0 * d1 <= 0) {
      m1 = 0;
    } else {
      double w1 = 2 * h1 + h0;
      double w2 = h1 + 2 * h0;
      m1 = (w1 + w2) / (w1 / d0 + w2 / d1);
    }

    double m2;
    if (h2 == 0) {
      m2 = d1;
    } else if (d1 * d2 <= 0) {
      m2 = 0;
    } else {
      double w1 = 2 * h2 + h1;
      double w2 = h2 + 2 * h1;
      m2 = (w1 + w2) / (w1 / d1 + w2 / d2);
    }

    double t2 = t * t;
    double t3 = t2 * t;

    double h00 = 2 * t3 - 3 * t2 + 1;
    double h10 = t3 - 2 * t2 + t;
    double h01 = -2 * t3 + 3 * t2;
    double h11 = t3 - t2;

    return h00 * p1.pos + h10 * h1 * m1 + h01 * p2.pos + h11 * h1 * m2;
  }
}
