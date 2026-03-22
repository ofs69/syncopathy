import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:provider/provider.dart';
import 'package:signals/signals_flutter.dart';
import 'package:syncopathy/fullscreen_video_page.dart';
import 'package:syncopathy/helper/constants.dart';
import 'package:syncopathy/helper/effect_dispose_mixin.dart';
import 'package:syncopathy/helper/extensions.dart';
import 'package:syncopathy/ioc.dart';
import 'package:syncopathy/model/player_model.dart';
import 'package:syncopathy/model/settings_model.dart';
import 'package:syncopathy/player/video_player.dart';
import 'package:syncopathy/scrolling_graph.dart';
import 'package:syncopathy/simple/simple_mode/simple_mode.dart';
import 'package:syncopathy/video_controls.dart';
import 'package:syncopathy/video_player_settings_overlay.dart';

class VideoWidget extends StatefulWidget {
  final VideoPlayer player;
  final Signal<bool> showFunscriptGraph;
  final Signal<bool> showSettings;
  final Signal<bool> showControls;
  final bool isFullscreen;

  const VideoWidget({
    super.key,
    required this.player,
    required this.isFullscreen,
    required this.showFunscriptGraph,
    required this.showSettings,
    required this.showControls,
  });

  @override
  State<VideoWidget> createState() => _VideoWidgetState();
}

class _VideoWidgetState extends State<VideoWidget>
    with EffectDispose, SignalsMixin {
  Timer? _hideControlsTimer;

  @override
  void initState() {
    super.initState();
    _startHideControlsTimer();
    final player = getIt.get<VideoPlayer>();
    effectAdd([
      effect(() {
        final path = player.loadedPath.value;
        if (path.trim() == "") {
          widget.showSettings.value = false;
        }
      }),
    ]);
  }

  @override
  void dispose() {
    _hideControlsTimer?.cancel();
    super.dispose();
  }

  void _startHideControlsTimer() {
    _hideControlsTimer?.cancel();
    _hideControlsTimer = Timer(const Duration(seconds: 3), () {
      if (mounted) {
        widget.showControls.value = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final player = widget.player;
    final settings = context.watch<SettingsModel>();
    final playerModel = context.watch<PlayerModel>();

    return Material(
      child: Watch.builder(
        builder: (context) {
          final showControls =
              widget.showControls.value ||
              widget.showSettings.value ||
              !settings.embeddedVideoPlayer.value;

          final videoController = widget.player.controller;
          return LayoutBuilder(
            builder: (context, constraints) {
              final videoWidth = player.videoWidth.value;
              final videoHeight = player.videoHeight.value;

              // Manually calcultate the video width to bound the funscript graph
              double displayWidth = constraints.maxWidth;
              if (videoWidth != null &&
                  videoHeight != null &&
                  videoWidth > 0 &&
                  videoHeight > 0) {
                double screenAspect =
                    constraints.maxWidth / constraints.maxHeight;
                double videoAspect = videoWidth / videoHeight;

                if (videoAspect < screenAspect) {
                  displayWidth = constraints.maxHeight * videoAspect;
                }
              }

              return Listener(
                onPointerMove: (_) {
                  widget.showControls.value = true;
                  _startHideControlsTimer();
                },
                child: MouseRegion(
                  onExit: (_) => widget.showControls.value = false,
                  onHover: (_) {
                    widget.showControls.value = true;
                    _startHideControlsTimer();
                  },
                  child: Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      Stack(
                        children: [
                          videoController != null
                              ? _videoContainer(
                                  videoController,
                                  videoWidth,
                                  videoHeight,
                                )
                              : Center(child: Text('Embedded player disabled')),
                          Align(
                            alignment: AlignmentGeometry.bottomCenter,
                            child: Column(
                              children: [
                                Expanded(
                                  flex: 10,
                                  child: AnimatedSlide(
                                    offset: widget.showSettings.watch(context)
                                        ? Offset.zero
                                        : const Offset(
                                            0,
                                            -1,
                                          ), // Slides in from the right
                                    duration: const Duration(milliseconds: 300),
                                    curve: Curves.easeInOut,
                                    child: ExcludeFocus(
                                      excluding: !showControls,
                                      child: ScriptPlayerSettingsOverlay(),
                                    ),
                                  ),
                                ),
                                widget.showFunscriptGraph.watch(context)
                                    ? ConstrainedBox(
                                        constraints: BoxConstraints(
                                          minHeight: 50.0,
                                          maxHeight: 150.0,
                                          maxWidth: displayWidth,
                                        ),
                                        child: SizedBox(
                                          height:
                                              MediaQuery.of(
                                                context,
                                              ).size.height *
                                              0.15,
                                          child: _funscriptGraph(
                                            playerModel.currentlyOpen,
                                            player,
                                            settings,
                                          ),
                                        ),
                                      )
                                    : const SizedBox.shrink(),
                                AnimatedOpacity(
                                  opacity: showControls ? 1.0 : 0.0,
                                  duration: const Duration(milliseconds: 200),
                                  child: IgnorePointer(
                                    ignoring: !showControls,
                                    child: VideoControls(
                                      showFunscriptGraph:
                                          widget.showFunscriptGraph,
                                      showSettings: widget.showSettings,
                                      onFullscreenToggle: widget.isFullscreen
                                          ? () async {
                                              if (!kIsWeb) {
                                                await SimpleMode.exitFullscreen();
                                              }
                                              if (!context.mounted) return;
                                              Navigator.pop(context);
                                            }
                                          : () async {
                                              if (!kIsWeb) {
                                                await SimpleMode.enterFullscreen();
                                              }
                                              if (!context.mounted) return;
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      FullscreenVideoPage(
                                                        player: player,
                                                        isEmbeddedPlayerEnabled:
                                                            settings
                                                                .embeddedVideoPlayer
                                                                .value,
                                                        showControls:
                                                            widget.showControls,
                                                        showFunscriptGraph: widget
                                                            .showFunscriptGraph,
                                                        showSettings:
                                                            widget.showSettings,
                                                      ),
                                                ),
                                              );
                                            },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _funscriptGraph(
    ReadonlySignal<MediaFunscript?> currentlyOpen,
    VideoPlayer player,
    SettingsModel settings,
  ) {
    return Container(
      padding: const EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 0.0),
      decoration: stdBoxShadow(),
      child: InteractiveScrollingGraph(
        currentlyOpen: currentlyOpen,
        videoPosition: player.smoothPosition,
        viewDuration: settings.funscriptGraphViewDuration,
        playbackRate: player.playbackSpeed,
        strokeRange: settings.minMaxRange,
      ),
    );
  }

  Widget _videoContainer(
    VideoController controller,
    int? videoWidth,
    int? videoHeight,
  ) {
    return Stack(
      children: [
        Center(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlphaF(0.5),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: videoWidth != null && videoHeight != null
                ? AspectRatio(
                    aspectRatio: videoWidth / videoHeight,
                    child: Video(controller: controller, controls: null),
                  )
                : Video(controller: controller, controls: null),
          ),
        ),
      ],
    );
  }
}
