import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:syncopathy/model/app_model.dart';
import 'package:syncopathy/model/funscript.dart';
import 'package:syncopathy/model/player_model.dart';
import 'package:syncopathy/scrolling_graph.dart';
import 'package:syncopathy/video_controls.dart';
import 'package:syncopathy/custom_mpv_video_widget.dart';
import 'package:syncopathy/fullscreen_video_page.dart';

class VideoPlayerPage extends StatefulWidget {
  const VideoPlayerPage({super.key, this.focusNode});

  final FocusNode? focusNode;

  @override
  State<VideoPlayerPage> createState() => _VideoPlayerPageState();
}

class TogglePauseIntent extends Intent {
  const TogglePauseIntent();
}

class TogglePauseAction extends Action<TogglePauseIntent> {
  TogglePauseAction(this.playerModel);

  final PlayerModel playerModel;

  @override
  void invoke(TogglePauseIntent intent) {
    playerModel.togglePause();
  }
}

class _VideoPlayerPageState extends State<VideoPlayerPage>
    with AutomaticKeepAliveClientMixin {
  final FocusNode _focusNode = FocusNode();

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _focusNode.requestFocus();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final model = context.watch<SyncopathyModel>();
    final player = context.watch<PlayerModel>();

    enterFullscreen() => Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FullscreenVideoPage(
          player: player.mpvPlayer.player,
          videoParamsNotifier: player.mpvPlayer.player.videoParams,
        ),
      ),
    );

    return Shortcuts(
      shortcuts: <LogicalKeySet, Intent>{
        LogicalKeySet(LogicalKeyboardKey.space): const TogglePauseIntent(),
      },
      child: Actions(
        actions: <Type, Action<Intent>>{
          TogglePauseIntent: TogglePauseAction(player),
        },
        child: Focus(
          focusNode: widget.focusNode,
          autofocus: true,
          child: ValueListenableBuilder<Funscript?>(
            valueListenable: player.funscript,
            builder: (context, funscript, child) {
              if (funscript == null) {
                return const Center(child: Text('No funscript loaded'));
              }
              return Scaffold(
                body: Column(
                  children: [
                    Expanded(
                      flex: 6,
                      child: model.settings.embeddedVideoPlayer.value
                          ? GestureDetector(
                              onDoubleTap: enterFullscreen,
                              child: Hero(
                                tag: 'videoPlayer',
                                child: CustomMpvVideoWidget(
                                  player: player.mpvPlayer.player,
                                  videoParamsNotifier:
                                      player.mpvPlayer.player.videoParams,
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
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16.0,
                          vertical: 8.0,
                        ),
                        child: InteractiveScrollingGraph(
                          funscript: funscript,
                          videoPosition: player.positionNoOffset,
                        ),
                      ),
                    ),
                    Hero(
                      tag: 'videoControls',
                      child: VideoControls(onFullscreenToggle: enterFullscreen),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
