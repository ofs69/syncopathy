import 'dart:math';

import 'package:flutter/material.dart';
import 'package:syncopathy/model/funscript.dart';

class Heatmap extends StatelessWidget {
  final Funscript funscript;
  final ValueNotifier<double> totalDuration;
  final ValueNotifier<double> videoPosition;

  Duration get _totalDuration =>
      Duration(milliseconds: (totalDuration.value * 1000).round());

  final void Function(Duration)? onClick;

  const Heatmap({
    super.key,
    required this.funscript,
    required this.totalDuration,
    this.onClick,
    required this.videoPosition,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return GestureDetector(
          onTapDown: (details) {
            if (onClick != null &&
                _totalDuration.inMilliseconds > 0 &&
                constraints.maxWidth > 0) {
              final dx = details.localPosition.dx.clamp(
                0,
                constraints.maxWidth,
              );
              final clickedMs =
                  (dx / constraints.maxWidth) * _totalDuration.inMilliseconds;
              onClick!(Duration(milliseconds: clickedMs.round()));
            }
          },
          child: ClipRect(
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceVariant,
                border: Border.all(color: Colors.grey),
              ),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  // Heatmap painter (only rebuilds when duration/funscript changes)
                  ValueListenableBuilder<double>(
                    valueListenable: totalDuration,
                    builder: (context, duration, child) {
                      return CustomPaint(
                        painter: HeatmapPainter(
                          funscript: funscript,
                          totalDuration: _totalDuration,
                        ),
                      );
                    },
                  ),
                  // Indicator painter (only rebuilds when position changes)
                  ValueListenableBuilder<double>(
                    valueListenable: videoPosition,
                    builder: (context, position, child) {
                      return CustomPaint(
                        painter: IndicatorPainter(
                          videoPosition: Duration(
                            milliseconds: (position * 1000).round(),
                          ),
                          totalDuration: _totalDuration,
                        ),
                      );
                    },
                  ),
                  // Progress bar (solid bar on top)
                  ValueListenableBuilder<double>(
                    valueListenable: videoPosition,
                    builder: (context, position, child) {
                      final double positionRatio =
                          position / totalDuration.value;
                      final double progressWidth =
                          constraints.maxWidth * positionRatio;
                      return Positioned(
                        top: 0,
                        left: 0,
                        child: Container(
                          width: progressWidth,
                          height: 2.0, // Height of the progress bar
                          color: Colors.red, // Color of the progress bar
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

/// A [CustomPainter] that draws the heatmap based on movement speed.
class HeatmapPainter extends CustomPainter {
  final Funscript funscript;
  final Duration totalDuration;

  HeatmapPainter({required this.funscript, required this.totalDuration});

  @override
  void paint(Canvas canvas, Size size) {
    if (funscript.actions.length < 2 ||
        totalDuration.inMilliseconds <= 0 ||
        size.width <= 0) {
      return;
    }

    final speeds = <double>[];
    for (int i = 0; i < funscript.actions.length - 1; i++) {
      final p1 = funscript.actions[i];
      final p2 = funscript.actions[i + 1];
      final timeDiff = p2.at - p1.at;
      if (timeDiff > 0) {
        final posDiff = (p2.pos - p1.pos).abs();
        final speed = posDiff / timeDiff; // % per millisecond
        speeds.add(speed);
      } else {
        speeds.add(0.0);
      }
    }

    if (speeds.isEmpty) {
      return;
    }

    // Use a percentile to determine max speed to avoid outliers dominating the color scale.
    final sortedSpeeds = List<double>.from(speeds)..sort();
    final maxSpeed = sortedSpeeds[(sortedSpeeds.length * 0.98).floor()];
    if (maxSpeed == 0) {
      return;
    }

    final paint = Paint();
    final List<Color> heatmapColors = [
      Colors.black,
      Colors.blue.shade300,
      Colors.green,
      Colors.yellow,
      Colors.red.shade600,
    ];

    for (int i = 0; i < funscript.actions.length - 1; i++) {
      final p1 = funscript.actions[i];
      final p2 = funscript.actions[i + 1];
      final speed = speeds[i];

      final startX = (p1.at / totalDuration.inMilliseconds) * size.width;
      final endX = (p2.at / totalDuration.inMilliseconds) * size.width;
      final rectWidth = endX - startX;

      final y1 = (100 - p1.pos) / 100.0 * size.height;
      final y2 = (100 - p2.pos) / 100.0 * size.height;
      final rectTop = min(y1, y2);
      final rectHeight = (y1 - y2).abs();

      if (rectWidth < 0.5 && rectHeight < 0.5) {
        // Don't draw rects that are too small to see
        continue;
      }

      // Normalize speed and apply sqrt to get a better color distribution
      final normalizedSpeed = sqrt(min(speed / maxSpeed, 1.0));

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

      paint.color = Color.lerp(
        heatmapColors[fromIndex],
        heatmapColors[toIndex],
        t,
      )!;

      canvas.drawRect(
        Rect.fromLTWH(startX, rectTop, rectWidth, max(0.5, rectHeight)),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant HeatmapPainter oldDelegate) {
    return oldDelegate.funscript != funscript ||
        oldDelegate.totalDuration != totalDuration;
  }
}

/// A [CustomPainter] that draws the video position indicator.
class IndicatorPainter extends CustomPainter {
  final Duration totalDuration;
  final Duration videoPosition;

  IndicatorPainter({required this.totalDuration, required this.videoPosition});

  @override
  void paint(Canvas canvas, Size size) {
    if (totalDuration.inMilliseconds <= 0) return;

    final double positionRatio =
        videoPosition.inMilliseconds / totalDuration.inMilliseconds;
    final double indicatorX = (positionRatio * size.width).clamp(0, size.width);

    final indicatorPaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 1.5;

    final indicatorBorderPaint = Paint()
      ..color = Colors.black
      ..strokeWidth = 3.0;

    canvas.drawLine(
      Offset(indicatorX, 0),
      Offset(indicatorX, size.height),
      indicatorBorderPaint,
    );

    final progressBorderPaint = Paint()
      ..color = Colors.black
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;
    canvas.drawRect(Rect.fromLTWH(0, 0, indicatorX, 3.0), progressBorderPaint);

    final progressFillPaint = Paint()..color = Colors.red;
    canvas.drawRect(
      Rect.fromLTWH(0, 0, indicatorX, 3.0), // Solid bar on top with height 3.0
      progressFillPaint,
    );

    canvas.drawLine(
      Offset(indicatorX, 0),
      Offset(indicatorX, size.height),
      indicatorPaint,
    );
  }

  @override
  bool shouldRepaint(covariant IndicatorPainter oldDelegate) {
    return oldDelegate.videoPosition != videoPosition ||
        oldDelegate.totalDuration != totalDuration;
  }
}
