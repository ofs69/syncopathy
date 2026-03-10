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

  void _toggleControls() {
    widget.showControls.value = !widget.showControls.value;
    if (widget.showControls.value) {
      _startHideControlsTimer();
    }
  }

  @override
  Widget build(BuildContext context) {
    final player = widget.player;
    final settings = context.watch<SettingsModel>();
    final playerModel = context.watch<PlayerModel>();

    return Material(
      child: Watch.builder(
        builder: (context) {
          final videoWidth = player.videoWidth.value;
          final videoHeight = player.videoHeight.value;
          final showControls =
              widget.showControls.value ||
              widget.showSettings.value ||
              !settings.embeddedVideoPlayer.value;

          final videoController = widget.player.controller;

          if ((videoWidth == 0 || videoWidth == null) ||
              (videoHeight == 0 || videoHeight == null)) {
            return SizedBox.expand();
          }
          return LayoutBuilder(
            builder: (context, constraints) {
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
                  child: GestureDetector(
                    behavior: HitTestBehavior.deferToChild,
                    onTap: _toggleControls,
                    child: Stack(
                      alignment: Alignment.bottomCenter,
                      children: [
                        Stack(
                          children: [
                            Center(
                              child: videoController != null
                                  ? _videoContainer(
                                      videoController,
                                      videoWidth,
                                      videoHeight,
                                    )
                                  : Text('Embedded player disabled'),
                            ),
                            Align(
                              alignment: AlignmentGeometry.bottomCenter,
                              child: Column(
                                children: [
                                  Expanded(
                                    flex: 6,
                                    child: AnimatedSlide(
                                      offset: widget.showSettings.watch(context)
                                          ? Offset.zero
                                          : const Offset(
                                              0,
                                              -1,
                                            ), // Slides in from the right
                                      duration: const Duration(
                                        milliseconds: 300,
                                      ),
                                      curve: Curves.easeInOut,
                                      child: ScriptPlayerSettingsOverlay(),
                                    ),
                                  ),
                                  widget.showFunscriptGraph.watch(context)
                                      ? Expanded(
                                          flex: 1,
                                          child: _funscriptGraph(
                                            playerModel.currentlyOpen,
                                            player,
                                            settings,
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
                                                          showControls: widget
                                                              .showControls,
                                                          showFunscriptGraph: widget
                                                              .showFunscriptGraph,
                                                          showSettings: widget
                                                              .showSettings,
                                                        ),
                                                  ),
                                                );
                                              },
                                        onInteractionStart: () {
                                          _hideControlsTimer?.cancel();
                                        },
                                        onInteractionEnd: () {
                                          _startHideControlsTimer();
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
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      decoration: stdBoxShadow(),
      child: InteractiveScrollingGraph(
        currentlyOpen: currentlyOpen,
        videoPosition: player.smoothPosition,
        viewDuration: settings.funscriptGraphViewDuration,
      ),
    );
  }

  Widget _videoContainer(
    VideoController controller,
    int videoWidth,
    int videoHeight,
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
            child: AspectRatio(
              aspectRatio: videoWidth / videoHeight,
              child: Video(controller: controller, controls: null),
            ),
          ),
        ),
      ],
    );
  }
}
