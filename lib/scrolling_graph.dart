import 'dart:math';
import 'dart:ui';

import 'package:collection/collection.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:signals/signals_flutter.dart';
import 'package:syncopathy/model/funscript.dart';
import 'package:syncopathy/helper/constants.dart';
import 'package:syncopathy/player/mpv.dart';

/// A widget that wraps the [ScrollingGraph] with a slider to control the zoom level (view duration).
class InteractiveScrollingGraph extends StatefulWidget {
  final ReadonlySignal<Funscript?> funscript;
  final ReadonlySignal<double> videoPosition;
  final Signal<Duration> viewDuration;

  const InteractiveScrollingGraph({
    super.key,
    required this.funscript,
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
                    .clamp(1000, 30000),
          );
        }
      },
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade600),
          color: Colors.black.withAlpha(25),
        ),
        child: ScrollingGraph(
          funscript: widget.funscript,
          videoPosition: widget.videoPosition,
          viewDuration: widget.viewDuration,
        ),
      ),
    );
  }
}

class ScrollingGraph extends StatefulWidget {
  final ReadonlySignal<Funscript?> funscript;
  final ReadonlySignal<double> videoPosition;
  final Signal<Duration> viewDuration;

  const ScrollingGraph({
    super.key,
    required this.funscript,
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
      final funscript = widget.funscript.value;
      if (funscript == null) return [];
      if (funscript.actions.value.length < 2) return [];

      final actions = funscript.actions.value;
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
    final player = context.read<MpvVideoplayer>();
    return Watch.builder(
      builder: (context) {
        final position = widget.videoPosition.value;
        final viewDuration = widget.viewDuration.value;
        final funscript = widget.funscript.value;
        final actions = funscript?.actions.value;
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
    final gridPaint = Paint()
      ..color = theme.colorScheme.onSurface.withAlpha(25)
      ..strokeWidth = 1.0;

    final linePaint = Paint()
      ..color = theme.colorScheme.primary
      ..strokeWidth = 5.0
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.square
      ..strokeJoin = StrokeJoin.bevel;
    ;

    final cursorPaint = Paint()
      ..color = theme.colorScheme.secondary
      ..strokeWidth = 2.0;

    final pointPaint = Paint()
      ..color = theme.colorScheme.tertiary
      ..strokeWidth = 10.0
      ..style = PaintingStyle.fill
      ..strokeCap = StrokeCap.round;

    Offset boundSize(Size size, double strokeWidth, double relX, double relY) {
      double x = (strokeWidth / 2.0) + (relX * (size.width - strokeWidth));
      double y = (strokeWidth / 2.0) + (relY * (size.height - strokeWidth));
      return Offset(x, y);
    }

    // --- 2. Draw Grid ---
    final secondsInView = viewDuration.inSeconds;
    for (int i = 0; i <= secondsInView; i++) {
      final x = size.width * (i / secondsInView.toDouble());
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), gridPaint);
    }

    // --- 3. Calculate Visible Window ---
    final halfViewMs = viewDuration.inMilliseconds / 2;
    final viewStart =
        videoPosition - Duration(milliseconds: halfViewMs.round());
    final viewEnd = videoPosition + Duration(milliseconds: halfViewMs.round());

    // --- 4. Calculate Speeds ---
    if (actions.length < 2) {
      // Not enough points to draw lines or calculate speed
      return;
    }

    final List<Color> heatmapColors = [
      Colors.black,
      Colors.blue.shade300,
      Colors.green,
      Colors.yellow,
      Colors.red.shade600,
    ];

    // --- 5. Filter, Transform, and Draw Points ---
    // binary search for start and end indices
    final testStart = FunscriptAction(at: viewStart.inMilliseconds, pos: 0);
    int start = max(lowerBound(actions, testStart) - 1, 0);
    final testEnd = FunscriptAction(at: viewEnd.inMilliseconds, pos: 0);
    int end = min(lowerBound(actions, testEnd) + 1, actions.length);

    List<Offset> points = [];
    for (int i = start; i < end - 1; i++) {
      final a1 = actions[i];
      final a2 = actions[i + 1];

      final timeOffset1 = Duration(milliseconds: a1.at) - viewStart;
      final relX1 = (timeOffset1.inMilliseconds / viewDuration.inMilliseconds);
      final relY1 = 1.0 - (a1.pos / 100.0);

      final timeOffset2 = Duration(milliseconds: a2.at) - viewStart;
      final relX2 = (timeOffset2.inMilliseconds / viewDuration.inMilliseconds);
      final relY2 = 1.0 - (a2.pos / 100.0);

      final speed = speeds[i];
      final normalizedSpeed = min(speed / speedNormalizationValue, 1.0);

      final double colorPosition = normalizedSpeed * (heatmapColors.length - 1);
      final int fromIndex = colorPosition.floor().clamp(
        0,
        heatmapColors.length - 2,
      );
      final int toIndex = colorPosition.ceil().clamp(
        0,
        heatmapColors.length - 1,
      );
      final double t = colorPosition - fromIndex;

      linePaint.color = Color.lerp(
        heatmapColors[fromIndex],
        heatmapColors[toIndex],
        t,
      )!;

      final p1 = boundSize(size, linePaint.strokeWidth, relX1, relY1);
      final p2 = boundSize(size, linePaint.strokeWidth, relX2, relY2);
      canvas.drawLine(p1, p2, linePaint);

      points.add(p1);
      if (i == end - 2) {
        points.add(p2);
      }
    }

    // --- 6. Draw Cursor ---
    final cursorX = size.width / 2.0;
    canvas.drawLine(
      Offset(cursorX, 0),
      Offset(cursorX, size.height),
      cursorPaint,
    );

    canvas.drawPoints(PointMode.points, points, pointPaint);
  }

  @override
  bool shouldRepaint(covariant GraphPainter oldDelegate) {
    // Repaint whenever the video position or points change.
    return oldDelegate.videoPosition != videoPosition ||
        oldDelegate.actions != actions ||
        oldDelegate.theme != theme ||
        oldDelegate.viewDuration != viewDuration ||
        oldDelegate.speeds != speeds;
  }
}
