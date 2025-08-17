import 'dart:math';

import 'package:flutter/material.dart';
import 'package:syncopathy/helper/throttler.dart';
import 'package:syncopathy/model/funscript.dart';
import 'package:syncopathy/helper/constants.dart';

class Heatmap extends StatefulWidget {
  final Funscript funscript;
  final ValueNotifier<double> totalDuration;
  final ValueNotifier<double> videoPosition;

  Duration get totalDurationGetter =>
      Duration(milliseconds: (totalDuration.value * 1000).round());

  final void Function(Duration)? onClick;
  final VoidCallback? onInteractionStart;
  final VoidCallback? onInteractionEnd;

  const Heatmap({
    super.key,
    required this.funscript,
    required this.totalDuration,
    this.onClick,
    required this.videoPosition,
    this.onInteractionStart,
    this.onInteractionEnd,
  });

  @override
  State<Heatmap> createState() => _HeatmapState();
}

class _HeatmapState extends State<Heatmap> {
  final ValueNotifier<double?> _hoverPosition = ValueNotifier<double?>(null);
  final Throttler _throttler = Throttler(milliseconds: 100);

  @override
  void dispose() {
    _throttler.dispose();
    super.dispose();
  }

  void _handleInteraction(Offset localPosition, BoxConstraints constraints) {
    if (widget.onClick != null &&
        widget.totalDuration.value > 0 &&
        constraints.maxWidth > 0) {
      final dx = localPosition.dx.clamp(0, constraints.maxWidth);
      final clickedMs =
          (dx / constraints.maxWidth) *
          widget.totalDurationGetter.inMilliseconds;
      widget.onClick!(Duration(milliseconds: clickedMs.round()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return MouseRegion(
          onHover: (event) {
            if (widget.totalDurationGetter.inMilliseconds > 0 &&
                constraints.maxWidth > 0) {
              _hoverPosition.value = event.localPosition.dx.clamp(
                0,
                constraints.maxWidth,
              );
            }
          },
          onExit: (event) {
            _hoverPosition.value = null;
          },
          child: GestureDetector(
            onPanStart: (details) {
              _hoverPosition.value = null;
              widget.onInteractionStart?.call();
            },
            onPanEnd: (details) {
              widget.onInteractionEnd?.call();
            },
            onPanUpdate: (details) {
              _throttler.run(() {
                _handleInteraction(details.localPosition, constraints);
              });
            },
            onTapDown: (details) {
              widget.onInteractionStart?.call();
            },
            onTapUp: (details) {
              _handleInteraction(details.localPosition, constraints);
              widget.onInteractionEnd?.call();
            },
            child: ClipRect(
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  border: Border.all(color: Colors.grey),
                ),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    // Heatmap painter (only rebuilds when duration/funscript changes)
                    ValueListenableBuilder<double>(
                      valueListenable: widget.totalDuration,
                      builder: (context, duration, child) {
                        return CustomPaint(
                          painter: HeatmapPainter(
                            funscript: widget.funscript,
                            totalDuration: widget.totalDurationGetter,
                          ),
                        );
                      },
                    ),
                    // Indicator painter (only rebuilds when position changes)
                    ValueListenableBuilder<double>(
                      valueListenable: widget.videoPosition,
                      builder: (context, position, child) {
                        return CustomPaint(
                          painter: IndicatorPainter(
                            videoPosition: Duration(
                              milliseconds: (position * 1000).round(),
                            ),
                            totalDuration: widget.totalDurationGetter,
                          ),
                        );
                      },
                    ),
                    // Hover indicator
                    ValueListenableBuilder<double?>(
                      valueListenable: _hoverPosition,
                      builder: (context, hoverX, child) {
                        if (hoverX == null) {
                          return Container();
                        }
                        return CustomPaint(
                          painter: HoverIndicatorPainter(hoverX: hoverX),
                        );
                      },
                    ),
                    // Progress bar (solid bar on top)
                    ValueListenableBuilder<double>(
                      valueListenable: widget.videoPosition,
                      builder: (context, position, child) {
                        final double progressWidth =
                            widget.totalDuration.value > 0
                            ? constraints.maxWidth *
                                  (position / widget.totalDuration.value)
                            : 0.0;
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
          ),
        );
      },
    );
  }
}

class _SegmentData {
  double totalSpeed = 0.0;
  int speedCount = 0;
  double totalPos = 0.0;
  int posCount = 0;

  double get averageSpeed => speedCount > 0 ? totalSpeed / speedCount : 0.0;
  double get averagePos =>
      posCount > 0 ? totalPos / posCount : 50.0; // Default to middle
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

    final int numSegments = size.width.toInt();
    final double totalMs = totalDuration.inMilliseconds.toDouble();
    final double segmentMs = totalMs / numSegments;
    final double segmentPxWidth = size.width / numSegments;

    final paint = Paint();
    final List<Color> heatmapColors = [
      Colors.transparent,
      Colors.blue.shade300,
      Colors.green,
      Colors.yellow,
      Colors.red.shade600,
    ];

    // Pre-aggregate data into segments using a two-pointer approach
    final List<_SegmentData> segments = List.generate(
      numSegments,
      (_) => _SegmentData(),
    );
    int currentActionIndex = 0;

    for (int i = 0; i < numSegments; i++) {
      final double segmentStartTimeMs = i * segmentMs;
      final double segmentEndTimeMs = (i + 1) * segmentMs;

      // Advance currentActionIndex to the first action that starts within or after segmentStartTimeMs
      while (currentActionIndex < funscript.actions.length - 1 &&
          funscript.actions[currentActionIndex + 1].at < segmentStartTimeMs) {
        currentActionIndex++;
      }

      // Iterate through actions that overlap with the current segment
      int tempActionIndex = currentActionIndex;
      while (tempActionIndex < funscript.actions.length - 1) {
        final p1 = funscript.actions[tempActionIndex];
        final p2 = funscript.actions[tempActionIndex + 1];

        // If the current action interval starts after the segment ends, break
        if (p1.at >= segmentEndTimeMs) {
          break;
        }

        // If the action interval [p1.at, p2.at] overlaps with the current segment [segmentStartTimeMs, segmentEndTimeMs]
        if (max(p1.at.toDouble(), segmentStartTimeMs) <
            min(p2.at.toDouble(), segmentEndTimeMs)) {
          final timeDiff = (p2.at - p1.at).toDouble();
          if (timeDiff > 0) {
            final posDiff = (p2.pos - p1.pos).abs().toDouble();
            final speed = posDiff / timeDiff;
            segments[i].totalSpeed += speed;
            segments[i].speedCount++;
          }
          segments[i].totalPos += p1.pos; // Use p1.pos as representative
          segments[i].posCount++;
        }
        tempActionIndex++;
      }
    }

    // Draw each segment
    for (int i = 0; i < numSegments; i++) {
      final _SegmentData segmentData = segments[i];

      final startX = i * segmentPxWidth;
      final rectWidth = segmentPxWidth;

      final normalizedSpeed = min(
        segmentData.averageSpeed / speedNormalizationValue,
        1.0,
      );

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

      final barHeight = size.height * 0.8; // Example fixed height
      final barTop =
          (100 - segmentData.averagePos) / 100.0 * size.height -
          (barHeight / 2);
      final clampedBarTop = barTop.clamp(0.0, size.height - barHeight);

      canvas.drawRect(
        Rect.fromLTWH(startX, clampedBarTop, rectWidth, barHeight),
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

class HoverIndicatorPainter extends CustomPainter {
  final double hoverX;

  HoverIndicatorPainter({required this.hoverX});

  @override
  void paint(Canvas canvas, Size size) {
    final hoverPaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 2.0;

    canvas.drawLine(Offset(hoverX, 0), Offset(hoverX, size.height), hoverPaint);
  }

  @override
  bool shouldRepaint(covariant HoverIndicatorPainter oldDelegate) {
    return oldDelegate.hoverX != hoverX;
  }
}
