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
import 'package:syncopathy/helper/throttler.dart';
import 'package:syncopathy/ioc.dart';
import 'package:syncopathy/model/player_model.dart';
import 'package:syncopathy/model/settings_model.dart';
import 'package:syncopathy/player/script_player_settings.dart';
import 'package:syncopathy/player/video_player.dart';
import 'package:syncopathy/scrolling_graph.dart';
import 'package:syncopathy/simple/simple_mode/simple_mode.dart';
import 'package:syncopathy/video_controls.dart';
import 'package:syncopathy/settings_overlay.dart';

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
  // Pointer move/hover fire rapidly; throttle restarting the (allocating) hide
  // timer instead of cancelling+recreating one per event. The 3s hide window
  // makes ~250ms of imprecision invisible.
  final Throttler _controlsThrottle = Throttler(milliseconds: 250);

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
    _controlsThrottle.dispose();
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
          final showSettings = widget.showSettings.value;
          final videoController = widget.player.controller;

          return LayoutBuilder(
            builder: (context, constraints) {
              final videoWidth = player.videoWidth.value;
              final videoHeight = player.videoHeight.value;
              final displayWidth = _computeDisplayWidth(
                constraints,
                videoWidth,
                videoHeight,
              );

              return Listener(
                onPointerMove: (_) => _onPointerActivity(),
                child: MouseRegion(
                  cursor: showControls
                      ? MouseCursor.defer
                      : SystemMouseCursors.none,
                  onExit: (_) => widget.showControls.value = false,
                  onHover: (_) => _onPointerActivity(),
                  child: Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      Stack(
                        children: [
                          if (videoController != null)
                            _videoContainer(
                              videoController,
                              videoWidth,
                              videoHeight,
                            ),
                          Align(
                            alignment: AlignmentGeometry.bottomCenter,
                            child: _buildOverlayColumn(
                              context,
                              player,
                              playerModel,
                              settings,
                              showSettings: showSettings,
                              showControls: showControls,
                              displayWidth: displayWidth,
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

  /// Reveal the controls and (throttled) restart the auto-hide countdown.
  void _onPointerActivity() {
    widget.showControls.value = true;
    _controlsThrottle.run(_startHideControlsTimer);
  }

  /// Width the video actually occupies, so the funscript graph can be bounded
  /// to it rather than the whole area when the video is pillarboxed.
  double _computeDisplayWidth(
    BoxConstraints constraints,
    int? videoWidth,
    int? videoHeight,
  ) {
    if (videoWidth != null &&
        videoHeight != null &&
        videoWidth > 0 &&
        videoHeight > 0) {
      final screenAspect = constraints.maxWidth / constraints.maxHeight;
      final videoAspect = videoWidth / videoHeight;
      if (videoAspect < screenAspect) {
        return constraints.maxHeight * videoAspect;
      }
    }
    return constraints.maxWidth;
  }

  Widget _buildOverlayColumn(
    BuildContext context,
    VideoPlayer player,
    PlayerModel playerModel,
    SettingsModel settings, {
    required bool showSettings,
    required bool showControls,
    required double displayWidth,
  }) {
    return Column(
      children: [
        Expanded(
          flex: 10,
          child: SettingsOverlay(
            showSettings: showSettings,
            child: ScriptPlayerSettings(),
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
                  height: MediaQuery.of(context).size.height * 0.15,
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
              showFunscriptGraph: widget.showFunscriptGraph,
              showSettings: widget.showSettings,
              onFullscreenToggle: () =>
                  _onFullscreenToggle(context, player, settings),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _onFullscreenToggle(
    BuildContext context,
    VideoPlayer player,
    SettingsModel settings,
  ) async {
    if (widget.isFullscreen) {
      if (!kIsWeb) await SimpleMode.exitFullscreen();
      if (!context.mounted) return;
      Navigator.pop(context);
    } else {
      if (!kIsWeb) await SimpleMode.enterFullscreen();
      if (!context.mounted) return;
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => FullscreenVideoPage(
            player: player,
            isEmbeddedPlayerEnabled: settings.embeddedVideoPlayer.value,
            showControls: widget.showControls,
            showFunscriptGraph: widget.showFunscriptGraph,
            showSettings: widget.showSettings,
          ),
        ),
      );
    }
  }

  Widget _funscriptGraph(
    ReadonlySignal<MediaFunscript?> currentlyOpen,
    VideoPlayer player,
    SettingsModel settings,
  ) {
    return Container(
      padding: const EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 0.0),
      decoration: stdBoxShadow(),
      child: ScrollingGraph(
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
