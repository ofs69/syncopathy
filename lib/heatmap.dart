import 'dart:math';

import 'package:flutter/material.dart';
import 'package:signals/signals_flutter.dart';
import 'package:syncopathy/helper/throttler.dart';
import 'package:syncopathy/model/funscript.dart';
import 'package:syncopathy/helper/constants.dart';
import 'package:syncopathy/player/video_player.dart';

class Heatmap extends StatefulWidget {
  final List<FunscriptAction> actions;
  final ReadonlySignal<double?> totalDuration;
  int get totalDurationMs => ((totalDuration.value ?? 0.0) * 1000.0).round();

  final ReadonlySignal<int> videoPositionFixedStep;

  final void Function(Duration)? onClick;

  const Heatmap({
    super.key,
    required this.actions,
    required this.onClick,
    required this.videoPositionFixedStep,
    required this.totalDuration,
  });

  @override
  State<Heatmap> createState() => _HeatmapState();
}

class _HeatmapState extends State<Heatmap> {
  final Signal<double?> _hoverPosition = signal(null);
  final Throttler _throttler = Throttler(milliseconds: 150);

  @override
  void dispose() {
    _throttler.dispose();
    super.dispose();
  }

  void _handleInteraction(Offset localPosition, BoxConstraints constraints) {
    final totalDuration = widget.totalDuration.value ?? 0;
    if (widget.onClick != null &&
        totalDuration > 0 &&
        constraints.maxWidth > 0) {
      final dx = localPosition.dx.clamp(0, constraints.maxWidth);
      final clickedMs = (dx / constraints.maxWidth) * widget.totalDurationMs;
      widget.onClick!(Duration(milliseconds: clickedMs.round()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return MouseRegion(
          onHover: (event) {
            if (widget.totalDurationMs > 0 && constraints.maxWidth > 0) {
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
            },
            onPanUpdate: (details) {
              _throttler.run(() async {
                _handleInteraction(details.localPosition, constraints);
              });
            },
            onTapUp: (details) {
              _handleInteraction(details.localPosition, constraints);
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                  flex: 6,
                  child: Stack(
                    // Allows the Slider thumb to overflow the stack bounds if needed
                    clipBehavior: Clip.none,
                    fit: StackFit.expand,
                    children: [
                      // 1. Heatmap painter (Background layer)
                      RepaintBoundary(
                        child: Watch.builder(
                          builder: (context) {
                            final duration =
                                ((widget.totalDuration.value ?? 0.0) * 1000.0)
                                    .round();
                            return CustomPaint(
                              painter: HeatmapPainter(
                                actions: widget.actions,
                                totalDuration: Duration(milliseconds: duration),
                              ),
                            );
                          },
                        ),
                      ),

                      // 2. Indicator painter (Vertical white line)
                      Watch.builder(
                        builder: (context) {
                          final position = widget.videoPositionFixedStep.value;
                          return CustomPaint(
                            painter: IndicatorPainter(
                              videoPositionStep: position,
                            ),
                          );
                        },
                      ),

                      // 3. Hover indicator (Vertical line on mouse hover)
                      Watch.builder(
                        builder: (context) {
                          final hoverX = _hoverPosition.value;
                          if (hoverX == null) {
                            return const SizedBox.shrink();
                          }
                          return CustomPaint(
                            painter: HoverIndicatorPainter(hoverX: hoverX),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                // 4. Visual Slider Timeline (Aligned to bottom)
                Expanded(
                  flex: 1,
                  child: IgnorePointer(
                    child: Watch.builder(
                      builder: (context) {
                        final positionStep =
                            widget.videoPositionFixedStep.value;

                        return SliderTheme(
                          data: SliderTheme.of(context).copyWith(
                            padding: EdgeInsets.all(0),
                            trackShape: const RectangularSliderTrackShape(),
                            trackHeight: 4.0,
                            activeTrackColor: Colors.redAccent,
                            inactiveTrackColor: Theme.of(
                              context,
                            ).colorScheme.onInverseSurface,
                            thumbColor: Colors.red,
                            overlayColor: Colors.transparent,
                            thumbShape: const RoundSliderThumbShape(
                              enabledThumbRadius: 8.0,
                            ),
                          ),
                          child: Slider(
                            value: positionStep
                                .clamp(0, videoPlayerPositionFixedStepCount)
                                .toDouble(),
                            max: videoPlayerPositionFixedStepCount.toDouble(),
                            onChanged: (_) {},
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
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

  // New fields for averaging position boundaries
  double totalMinPos = 0.0;
  double totalMaxPos = 0.0;
  int posSampleCount = 0;

  double get averageSpeed => speedCount > 0 ? totalSpeed / speedCount : 0.0;
  double get averageMin =>
      posSampleCount > 0 ? totalMinPos / posSampleCount : 0.0;
  double get averageMax =>
      posSampleCount > 0 ? totalMaxPos / posSampleCount : 0.0;
}

/// A [CustomPainter] that draws the heatmap based on movement speed.
class HeatmapPainter extends CustomPainter {
  final List<FunscriptAction> actions;
  final Duration totalDuration;

  HeatmapPainter({required this.actions, required this.totalDuration});

  @override
  void paint(Canvas canvas, Size size) {
    if (actions.length < 2 || size.width <= 2) return;

    // Rule: One segment per 2 pixels
    final int numSegments = (size.width / 2.0).floor();
    final double segmentPxWidth = 2.0;
    final double totalMs = totalDuration.inMilliseconds.toDouble();
    final double segmentMs = totalMs / numSegments;

    final List<_SegmentData> segments = List.generate(
      numSegments,
      (_) => _SegmentData(),
    );
    int currentActionIndex = 0;

    for (int i = 0; i < numSegments; i++) {
      final double segmentStartTime = i * segmentMs;
      final double segmentEndTime = (i + 1) * segmentMs;

      while (currentActionIndex < actions.length - 1 &&
          actions[currentActionIndex + 1].at < segmentStartTime) {
        currentActionIndex++;
      }

      int tempIdx = currentActionIndex;
      while (tempIdx < actions.length - 1) {
        final p1 = actions[tempIdx];
        final p2 = actions[tempIdx + 1];

        if (p1.at >= segmentEndTime) break;

        // Check for overlap
        if (max(p1.at.toDouble(), segmentStartTime) <
            min(p2.at.toDouble(), segmentEndTime)) {
          // Speed Calculation
          final timeDiff = (p2.at - p1.at).toDouble();
          if (timeDiff > 0) {
            segments[i].totalSpeed += (p2.pos - p1.pos).abs() / timeDiff;
            segments[i].speedCount++;
          }

          // Position Averaging logic
          // We treat every action pair overlapping this segment as a sample of the range
          segments[i].totalMinPos += min(p1.pos, p2.pos);
          segments[i].totalMaxPos += max(p1.pos, p2.pos);
          segments[i].posSampleCount++;
        }
        tempIdx++;
      }
    }

    // DRAWING PHASE
    for (int i = 0; i < numSegments; i++) {
      final data = segments[i];
      if (data.posSampleCount == 0) continue;

      final double startX = i * segmentPxWidth;

      // Calculate color based on speed
      final normalizedSpeed = (data.averageSpeed / speedNormalizationValue)
          .clamp(0.0, 1.0);
      final paint = Paint()..color = _getHeatmapColor(normalizedSpeed);

      // Calculate vertical bounds using averageMin and averageMax
      // Mapping: Funscript 100 is bottom (size.height), 0 is top (0)
      final double yTop = (100 - data.averageMax) / 100.0 * size.height;
      final double yBottom = (100 - data.averageMin) / 100.0 * size.height;

      final double barHeight = (yBottom - yTop).abs().clamp(
        size.height * 0.3,
        size.height,
      );

      canvas.drawRect(
        Rect.fromLTWH(startX, yTop, segmentPxWidth, barHeight),
        paint,
      );
    }
  }

  Color _getHeatmapColor(double normalizedSpeed) {
    // 1. Safety checks
    if (heatmapColors.isEmpty) return Colors.transparent;
    if (heatmapColors.length == 1) return heatmapColors.first;

    // 2. Scale 0.0-1.0 to the range of the list indices
    // (e.g., if we have 5 colors, indices are 0 to 4)
    final double position = normalizedSpeed * (heatmapColors.length - 1);

    // 3. Find the two colors to interpolate between
    final int fromIndex = position.floor().clamp(0, heatmapColors.length - 2);
    final int toIndex = fromIndex + 1;

    // 4. Calculate the remainder (t) for lerping between those two specific colors
    final double t = (position - fromIndex).clamp(0.0, 1.0);

    return Color.lerp(heatmapColors[fromIndex], heatmapColors[toIndex], t)!;
  }

  @override
  bool shouldRepaint(covariant HeatmapPainter oldDelegate) {
    return oldDelegate.actions != actions ||
        oldDelegate.totalDuration != totalDuration;
  }
}

class IndicatorPainter extends CustomPainter {
  final int videoPositionStep;

  IndicatorPainter({required this.videoPositionStep});

  @override
  void paint(Canvas canvas, Size size) {
    final double positionRatio =
        videoPositionStep / videoPlayerPositionFixedStepCount;
    final double indicatorX = (positionRatio * size.width).clamp(0, size.width);

    final indicatorPaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 2;

    final indicatorBorderPaint = Paint()
      ..color = Colors.black
      ..strokeWidth = 4.0;

    canvas.drawLine(
      Offset(indicatorX, 0),
      Offset(indicatorX, size.height),
      indicatorBorderPaint,
    );

    canvas.drawLine(
      Offset(indicatorX, 1),
      Offset(indicatorX, size.height),
      indicatorPaint,
    );
  }

  @override
  bool shouldRepaint(covariant IndicatorPainter oldDelegate) {
    return oldDelegate.videoPositionStep != videoPositionStep;
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
