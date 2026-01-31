import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:syncopathy/model/funscript.dart';
import 'package:syncopathy/model/player_model.dart';
import 'package:syncopathy/model/settings_model.dart';
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

class NextPlaylistEntryIntent extends Intent {
  const NextPlaylistEntryIntent();
}

class NextPlaylistEntryAction extends Action<NextPlaylistEntryIntent> {
  NextPlaylistEntryAction(this.playerModel);

  final PlayerModel playerModel;

  @override
  void invoke(NextPlaylistEntryIntent intent) {
    playerModel.playlist.value?.next();
  }
}

class PreviousPlaylistEntryIntent extends Intent {
  const PreviousPlaylistEntryIntent();
}

class PreviousPlaylistEntryAction extends Action<PreviousPlaylistEntryIntent> {
  PreviousPlaylistEntryAction(this.playerModel);

  final PlayerModel playerModel;

  @override
  void invoke(PreviousPlaylistEntryIntent intent) {
    playerModel.playlist.value?.previous();
  }
}

class _VideoPlayerPageState extends State<VideoPlayerPage>
    with AutomaticKeepAliveClientMixin {
  final FocusNode _focusNode = FocusNode();
  late final ValueNotifier<bool> _showFunscriptGraphNotifier;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _focusNode.requestFocus();
    _showFunscriptGraphNotifier = ValueNotifier<bool>(true);
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _showFunscriptGraphNotifier.dispose();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.dispose();
  }

  void _onToggleFunscriptGraph(bool value) {
    _showFunscriptGraphNotifier.value = value;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final settings = context.watch<SettingsModel>();
    final player = context.watch<PlayerModel>();

    enterFullscreen() => Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FullscreenVideoPage(
          player: player,
          videoParamsNotifier: player.videoParams,
          isEmbeddedPlayerEnabled: settings.embeddedVideoPlayer.value,
        ),
      ),
    );

    return Shortcuts(
      shortcuts: <LogicalKeySet, Intent>{
        LogicalKeySet(LogicalKeyboardKey.space): const TogglePauseIntent(),
        LogicalKeySet(LogicalKeyboardKey.arrowRight):
            const NextPlaylistEntryIntent(),
        LogicalKeySet(LogicalKeyboardKey.arrowLeft):
            const PreviousPlaylistEntryIntent(),
      },
      child: Actions(
        actions: <Type, Action<Intent>>{
          TogglePauseIntent: TogglePauseAction(player),
          NextPlaylistEntryIntent: NextPlaylistEntryAction(player),
          PreviousPlaylistEntryIntent: PreviousPlaylistEntryAction(player),
        },
        child: Focus(
          focusNode: widget.focusNode,
          autofocus: true,
          child: ValueListenableBuilder<Funscript?>(
            valueListenable: player.currentFunscript,
            builder: (context, funscript, child) {
              if (funscript == null) {
                return const Center(child: Text('No funscript loaded'));
              }
              return Scaffold(
                body: Column(
                  children: [
                    Expanded(
                      flex: 6,
                      child: settings.embeddedVideoPlayer.value
                          ? GestureDetector(
                              onDoubleTap: enterFullscreen,
                              child: Hero(
                                tag: 'videoPlayer',
                                child: CustomMpvVideoWidget(
                                  player: player,
                                  videoParamsNotifier: player.videoParams,
                                ),
                              ),
                            )
                          : const Center(
                              child: Text(
                                'Embedded video player is disabled in settings.',
                              ),
                            ),
                    ),
                    ValueListenableBuilder<bool>(
                      valueListenable: _showFunscriptGraphNotifier,
                      builder: (context, showGraph, child) {
                        if (showGraph) {
                          return Expanded(
                            flex: 1,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8.0,
                                vertical: 4.0,
                              ),
                              child: InteractiveScrollingGraph(
                                funscript: funscript,
                                videoPosition: player.positionNoOffset,
                              ),
                            ),
                          );
                        } else {
                          return const SizedBox.shrink();
                        }
                      },
                    ),
                    Hero(
                      tag: 'videoControls',
                      child: VideoControls(
                        onFullscreenToggle: enterFullscreen,
                        onToggleFunscriptGraph: _onToggleFunscriptGraph,
                        showFunscriptGraphNotifier: _showFunscriptGraphNotifier,
                      ),
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
