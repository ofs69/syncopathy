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
  static const int algorithmVersion = 8;

  // Most intermediate samples pchipSmooth may insert between two source points.
  static const int _pchipMaxIntermediatePoints = 5;
  // RDP tolerance (pos) used to thin the points smoothing inserts.
  static const double _postSmoothRdpEpsilon = 1.0;

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

  // Sub-threshold position jitter (< this many pos) does not break a stroke.
  // Many scripts ride fast jitter on top of a coarse stroke; splitting at every
  // micro-reversal would chop one fast move into a crowd of crawling strokes
  // and badly under-rate the motion. Real strokes are almost always >= 20 pos,
  // so a 10-pos floor merges only noise, not genuine strokes.
  static const int strokeMergeAmplitude = 10;

  /// Minimum rest-to-rest time (seconds) the device physically needs to move
  /// [dist] pos, given [acceleration] and [maxSpeed].
  static double kinematicMinTime(double dist) {
    if (dist <= 0) return 0.0;
    if (dist <= maxSpeed * maxSpeed / acceleration) {
      // Triangular: never reaches maxSpeed.
      return 2.0 * sqrt(dist / acceleration);
    }
    // Trapezoidal: ramp to maxSpeed, cruise, brake.
    return dist / maxSpeed + maxSpeed / acceleration;
  }

  /// Effective speed (pos/s) of a stroke that travels [dist] pos over commanded
  /// time [tCmd] (seconds) and then holds at its destination for [dwell]
  /// (seconds) before the next move.
  ///
  /// A trailing hold lets the device finish a move it could not complete in the
  /// commanded time — but only up to the device's own maximum for that distance;
  /// any hold beyond that is genuine rest and never dilutes the speed. A stroke
  /// already achievable within [tCmd] is unaffected by its dwell. This is what
  /// makes a "snap to position then hold" stroke read as the fast motion it is,
  /// instead of being mis-rated as physically impossible over the snap alone.
  static double dwellSpeed(double dist, double tCmd, double dwell) {
    final tMin = kinematicMinTime(dist);
    final window = tCmd + dwell;
    if (window >= tMin) {
      // The move completes: device runs at min(commanded, device-max) speed.
      final tEff = tCmd > tMin ? tCmd : tMin;
      if (tEff <= 0) return minSpeed;
      return (dist / tEff).clamp(minSpeed, maxSpeed);
    }
    // Even with the hold the device falls short of [dist]; use all it has.
    return strokeSpeed(dist, window);
  }

  /// Coarse-motion reversal points (pivots) of [sortedActions], with
  /// sub-[strokeMergeAmplitude] jitter merged away. Consecutive pivots alternate
  /// between local minima and maxima of the coarse motion. This is the shared
  /// segmentation behind [averageSpeed], [averageMin]/[averageMax] and the
  /// heatmap, so all of them describe the same strokes.
  ///
  /// [sortedActions] must be ascending by time. Each pivot carries its position,
  /// the arrival/departure timestamps of the node it sits on (so a hold at an
  /// extreme is kept separate from travel time), and the index of its first
  /// sample in [sortedActions] (so strokes map back to the action list).
  static List<({int pos, int arriveMs, int departMs, int actionIndex})> pivots(
    List<FunscriptAction> sortedActions,
  ) {
    // Collapse runs of equal position into nodes.
    final nodePos = <int>[];
    final nodeFirst = <int>[];
    final nodeLast = <int>[];
    final nodeIdx = <int>[];
    for (int i = 0; i < sortedActions.length; i++) {
      final a = sortedActions[i];
      if (nodePos.isNotEmpty && nodePos.last == a.pos) {
        nodeLast[nodeLast.length - 1] = a.at;
      } else {
        nodePos.add(a.pos);
        nodeFirst.add(a.at);
        nodeLast.add(a.at);
        nodeIdx.add(i);
      }
    }
    final int nodeCount = nodePos.length;
    final result = <({int pos, int arriveMs, int departMs, int actionIndex})>[];
    if (nodeCount < 2) return result;

    // Zigzag pivot detection: a direction reversal only closes a stroke when
    // the position retraces by at least [strokeMergeAmplitude]. Sub-threshold
    // jitter is absorbed into the coarse stroke, so a fast-but-jittery move is
    // measured as one fast stroke rather than many crawling micro-strokes.
    final pivotNodes = <int>[0];
    int last = 0;
    int ext = 0;
    int direction = 0; // 0 unknown, 1 up, -1 down
    for (int k = 1; k < nodeCount; k++) {
      final p = nodePos[k];
      if (direction == 0) {
        if ((p - nodePos[last]).abs() > (nodePos[ext] - nodePos[last]).abs()) {
          ext = k;
        }
        if ((p - nodePos[last]).abs() >= strokeMergeAmplitude) {
          direction = p > nodePos[last] ? 1 : -1;
          ext = k;
        }
      } else if (direction == 1) {
        if (p >= nodePos[ext]) {
          ext = k;
        } else if (nodePos[ext] - p >= strokeMergeAmplitude) {
          pivotNodes.add(ext);
          last = ext;
          direction = -1;
          ext = k;
        }
      } else {
        if (p <= nodePos[ext]) {
          ext = k;
        } else if (p - nodePos[ext] >= strokeMergeAmplitude) {
          pivotNodes.add(ext);
          last = ext;
          direction = 1;
          ext = k;
        }
      }
    }
    if (ext != pivotNodes.last) pivotNodes.add(ext);

    for (final n in pivotNodes) {
      result.add((
        pos: nodePos[n],
        arriveMs: nodeFirst[n],
        departMs: nodeLast[n],
        actionIndex: nodeIdx[n],
      ));
    }
    return result;
  }

  /// Segment [sortedActions] (ascending by time) into coarse dwell-aware
  /// strokes — the shared basis for the [averageSpeed] score and the heatmap
  /// colouring, so the two always agree. Each entry carries the stroke's
  /// dwell-aware [speed] (pos/s), the [distance] travelled (pos, used as the
  /// averaging weight) and the action-index span `[start, end)` it covers.
  ///
  /// One stroke runs from one extreme to the next; its commanded time excludes
  /// any hold at either end, and the trailing hold at the destination is
  /// credited only insofar as the move needed it to complete (see [dwellSpeed]).
  static List<({double speed, double distance, int start, int end})>
  strokeSegments(List<FunscriptAction> sortedActions) {
    final segments = <({double speed, double distance, int start, int end})>[];
    final pv = pivots(sortedActions);
    for (int j = 1; j < pv.length; j++) {
      final a = pv[j - 1];
      final b = pv[j];
      final tCmdMs = (b.arriveMs - a.departMs).toDouble(); // travel, ms
      final dist = (b.pos - a.pos).abs().toDouble();
      final dwellMs = (b.departMs - b.arriveMs).toDouble(); // hold, ms
      if (tCmdMs <= 0 || dist == 0) continue;
      final speed = dwellSpeed(dist, tCmdMs / 1000.0, dwellMs / 1000.0);
      segments.add((
        speed: speed,
        distance: dist,
        start: a.actionIndex,
        end: b.actionIndex,
      ));
    }
    return segments;
  }

  static double averageSpeed(List<FunscriptAction> actions) {
    if (actions.length < 2) {
      return 0.0;
    }

    // Sort actions by time; strip negative timestamps (invalid data).
    final sortedActions = actions.where((a) => a.at >= 0).toList()..sort();
    if (sortedActions.length < 2) return 0.0;

    final segments = strokeSegments(sortedActions);
    if (segments.isEmpty) return 0.0;

    // Weight each stroke by the distance it travels (pos units), NOT by its
    // duration. Time-weighting lets a single long idle drift (e.g. a 150s gap
    // covering 20 pos) swamp the score and pin it to minSpeed, even when the
    // actual strokes are fast. Distance-weighting measures the average speed
    // per unit of physical motion, so idle time — which covers little
    // distance — contributes negligibly. Speeds are already physically bounded
    // to [minSpeed, maxSpeed], so the robust mean only damps atypical strokes.
    return _robustWeightedMean([
      for (final s in segments) (value: s.speed, weight: s.distance),
    ]);
  }

  /// Distance-weighted mean of (value, weight) pairs with a loose 3.0x IQR
  /// fence that winsorizes — clamps, not drops — atypical values before
  /// averaging, so no sample is discarded. Quartiles are taken over the
  /// weighted distribution (consistent with the weighted mean) and need >= 4
  /// samples to mean anything; below that it is a plain weighted mean. Shared
  /// by [averageSpeed] and [averageMin]/[averageMax] so all three damp outliers
  /// identically. [items] must be non-empty with total weight > 0.
  static double _robustWeightedMean(
    List<({double value, double weight})> items,
  ) {
    final totalWeight = items.fold<double>(0, (a, s) => a + s.weight);
    if (items.length >= 4) {
      final sorted = [...items]..sort((a, b) => a.value.compareTo(b.value));
      final q1 = _weightedQuantile(sorted, totalWeight, 0.25);
      final q3 = _weightedQuantile(sorted, totalWeight, 0.75);
      final iqr = q3 - q1;
      final lower = q1 - 3.0 * iqr;
      final upper = q3 + 3.0 * iqr;

      double sum = 0;
      for (final s in items) {
        sum += s.value.clamp(lower, upper) * s.weight;
      }
      return sum / totalWeight;
    }

    double sum = 0;
    for (final s in items) {
      sum += s.value * s.weight;
    }
    return sum / totalWeight;
  }

  /// Quantile [q] (0..1) over a weighted distribution. [sorted] must be
  /// ascending by value.
  static double _weightedQuantile(
    List<({double value, double weight})> sorted,
    double totalWeight,
    double q,
  ) {
    final target = totalWeight * q;
    double cumulative = 0;
    for (final s in sorted) {
      cumulative += s.weight;
      if (cumulative >= target) return s.value;
    }
    return sorted.last.value;
  }

  /// Local extremes (valleys for [wantMin], peaks otherwise) of the coarse
  /// jitter-merged motion, each weighted by the depth of its adjacent stroke.
  static List<({double value, double weight})> _extremes(
    List<({int pos, int arriveMs, int departMs, int actionIndex})> pv,
    bool wantMin,
  ) {
    final out = <({double value, double weight})>[];
    // The prev/next lookups below reflect a pivot across its neighbours, which
    // requires at least two pivots; a lone pivot has no stroke to weigh.
    if (pv.length < 2) return out;
    for (int k = 0; k < pv.length; k++) {
      final p = pv[k].pos;
      final prev = k > 0 ? pv[k - 1].pos : pv[k + 1].pos;
      final next = k < pv.length - 1 ? pv[k + 1].pos : pv[k - 1].pos;
      final isExtreme = wantMin
          ? (p <= prev && p <= next)
          : (p >= prev && p >= next);
      if (isExtreme) {
        final w = max((p - prev).abs(), (p - next).abs()).toDouble();
        out.add((value: p.toDouble(), weight: w));
      }
    }
    return out;
  }

  static double averageMin(List<FunscriptAction> actions) =>
      _averageExtreme(actions, wantMin: true);

  static double averageMax(List<FunscriptAction> actions) =>
      _averageExtreme(actions, wantMin: false);

  /// Distance-weighted, winsorized average of the coarse motion's extremes —
  /// valleys for [wantMin], peaks otherwise — so micro-reversals mid-stroke and
  /// shallow mid-range filler don't pull the reported range in. Deep strokes
  /// define the range; a lone stray extreme is clamped by the fence (mirrors
  /// averageSpeed's robust weighting).
  static double _averageExtreme(
    List<FunscriptAction> actions, {
    required bool wantMin,
  }) {
    if (actions.isEmpty) return 0.0;
    final sorted = actions.where((a) => a.at >= 0).toList()..sort();
    if (sorted.isEmpty) return 0.0;

    final extremes = _extremes(pivots(sorted), wantMin);
    if (extremes.isEmpty) {
      final positions = sorted.map((a) => a.pos);
      return (wantMin ? positions.reduce(min) : positions.reduce(max))
          .toDouble();
    }
    return _robustWeightedMean(extremes);
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
      actions = FunscriptAlgorithms.pchipSmooth(
        actions,
        smoothIntervalMs,
        _pchipMaxIntermediatePoints,
      );
      // Thin out the points the smoothing just inserted.
      actions = FunscriptAlgorithms.rdp(actions, _postSmoothRdpEpsilon);
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
