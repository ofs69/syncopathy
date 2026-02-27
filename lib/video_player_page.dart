import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:signals/signals_flutter.dart';
import 'package:syncopathy/events/event_bus.dart';
import 'package:syncopathy/events/event_subscriber_mixin.dart';
import 'package:syncopathy/events/player_event.dart';
import 'package:syncopathy/helper/extensions.dart';
import 'package:syncopathy/model/funscript.dart';
import 'package:syncopathy/model/player_model.dart';
import 'package:syncopathy/model/settings_model.dart';
import 'package:syncopathy/player/media_kit_player.dart';
import 'package:syncopathy/scrolling_graph.dart';
import 'package:syncopathy/video_controls.dart';
import 'package:syncopathy/custom_mpv_video_widget.dart';
import 'package:syncopathy/fullscreen_video_page.dart';
import 'package:syncopathy/video_player_settings_overlay.dart';
import 'package:web/web.dart' as web;

class VideoPlayerPage extends StatefulWidget {
  const VideoPlayerPage({super.key});

  @override
  State<VideoPlayerPage> createState() => _VideoPlayerPageState();
}

class _VideoPlayerPageState extends State<VideoPlayerPage>
    with EventSubscriber, AutomaticKeepAliveClientMixin {
  final Signal<bool> _showFunscriptGraph = signal(true);
  final Signal<bool> _showSettings = signal(false);

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();

    eventSubs([
      Events.on<CloseMediaEvent>().listen(
        (event) => _showSettings.value = false,
      ),
    ]);
  }

  @override
  void dispose() async {
    await eventDispose();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final settings = context.watch<SettingsModel>();
    final player = context.watch<MediaKitPlayer>();
    final playerModel = context.watch<PlayerModel>();
    final noFunscriptLoaded =
        playerModel.currentFunscript.watch(context) == null;

    enterFullscreen() {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => FullscreenVideoPage(
            player: player,
            isEmbeddedPlayerEnabled: true,
          ),
        ),
      );
    }

    toggleSettings() => _showSettings.value = !_showSettings.value;

    return Column(
      children: [
        Expanded(
          flex: 6,
          child: Stack(
            alignment: Alignment.center,
            children: [
              if (player.controller != null)
                Hero(
                  tag: 'videoPlayer',
                  child: CustomMpvVideoWidget(
                    player: player,
                    controller: player.controller!,
                  ),
                )
              else
                Center(
                  child: noFunscriptLoaded
                      ? SizedBox.shrink()
                      : Text('Embedded player disabled'),
                ),

              if (noFunscriptLoaded)
                Container(
                  color: Colors.black54,
                  child: Text("No funscript loaded"),
                ),

              Align(
                alignment: AlignmentGeometry.bottomCenter,
                child: Column(
                  children: [
                    Expanded(
                      flex: 6,
                      child: AnimatedSlide(
                        offset: _showSettings.watch(context)
                            ? Offset.zero
                            : const Offset(0, -1), // Slides in from the right
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                        child: ScriptPlayerSettingsOverlay(
                          toggleSettings: toggleSettings,
                        ),
                      ),
                    ),
                    _showFunscriptGraph.watch(context)
                        ? Expanded(
                            flex: 1,
                            child: _funscriptGraph(
                              playerModel.currentFunscript,
                              player,
                              settings,
                            ),
                          )
                        : const SizedBox.shrink(),
                  ],
                ),
              ),
            ],
          ),
        ),
        Hero(
          tag: 'videoControls',
          child: VideoControls(
            onFullscreenToggle: player.controller != null
                ? enterFullscreen
                : null,
            showFunscriptGraph: _showFunscriptGraph,
            showSettings: _showSettings,
          ),
        ),
      ],
    );
  }

  ClipRect _funscriptGraph(
    ReadonlySignal<Funscript?> funscript,
    MediaKitPlayer player,
    SettingsModel settings,
  ) {
    return ClipRect(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
        decoration: BoxDecoration(color: Colors.black.withAlphaF(0.7)),
        child: InteractiveScrollingGraph(
          funscript: funscript,
          videoPosition: player.smoothPosition,
          viewDuration: settings.funscriptGraphViewDuration,
        ),
      ),
    );
  }
}
