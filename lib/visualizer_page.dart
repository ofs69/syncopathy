import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:syncopathy/model/app_model.dart';
import 'package:syncopathy/scrolling_graph.dart';
import 'package:syncopathy/video_controls.dart';
import 'package:syncopathy/custom_mpv_video_widget.dart';
import 'package:syncopathy/fullscreen_video_page.dart';

class VisualizerPage extends StatefulWidget {
  const VisualizerPage({super.key});

  @override
  State<VisualizerPage> createState() => _VisualizerPageState();
}

class _VisualizerPageState extends State<VisualizerPage> with AutomaticKeepAliveClientMixin {
  bool _isFullscreen = false;

  @override
  bool get wantKeepAlive => true;

  void _toggleFullscreen() {
    setState(() {
      _isFullscreen = !_isFullscreen;
    });
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // Call super.build(context)
    final model = context.watch<SyncopathyModel>();

    enterFullscreen() => Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FullscreenVideoPage(
          player: model.mpvPlayer.player,
          videoParamsNotifier: model.mpvPlayer.player.videoParams,
        ),
      ),
    ).then((_) => _toggleFullscreen());

    return ValueListenableBuilder(
      valueListenable: model.funscript,
      builder: (context, funscript, child) {
        if (funscript == null) {
          return const Center(child: Text('No funscript loaded'));
        }
        return Scaffold(
          body: Column(
            children: [
              Expanded(
                flex: 6,
                child: model.settings.embeddedVideoPlayer
                    ? GestureDetector(
                        onDoubleTap: enterFullscreen,
                        child: Hero(
                          tag: 'videoPlayer',
                          child: CustomMpvVideoWidget(
                            player: model.mpvPlayer.player,
                            videoParamsNotifier:
                                model.mpvPlayer.player.videoParams,
                          ),
                        ),
                      )
                    : const Center(
                        child: Text(
                          'Embedded video player is disabled in settings.',
                        ),
                      ),
              ),
              Expanded(
                flex: 1,
                child: InteractiveScrollingGraph(
                  funscript: funscript,
                  videoPosition: model.positionNoOffset,
                ),
              ),
              VideoControls(
                isFullscreen: _isFullscreen,
                onFullscreenToggle: enterFullscreen,
              ),
            ],
          ),
        );
      },
    );
  }
}
