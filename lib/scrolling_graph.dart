import 'dart:math';
import 'dart:ui';

import 'package:collection/collection.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:signals/signals_flutter.dart';
import 'package:syncopathy/helper/buffer_list.dart';
import 'package:syncopathy/funscript_algo.dart';
import 'package:syncopathy/model/json/funscript_json.dart';
import 'package:syncopathy/helper/constants.dart';
import 'package:syncopathy/model/player_model.dart';

class ScrollingGraph extends StatefulWidget {
  final ReadonlySignal<MediaFunscript?> currentlyOpen;
  final ReadonlySignal<double> videoPosition;
  final ReadonlySignal<double> playbackRate;
  final ReadonlySignal<RangeValues> strokeRange;
  final Signal<Duration> viewDuration;

  const ScrollingGraph({
    super.key,
    required this.currentlyOpen,
    required this.videoPosition,
    required this.viewDuration,
    required this.playbackRate,
    required this.strokeRange,
  });

  @override
  State<ScrollingGraph> createState() => _ScrollingGraphState();
}

class _ScrollingGraphState extends State<ScrollingGraph> {
  late final ReadonlySignal<List<double>> speeds;
  // minor optimization to not have this buffer be allocated by the _GraphPainter and GC'd
  final BufferList<Offset> pointBuffer = BufferList(initialValue: Offset(0, 0));
  // Paints are reused across repaints; only their theme-derived colors are
  // refreshed on build, so the painter no longer re-allocates five Paints per
  // frame while the cursor scrolls.
  final _GraphPaints _paints = _GraphPaints();

  @override
  void initState() {
    super.initState();

    speeds = computed(() {
      final funscript = widget.currentlyOpen.value?.funscript;
      final playbackSpeed = widget.playbackRate.value;
      final strokeRange = widget.strokeRange.value;

      if (funscript == null) return [];
      if (funscript.processedActions.value.length < 2) return [];

      final actions = funscript.processedActions.value;

      // Colour each segment by the same dwell-aware, jitter-merged stroke speed
      // as FunscriptAlgorithms.averageSpeed and the heatmap, so the graph, the
      // heatmap and the speed metric always agree. Each coarse stroke's speed is
      // assigned to every action pair it spans. Output unit: remapped pos/ms;
      // playbackSpeed scales it linearly.
      final remapScale = (strokeRange.end - strokeRange.start) / 100.0;
      final speeds = List<double>.filled(actions.length - 1, 0.0);
      for (final s in FunscriptAlgorithms.strokeSegments(actions)) {
        final speed = s.speed * playbackSpeed * remapScale / 1000.0;
        for (int k = s.start; k < s.end; k++) {
          speeds[k] = speed;
        }
      }

      return speeds;
    });
  }

  static const int _minViewMs = 1000;
  static const int _maxViewMs = 10000;

  /// Scale the visible time window by [factor] (>1 zooms out, <1 zooms in),
  /// clamped. Shared by the scroll wheel and the on-screen zoom buttons so the
  /// gesture-free path stays in lockstep with the wheel.
  void _zoom(double factor) {
    widget.viewDuration.value = Duration(
      milliseconds: (widget.viewDuration.value.inMilliseconds * factor)
          .round()
          .clamp(_minViewMs, _maxViewMs),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerSignal: (event) {
        if (event is PointerScrollEvent) {
          _zoom(event.scrollDelta.dy > 0 ? 1.1 : 0.9);
        }
      },
      child: Watch.builder(
        builder: (context) {
          final position = widget.videoPosition.value;
          final viewDuration = widget.viewDuration.value;
          final funscript = widget.currentlyOpen.value?.funscript;
          final actions = funscript?.processedActions.value;
          _paints.updateColors(Theme.of(context));
          return ClipRect(
            child: CustomPaint(
              painter: _GraphPainter(
                actions: actions ?? [],
                videoPosition: Duration(
                  milliseconds: (position * 1000).round(),
                ),
                viewDuration: viewDuration,
                speeds: speeds.watch(context),
                pointBuffer: pointBuffer,
                paints: _paints,
              ),
              size: Size.infinite,
            ),
          );
        },
      ),
    );
  }
}

/// The five Paints the graph draws with. Their static properties are set once;
/// only the theme-derived colors change (via [updateColors]) when the theme
/// changes, so no Paint is allocated per frame.
class _GraphPaints {
  final Paint line = Paint()
    ..strokeWidth = 5.0
    ..style = PaintingStyle.stroke
    ..strokeCap = StrokeCap.square
    ..strokeJoin = StrokeJoin.bevel;

  final Paint cursor = Paint()
    ..strokeWidth = 4.0
    ..style = PaintingStyle.stroke
    ..strokeCap = StrokeCap.round;

  final Paint point = Paint()
    ..strokeWidth = 10.0
    ..style = PaintingStyle.fill
    ..strokeCap = StrokeCap.round;

  final Paint currentPoint = Paint()
    ..strokeWidth = 6.0
    ..style = PaintingStyle.fill
    ..strokeCap = StrokeCap.round;

  final Paint currentPointBackground = Paint()
    ..strokeWidth = 10.0
    ..style = PaintingStyle.fill
    ..strokeCap = StrokeCap.round;

  void updateColors(ThemeData theme) {
    line.color = theme.colorScheme.primary;
    cursor.color = theme.colorScheme.secondary;
    point.color = theme.colorScheme.tertiary;
    currentPoint.color = theme.colorScheme.onSecondary;
    currentPointBackground.color = theme.colorScheme.secondary;
  }
}

// The custom painter that handles the drawing logic.
class _GraphPainter extends CustomPainter {
  final List<FunscriptAction> actions;
  final Duration videoPosition;
  final Duration viewDuration;
  final List<double> speeds;
  final BufferList<Offset> pointBuffer;
  final _GraphPaints paints;

  _GraphPainter({
    required this.actions,
    required this.videoPosition,
    required this.viewDuration,
    required this.speeds,
    required this.pointBuffer,
    required this.paints,
  });

  static const double customMargin = 8.0;

  static Offset boundSize(
    Size size,
    double strokeWidth,
    double relX,
    double relY,
  ) {
    double x = (strokeWidth / 2.0) + (relX * (size.width - strokeWidth));
    double y =
        (strokeWidth / 2.0) +
        customMargin +
        (relY * (size.height - strokeWidth - (customMargin * 2.0)));
    return Offset(x, y);
  }

  @override
  void paint(Canvas canvas, Size size) {
    if (actions.length < 2) {
      // Not enough points to draw lines or calculate speed
      return;
    }

    // --- Calculate visible window (plain int ms; no Duration allocations) ---
    final int viewDurationMs = viewDuration.inMilliseconds;
    final int positionMs = videoPosition.inMilliseconds;
    final int halfViewMs = (viewDurationMs / 2).round();
    final int viewStartMs = positionMs - halfViewMs;
    final int viewEndMs = positionMs + halfViewMs;

    // Binary search for the first/last action pairs touching the window.
    final int start = max(
      lowerBound(actions, FunscriptAction(at: viewStartMs, pos: 0)) - 1,
      0,
    );
    final int end = min(
      lowerBound(actions, FunscriptAction(at: viewEndMs, pos: 0)) + 1,
      actions.length,
    );

    final double currentY = _computeCurrentY(positionMs);

    _drawSegments(canvas, size, start, end, viewStartMs, viewDurationMs);
    _drawCursorAndPoints(canvas, size, currentY);
  }

  /// Interpolated vertical position (0..1, inverted) of the cursor at [currentMs].
  double _computeCurrentY(int currentMs) {
    final int current = max(
      lowerBound(actions, FunscriptAction(at: currentMs, pos: 0)) - 1,
      0,
    );
    if (current + 1 >= actions.length) return 0.0;

    final a1 = actions[current];
    final a2 = actions[current + 1];

    final inStrokeMs = currentMs - a1.at;
    final inStrokeRel = inStrokeMs / (a2.at - a1.at).toDouble();

    final a1Pos = a1.pos / 100.0;
    final a2Pos = a2.pos / 100.0;
    final depth = a2Pos - a1Pos;

    return 1.0 - (a1Pos + (depth * inStrokeRel));
  }

  void _drawSegments(
    Canvas canvas,
    Size size,
    int start,
    int end,
    int viewStartMs,
    int viewDurationMs,
  ) {
    final linePaint = paints.line;
    pointBuffer.clear();
    for (int i = start; i < end - 1; i++) {
      final a1 = actions[i];
      final a2 = actions[i + 1];

      double rx1 = (a1.at - viewStartMs) / viewDurationMs;
      double ry1 = 1.0 - (a1.pos / 100.0);
      double rx2 = (a2.at - viewStartMs) / viewDurationMs;
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
      linePaint.strokeCap = (i == start || i == end - 2)
          ? StrokeCap.round
          : StrokeCap.square;

      canvas.drawLine(p1, p2, linePaint);

      if (!rx1Cliped) pointBuffer.add(p1);
      if (!rx2Cliped) pointBuffer.add(p2);
    }
  }

  void _drawCursorAndPoints(Canvas canvas, Size size, double currentY) {
    final cursorPaint = paints.cursor;
    final cursorX = size.width / 2.0;
    canvas.drawLine(
      Offset(cursorX, cursorPaint.strokeWidth + (customMargin / 2.0)),
      Offset(
        cursorX,
        size.height - cursorPaint.strokeWidth - (customMargin / 2.0),
      ),
      cursorPaint,
    );
    canvas.drawPoints(PointMode.points, pointBuffer, paints.point);

    // Current position point (a smaller dot over a larger background dot).
    final bgStroke = paints.currentPointBackground.strokeWidth;
    final centerY =
        bgStroke +
        (customMargin / 2.0) +
        currentY * (size.height - (bgStroke * 2.0) - customMargin);
    canvas.drawCircle(
      Offset(cursorX, centerY),
      bgStroke,
      paints.currentPointBackground,
    );
    canvas.drawCircle(
      Offset(cursorX, centerY),
      paints.currentPoint.strokeWidth,
      paints.currentPoint,
    );
  }

  @override
  bool shouldRepaint(covariant _GraphPainter oldDelegate) {
    // Repaint whenever the video position or points change.
    return oldDelegate.videoPosition != videoPosition ||
        oldDelegate.actions != actions ||
        oldDelegate.viewDuration != viewDuration ||
        oldDelegate.speeds != speeds;
  }
}
