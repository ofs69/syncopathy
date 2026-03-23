import 'dart:math';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:syncopathy/model/funscript.dart';

class FunscriptAlgorithms {
  // Applies slew to the actions limiting the amount of change per second based on maxRateOfChangePerSecond
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

  static double averageSpeed(List<FunscriptAction> actions) {
    if (actions.length < 2) {
      return 0.0;
    }

    final List<({double speed, double weight})> segments = [];
    for (int i = 1; i < actions.length; i++) {
      final p1 = actions[i - 1];
      final p2 = actions[i];

      final timeDiff = (p2.at - p1.at).toDouble();
      if (timeDiff <= 0) continue;

      final posDiff = (p2.pos - p1.pos).abs().toDouble();

      final speed = posDiff / timeDiff * 1000; // pos per second
      segments.add((speed: speed, weight: timeDiff));
    }

    if (segments.isEmpty) {
      return 0.0;
    }

    // Outlier filtering using IQR.
    // We need at least 4 data points for this to be meaningful.
    if (segments.length < 4) {
      double totalSpeed = 0;
      double totalWeight = 0;
      for (final s in segments) {
        totalSpeed += s.speed * s.weight;
        totalWeight += s.weight;
      }
      return totalWeight > 0 ? totalSpeed / totalWeight : 0.0;
    }

    final sortedSpeeds = segments.map((s) => s.speed).toList()..sort();

    final q1Index = (sortedSpeeds.length * 0.25).round();
    final q3Index = (sortedSpeeds.length * 0.75).round();
    final q1 = sortedSpeeds[q1Index];
    final q3 = sortedSpeeds[q3Index];
    final iqr = q3 - q1;

    // Values outside of this range are considered outliers.
    final lowerBound = q1 - 1.5 * iqr;
    final upperBound = q3 + 1.5 * iqr;

    final filteredSegments = segments
        .where((s) => s.speed >= lowerBound && s.speed <= upperBound)
        .toList();

    // If all segments were filtered, it's better to return the unfiltered average.
    final segmentsToAverage = filteredSegments.isNotEmpty
        ? filteredSegments
        : segments;

    // Weighted average of filtered speeds
    double totalSpeed = 0;
    double totalWeight = 0;
    for (final s in segmentsToAverage) {
      totalSpeed += s.speed * s.weight;
      totalWeight += s.weight;
    }

    return totalWeight > 0 ? totalSpeed / totalWeight : 0.0;
  }

  static double averageMin(List<FunscriptAction> actions) {
    if (actions.length < 2) {
      if (actions.isEmpty) return 0.0;
      return actions.map((a) => a.pos).reduce(min).toDouble();
    }

    final mins = <double>[];
    int lastDir = 0;
    for (int i = 1; i < actions.length; i++) {
      final dir = (actions[i].pos - actions[i - 1].pos).sign;
      if (dir == 0) continue;

      if (dir == 1 && lastDir <= 0) {
        mins.add(actions[i - 1].pos.toDouble());
      }
      lastDir = dir;
    }

    if (lastDir == -1) {
      mins.add(actions.last.pos.toDouble());
    }

    if (mins.isEmpty) {
      return actions.map((a) => a.pos).reduce(min).toDouble();
    }

    return mins.reduce((a, b) => a + b) / mins.length;
  }

  static double averageMax(List<FunscriptAction> actions) {
    if (actions.length < 2) {
      if (actions.isEmpty) return 0.0;
      return actions.map((a) => a.pos).reduce(max).toDouble();
    }

    final maxes = <double>[];
    int lastDir = 0;
    for (int i = 1; i < actions.length; i++) {
      final dir = (actions[i].pos - actions[i - 1].pos).sign;
      if (dir == 0) continue;

      if (dir == -1 && lastDir >= 0) {
        maxes.add(actions[i - 1].pos.toDouble());
      }
      lastDir = dir;
    }

    if (lastDir == 1) {
      maxes.add(actions.last.pos.toDouble());
    }

    if (maxes.isEmpty) {
      return actions.map((a) => a.pos).reduce(max).toDouble();
    }

    return maxes.reduce((a, b) => a + b) / maxes.length;
  }

  static List<FunscriptAction> invert(List<FunscriptAction> actions) {
    return actions
        .map((e) => FunscriptAction(at: e.at, pos: 100 - e.pos))
        .toList();
  }

  static List<FunscriptAction> processForHandy(
    List<FunscriptAction> actions,
    double? slewMaxRateOfChangePerSecond,
    double? rdpEpsilon,
    (int minRange, int maxRange)? remapRange,
    bool invert,
    double totalDuration,
    double playbackSpeed,
    RangeValues strokeRange,
    int? smoothIntervalMs,
  ) {
    if (actions.isEmpty) {
      return actions;
    }

    actions = List.of(actions);

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
      actions = FunscriptAlgorithms.catmullRomSmooth(
        actions,
        smoothIntervalMs,
        5,
      );
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

  static List<FunscriptAction> catmullRomSmooth(
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

          double interpolatedPos = _catmullRom(
            p0.pos.toDouble(),
            p1.pos.toDouble(),
            p2.pos.toDouble(),
            p3.pos.toDouble(),
            t,
          );

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

  /// Standard Catmull-Rom Spline formula:
  /// 0.5 * ((2*P1) + (P2-P0)*t + (2*P0-5*P1+4*P2-P3)*t^2 + (-P0+3*P1-3*P2+P3)*t^3)
  static double _catmullRom(
    double p0,
    double p1,
    double p2,
    double p3,
    double t,
  ) {
    double t2 = t * t;
    double t3 = t2 * t;

    return 0.5 *
        ((2 * p1) +
            (-p0 + p2) * t +
            (2 * p0 - 5 * p1 + 4 * p2 - p3) * t2 +
            (-p0 + 3 * p1 - 3 * p2 + p3) * t3);
  }
}
