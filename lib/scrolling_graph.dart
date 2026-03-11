import 'dart:math';
import 'dart:ui';

import 'package:collection/collection.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:signals/signals_flutter.dart';
import 'package:syncopathy/model/funscript.dart';
import 'package:syncopathy/helper/constants.dart';
import 'package:syncopathy/model/player_model.dart';

/// A widget that wraps the [ScrollingGraph] with a slider to control the zoom level (view duration).
class InteractiveScrollingGraph extends StatefulWidget {
  final ReadonlySignal<MediaFunscript?> currentlyOpen;
  final ReadonlySignal<double> videoPosition;
  final Signal<Duration> viewDuration;

  const InteractiveScrollingGraph({
    super.key,
    required this.currentlyOpen,
    required this.videoPosition,
    required this.viewDuration,
  });

  @override
  State<InteractiveScrollingGraph> createState() =>
      _InteractiveScrollingGraphState();
}

class _InteractiveScrollingGraphState extends State<InteractiveScrollingGraph> {
  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerSignal: (event) {
        if (event is PointerScrollEvent) {
          final scrollValue = event.scrollDelta.dy > 0 ? 1.1 : 0.9;
          widget.viewDuration.value = Duration(
            milliseconds:
                (widget.viewDuration.value.inMilliseconds * scrollValue)
                    .round()
                    .clamp(1000, 10000),
          );
        }
      },
      child: ScrollingGraph(
        currentlyOpen: widget.currentlyOpen,
        videoPosition: widget.videoPosition,
        viewDuration: widget.viewDuration,
      ),
    );
  }
}

class ScrollingGraph extends StatefulWidget {
  final ReadonlySignal<MediaFunscript?> currentlyOpen;
  final ReadonlySignal<double> videoPosition;
  final Signal<Duration> viewDuration;

  const ScrollingGraph({
    super.key,
    required this.currentlyOpen,
    required this.videoPosition,
    required this.viewDuration,
  });

  @override
  State<ScrollingGraph> createState() => _ScrollingGraphState();
}

class _ScrollingGraphState extends State<ScrollingGraph> {
  late final ReadonlySignal<List<double>> speeds;

  @override
  void initState() {
    super.initState();

    speeds = computed(() {
      final funscript = widget.currentlyOpen.value?.funscript;
      if (funscript == null) return [];
      if (funscript.processedActions.value.length < 2) return [];

      final actions = funscript.processedActions.value;
      final speeds = <double>[];
      for (int i = 0; i < actions.length - 1; i++) {
        final p1 = actions[i];
        final p2 = actions[i + 1];
        final timeDiff = p2.at - p1.at;
        if (timeDiff > 0) {
          final posDiff = (p2.pos - p1.pos).abs();
          final speed = posDiff / timeDiff; // % per millisecond
          speeds.add(speed);
        } else {
          speeds.add(0.0);
        }
      }

      return speeds;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Watch.builder(
      builder: (context) {
        final position = widget.videoPosition.value;
        final viewDuration = widget.viewDuration.value;
        final funscript = widget.currentlyOpen.value?.funscript;
        final actions = funscript?.processedActions.value;
        return ClipRect(
          child: CustomPaint(
            painter: GraphPainter(
              actions: actions ?? [],
              videoPosition: Duration(milliseconds: (position * 1000).round()),
              viewDuration: viewDuration,
              theme: Theme.of(context),
              speeds: speeds.watch(context),
            ),
            size: Size.infinite,
          ),
        );
      },
    );
  }
}

// The custom painter that handles the drawing logic.
class GraphPainter extends CustomPainter {
  final List<FunscriptAction> actions;
  final Duration videoPosition;
  final Duration viewDuration;
  final ThemeData theme;
  final List<double> speeds;

  GraphPainter({
    required this.actions,
    required this.videoPosition,
    required this.viewDuration,
    required this.theme,
    required this.speeds,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // --- 1. Define Paints ---
    final linePaint = Paint()
      ..color = theme.colorScheme.primary
      ..strokeWidth = 5.0
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.square
      ..strokeJoin = StrokeJoin.bevel;

    final cursorPaint = Paint()
      ..color = theme.colorScheme.secondary
      ..strokeWidth = 4.0
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final pointPaint = Paint()
      ..color = theme.colorScheme.tertiary
      ..strokeWidth = 10.0
      ..style = PaintingStyle.fill
      ..strokeCap = StrokeCap.round;

    final currentPointPaint = Paint()
      ..color = theme.colorScheme.onSecondary
      ..strokeWidth = 6.0
      ..style = PaintingStyle.fill
      ..strokeCap = StrokeCap.round;

    final currentPointBackgroundPaint = Paint()
      ..color = theme.colorScheme.secondary
      ..strokeWidth = 10.0
      ..style = PaintingStyle.fill
      ..strokeCap = StrokeCap.round;

    const double customMargin = 8.0;

    Offset boundSize(Size size, double strokeWidth, double relX, double relY) {
      double x = (strokeWidth / 2.0) + (relX * (size.width - strokeWidth));
      double y =
          (strokeWidth / 2.0) +
          customMargin +
          (relY * (size.height - strokeWidth - (customMargin * 2.0)));
      return Offset(x, y);
    }

    // --- 2. Calculate Visible Window ---
    final halfViewMs = viewDuration.inMilliseconds / 2;
    final viewStart =
        videoPosition - Duration(milliseconds: halfViewMs.round());
    final viewEnd = videoPosition + Duration(milliseconds: halfViewMs.round());

    // --- 3. Calculate Speeds ---
    if (actions.length < 2) {
      // Not enough points to draw lines or calculate speed
      return;
    }
    
    // --- 4. Filter, Transform, and Draw Points ---
    // binary search for start and end indices
    final testStart = FunscriptAction(at: viewStart.inMilliseconds, pos: 0);
    final int start = max(lowerBound(actions, testStart) - 1, 0);
    final testEnd = FunscriptAction(at: viewEnd.inMilliseconds, pos: 0);
    final int end = min(lowerBound(actions, testEnd) + 1, actions.length);

    double currentY = 0.0;
    {
      final currentMs = videoPosition.inMilliseconds;
      final int current = max(
        lowerBound(actions, FunscriptAction(at: currentMs, pos: 0)) - 1,
        0,
      );

      final a1 = actions[current];
      final a2 = actions[current + 1];

      final inStrokeMs = currentMs - a1.at;
      final inStrokeRel = inStrokeMs / (a2.at - a1.at).toDouble();

      final a1Pos = (a1.pos / 100.0);
      final a2Pos = (a2.pos / 100.0);
      final depth = a2Pos - a1Pos;

      currentY = 1.0 - (a1Pos + (depth * inStrokeRel));
    }

    List<Offset> points = [];
    for (int i = start; i < end - 1; i++) {
      final a1 = actions[i];
      final a2 = actions[i + 1];

      double rx1 =
          (Duration(milliseconds: a1.at) - viewStart).inMilliseconds /
          viewDuration.inMilliseconds;
      double ry1 = 1.0 - (a1.pos / 100.0);
      double rx2 =
          (Duration(milliseconds: a2.at) - viewStart).inMilliseconds /
          viewDuration.inMilliseconds;
      double ry2 = 1.0 - (a2.pos / 100.0);

      // 1. Skip if the entire segment is off-screen horizontally
      if ((rx1 < 0 && rx2 < 0) || (rx1 > 1.0 && rx2 > 1.0)) {
        continue;
      }

      // 2. Clip Left (if rx1 is negative)
      bool rx1Cliped = false;
      if (rx1 < 0) {
        double t = (0.0 - rx1) / (rx2 - rx1);
        ry1 = ry1 + t * (ry2 - ry1);
        rx1 = 0.0;
        rx1Cliped = true;
      }

      // 3. Clip Right (if rx2 is greater than 1.0)
      bool rx2Cliped = false;
      if (rx2 > 1.0) {
        double t = (1.0 - rx1) / (rx2 - rx1);
        ry2 = ry1 + t * (ry2 - ry1);
        rx2 = 1.0;
        rx2Cliped = true;
      }

      final speed = speeds[i];
      final normalizedSpeed = min(speed / speedNormalizationValue, 1.0);

      final double colorPosition =
          normalizedSpeed * (heatmapGraphColors.length - 1);
      final int fromIndex = colorPosition.floor().clamp(
        0,
        heatmapGraphColors.length - 2,
      );
      final int toIndex = colorPosition.ceil().clamp(
        0,
        heatmapGraphColors.length - 1,
      );
      final double t = colorPosition - fromIndex;

      linePaint.color = Color.lerp(
        heatmapGraphColors[fromIndex],
        heatmapGraphColors[toIndex],
        t,
      )!;

      final p1 = boundSize(size, linePaint.strokeWidth * 2, rx1, ry1);
      final p2 = boundSize(size, linePaint.strokeWidth * 2, rx2, ry2);

      // round cap for the first and last line
      if (i == start || i == end - 2) {
        linePaint.strokeCap = StrokeCap.round;
      } else {
        linePaint.strokeCap = StrokeCap.square;
      }

      canvas.drawLine(p1, p2, linePaint);

      if (!rx1Cliped) points.add(p1);
      if (!rx2Cliped) points.add(p2);
    }

    // --- 5. Draw Cursor ---
    final cursorX = size.width / 2.0;
    canvas.drawLine(
      Offset(cursorX, cursorPaint.strokeWidth + (customMargin / 2.0)),
      Offset(
        cursorX,
        size.height - cursorPaint.strokeWidth - (customMargin / 2.0),
      ),
      cursorPaint,
    );
    canvas.drawPoints(PointMode.points, points, pointPaint);

    // current position point
    canvas.drawCircle(
      Offset(
        cursorX,
        (currentPointBackgroundPaint.strokeWidth) +
            (customMargin / 2.0) +
            currentY *
                (size.height -
                    (currentPointBackgroundPaint.strokeWidth * 2.0) -
                    (customMargin)),
      ),
      currentPointBackgroundPaint.strokeWidth,
      currentPointBackgroundPaint,
    );
    canvas.drawCircle(
      Offset(
        cursorX,
        (currentPointBackgroundPaint.strokeWidth) +
            (customMargin / 2.0) +
            currentY *
                (size.height -
                    (currentPointBackgroundPaint.strokeWidth * 2.0) -
                    (customMargin)),
      ),
      currentPointPaint.strokeWidth,
      currentPointPaint,
    );
  }

  @override
  bool shouldRepaint(covariant GraphPainter oldDelegate) {
    // Repaint whenever the video position or points change.
    return oldDelegate.videoPosition != videoPosition ||
        oldDelegate.actions != actions ||
        oldDelegate.viewDuration != viewDuration ||
        oldDelegate.speeds != speeds;
  }
}
