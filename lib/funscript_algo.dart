import 'dart:math';

import 'package:syncopathy/model/funscript.dart';

class FunscriptAlgorithms {
  // Applies slew to the actions limiting the amount of change per second based on maxRateOfChangePerSecond
  static List<FunscriptAction> slew(
    List<FunscriptAction> actions,
    double maxRateOfChangePerSecond,
  ) {
    if (actions.length < 2) {
      return actions;
    }

    List<FunscriptAction> slewActions = [actions.first];

    for (int i = 1; i < actions.length; i++) {
      final prevAction = slewActions.last;
      final currentAction = actions[i];

      final timeDiffMs = (currentAction.at - prevAction.at).toDouble();

      final maxChange =
          maxRateOfChangePerSecond *
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

  // Applies ramer douglas peucker algorithm to the actions using epsilon
  static List<FunscriptAction> rdp(
    List<FunscriptAction> actions,
    double epsilon,
  ) {
    if (actions.length < 2) {
      return actions;
    }

    // Find the point with the maximum distance
    double dmax = 0.0;
    int index = 0;
    int end = actions.length - 1;

    for (int i = 1; i < end; i++) {
      double d = _perpendicularDistance(actions[i], actions[0], actions[end]);
      if (d > dmax) {
        index = i;
        dmax = d;
      }
    }

    // If max distance is greater than epsilon, recursively simplify
    if (dmax > epsilon) {
      List<FunscriptAction> recResults1 = rdp(
        actions.sublist(0, index + 1),
        epsilon,
      );
      List<FunscriptAction> recResults2 = rdp(
        actions.sublist(index, end + 1),
        epsilon,
      );

      // Build the result list
      List<FunscriptAction> result = List.empty(growable: true);
      result.addAll(recResults1.sublist(0, recResults1.length - 1));
      result.addAll(recResults2);
      return result;
    } else {
      // If max distance is less than epsilon, remove all intermediate points
      return [actions[0], actions[end]];
    }
  }

  // Calculates the perpendicular distance from a point to a line segment
  static double _perpendicularDistance(
    FunscriptAction point,
    FunscriptAction lineStart,
    FunscriptAction lineEnd,
  ) {
    double x0 = point.at.toDouble();
    double y0 = point.pos.toDouble();
    double x1 = lineStart.at.toDouble();
    double y1 = lineStart.pos.toDouble();
    double x2 = lineEnd.at.toDouble();
    double y2 = lineEnd.pos.toDouble();

    double numerator = ((y2 - y1) * x0 - (x2 - x1) * y0 + x2 * y1 - y2 * x1)
        .abs();
    double denominator = sqrt(pow(y2 - y1, 2) + pow(x2 - x1, 2));

    if (denominator == 0) {
      return 0; // The line segment is a point, distance is 0
    }

    return numerator / denominator;
  }

  /// Calculates the average speed of the actions in position units per second.
  static double averageSpeed(List<FunscriptAction> actions) {
    if (actions.length < 2) {
      return 0.0;
    }

    double speedTotal = 0.0;
    int count = 0;
    for (int i = 1; i < actions.length; i++) {
      final from = actions[i - 1];
      final to = actions[i];
      final diff = (to.pos - from.pos).toDouble().abs();
      if (diff >= 10.0) {
        final speed = diff / (to.at - from.at);
        speedTotal += speed;
        count++;
      }
    }
    if (count == 0) {
      return 0.0;
    }
    var speed = (speedTotal / count) * 1000.0;
    return speed;
  }

  static double averageDepth(List<FunscriptAction> actions) {
    if (actions.length < 2) {
      return 0.0;
    }

    double depthTotal = 0.0;
    int count = 0;
    for (int i = 1; i < actions.length; i++) {
      final from = actions[i - 1];
      final to = actions[i];
      final diff = (to.pos - from.pos).toDouble().abs();
      if (diff >= 10.0) {
        depthTotal += diff;
        count++;
      }
    }
    if (count == 0) {
      return 0.0;
    }
    var depthAverage = depthTotal / count;
    return depthAverage;
  }

  static List<FunscriptAction> processForHandy(
    List<FunscriptAction> actions, {
    double? slewMaxRateOfChangePerSecond,
    double? rdpEpsilon,
    (int minRange, int maxRange)? remapRange,
  }) {
    if (actions.isEmpty) {
      return actions;
    }

    actions = List.from(actions);

    if (remapRange != null) {
      actions = FunscriptAlgorithms.remapRange(actions, remapRange);
    }

    if (slewMaxRateOfChangePerSecond != null) {
      actions = FunscriptAlgorithms.slew(actions, slewMaxRateOfChangePerSecond);
    }
    if (rdpEpsilon != null) {
      actions = FunscriptAlgorithms.rdp(actions, rdpEpsilon);
    }

    {
      // this padding is needed for the handy to function.
      // maybe there's a better solution
      // the code inserts reduntant points at a fixed interval

      // add padding
      if (actions.first.at != 0) {
        actions.insert(0, FunscriptAction(at: 0, pos: actions.first.pos));
      }

      const int intervalMs = 1500;
      int actionLen = actions.length;
      if (actionLen >= 2) {
        for (int i = 1; i < actionLen; i++) {
          var from = actions[i - 1];
          var to = actions[i];

          var diff = to.at - from.at;
          for (int x = 1; x < (diff / intervalMs); x++) {
            var time = from.at + x * intervalMs;
            var posRel = time / diff;
            var pos = (from.pos + (to.pos - from.pos) * posRel);

            var action = FunscriptAction(
              at: from.at + x * intervalMs,
              pos: pos.toInt().clamp(0, 100),
            );
            actions.add(action);
          }
        }
        actions.sort();
      }
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
}
