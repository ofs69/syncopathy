import 'dart:math';
import 'dart:ui';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:syncopathy/model/funscript.dart';

/// A widget that wraps the [ScrollingGraph] with a slider to control the zoom level (view duration).
class InteractiveScrollingGraph extends StatefulWidget {
  final Funscript funscript;
  final ValueNotifier<double> videoPosition;

  const InteractiveScrollingGraph({
    super.key,
    required this.funscript,
    required this.videoPosition,
  });

  @override
  State<InteractiveScrollingGraph> createState() =>
      _InteractiveScrollingGraphState();
}

class _InteractiveScrollingGraphState extends State<InteractiveScrollingGraph> {
  // Default zoom level set to 10 seconds.
  final ValueNotifier<Duration> _viewDuration = ValueNotifier(
    const Duration(seconds: 10),
  );

  @override
  void dispose() {
    _viewDuration.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ValueListenableBuilder<Duration>(
            valueListenable: _viewDuration,
            builder: (context, duration, child) {
              return Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                ),
                child: ScrollingGraph(
                  funscript: widget.funscript,
                  videoPosition: widget.videoPosition,
                  viewDuration: duration,
                ),
              );
            },
          ),
        ),
        Column(
          children: [
            Expanded(
              child: ValueListenableBuilder<Duration>(
                valueListenable: _viewDuration,
                builder: (context, duration, child) {
                  return RotatedBox(
                    quarterTurns: -1,
                    child: Slider(
                      value: duration.inSeconds.toDouble(),
                      min: 5,
                      max: 30,
                      divisions: 25, // (30-5) for 1-second increments
                      label: '${duration.inSeconds}s',
                      onChanged: (value) {
                        _viewDuration.value = Duration(seconds: value.round());
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class ScrollingGraph extends StatefulWidget {
  final Funscript funscript;
  final ValueNotifier<double> videoPosition;
  final Duration viewDuration;

  const ScrollingGraph({
    super.key,
    required this.funscript,
    required this.videoPosition,
    this.viewDuration = const Duration(seconds: 5),
  });

  @override
  State<ScrollingGraph> createState() => _ScrollingGraphState();
}

class _ScrollingGraphState extends State<ScrollingGraph> {
  List<double> _speeds = [];
  double _maxSpeed = 1.0;

  @override
  void initState() {
    super.initState();
    _updateSpeeds();
  }

  @override
  void didUpdateWidget(ScrollingGraph oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.funscript != oldWidget.funscript) {
      _updateSpeeds();
    }
  }

  void _updateSpeeds() {
    if (widget.funscript.actions.length < 2) {
      if (mounted) {
        setState(() {
          _speeds = [];
          _maxSpeed = 1.0;
        });
      }
      return;
    }

    final speeds = <double>[];
    for (int i = 0; i < widget.funscript.actions.length - 1; i++) {
      final p1 = widget.funscript.actions[i];
      final p2 = widget.funscript.actions[i + 1];
      final timeDiff = p2.at - p1.at;
      if (timeDiff > 0) {
        final posDiff = (p2.pos - p1.pos).abs();
        final speed = posDiff / timeDiff; // % per millisecond
        speeds.add(speed);
      } else {
        speeds.add(0.0);
      }
    }

    if (mounted) {
      setState(() {
        _speeds = speeds;
        _maxSpeed = speeds.isEmpty
            ? 1.0
            : (List<double>.from(speeds)
                ..sort())[(speeds.length * 0.98).floor()];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Use a ValueListenableBuilder to rebuild only this widget
    // when the video position changes.
    return ValueListenableBuilder<double>(
      valueListenable: widget.videoPosition,
      builder: (context, position, child) {
        return ClipRect(
          // Prevents the painter from drawing outside its bounds
          child: CustomPaint(
            painter: GraphPainter(
              funscript: widget.funscript,
              videoPosition: Duration(milliseconds: (position * 1000).round()),
              viewDuration: widget.viewDuration,
              theme: Theme.of(context),
              speeds: _speeds,
              maxSpeed: _maxSpeed,
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
  final Funscript funscript;
  final Duration videoPosition;
  final Duration viewDuration;
  final ThemeData theme;
  final List<double> speeds;
  final double maxSpeed;

  GraphPainter({
    required this.funscript,
    required this.videoPosition,
    required this.viewDuration,
    required this.theme,
    required this.speeds,
    required this.maxSpeed,
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
      ..style = PaintingStyle.stroke;

    final cursorPaint = Paint()
      ..color = theme.colorScheme.secondary
      ..strokeWidth = 2.0;

    final pointPaint = Paint()
      ..color = theme.colorScheme.tertiary
      ..strokeWidth = 10.0
      ..style = PaintingStyle.fill;

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
    if (funscript.actions.length < 2) {
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
    int start = max(lowerBound(funscript.actions, testStart) - 1, 0);
    final testEnd = FunscriptAction(at: viewEnd.inMilliseconds, pos: 0);
    int end = min(
      lowerBound(funscript.actions, testEnd) + 1,
      funscript.actions.length,
    );

    List<Offset> points = [];
    for (int i = start; i < end - 1; i++) {
      final p1 = funscript.actions[i];
      final p2 = funscript.actions[i + 1];

      final timeOffset1 = Duration(milliseconds: p1.at) - viewStart;
      final x1 =
          (timeOffset1.inMilliseconds / viewDuration.inMilliseconds) *
          size.width;
      final y1 = size.height - (p1.pos / 100.0) * size.height;

      final timeOffset2 = Duration(milliseconds: p2.at) - viewStart;
      final x2 =
          (timeOffset2.inMilliseconds / viewDuration.inMilliseconds) *
          size.width;
      final y2 = size.height - (p2.pos / 100.0) * size.height;

      if (maxSpeed > 0) {
        final speed = speeds[i];
        final normalizedSpeed = sqrt(min(speed / maxSpeed, 1.0));

        final double colorPosition =
            normalizedSpeed * (heatmapColors.length - 1);
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
      } else {
        linePaint.color = heatmapColors.first;
      }

      canvas.drawLine(Offset(x1, y1), Offset(x2, y2), linePaint);

      points.add(Offset(x1, y1));
      if (i == end - 2) {
        points.add(Offset(x2, y2));
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
        oldDelegate.funscript != funscript ||
        oldDelegate.theme != theme ||
        oldDelegate.viewDuration != viewDuration ||
        oldDelegate.speeds != speeds ||
        oldDelegate.maxSpeed != maxSpeed;
  }
}
