import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:signals/signals_flutter.dart';
import 'package:syncopathy/helper/effect_dispose_mixin.dart';
import 'package:syncopathy/ioc.dart';
import 'package:syncopathy/model/player_model.dart';
import 'package:syncopathy/model/settings_model.dart';
import 'package:syncopathy/player/video_player.dart';
import 'package:syncopathy/video_widget.dart';

class VideoPlayerPage extends StatefulWidget {
  const VideoPlayerPage({super.key});

  @override
  State<VideoPlayerPage> createState() => _VideoPlayerPageState();
}

class _VideoPlayerPageState extends State<VideoPlayerPage>
    with AutomaticKeepAliveClientMixin, EffectDispose, SignalsMixin {
  @override
  bool get wantKeepAlive => true;

  late final Signal<bool> _showSettings = createSignal(false);
  late final Signal<bool> _showControls = createSignal(true);

  @override
  void dispose() {
    effectDispose();
    // Fire-and-forget: dispose() must stay synchronous, and awaiting across the
    // teardown gap risks the chrome reset being dropped.
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.dispose();
  }

  Widget _overlayCard({required Key key, required List<Widget> children}) {
    return Center(
      key: key,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.black54,
          borderRadius: BorderRadius.circular(24),
        ),
        padding: const EdgeInsets.all(24.0),
        child: Column(mainAxisSize: MainAxisSize.min, children: children),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final player = context.read<VideoPlayer>();
    final playerModel = context.read<PlayerModel>();
    final settingsModel = context.read<SettingsModel>();
    final noFunscriptLoaded = playerModel.currentlyOpen.watch(context) == null;
    // Nothing open but a playlist is active → we're between entries (a brief
    // transition), which warrants a spinner rather than the idle empty state.
    final inPlaylistTransition =
        noFunscriptLoaded &&
        player.currentPlaylist.watch(context).entries.isNotEmpty;

    return Stack(
      children: [
        Hero(
          tag: 'videoPlayer',
          child: VideoWidget(
            player: player,
            isFullscreen: false,
            showControls: _showControls,
            showFunscriptGraph: settingsModel.funscriptGraphEnabled,
            showSettings: _showSettings,
          ),
        ),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 500),
          child: !noFunscriptLoaded
              ? const SizedBox.shrink(key: ValueKey("no_loading_overlay"))
              : inPlaylistTransition
              ? _overlayCard(
                  key: const ValueKey('transition_overlay'),
                  children: const [
                    CircularProgressIndicator(),
                    SizedBox(height: 12),
                    Text('Loading next…'),
                  ],
                )
              : _overlayCard(
                  key: const ValueKey('empty_overlay'),
                  children: [
                    const Icon(
                      Icons.movie_outlined,
                      size: 48,
                      color: Colors.white70,
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Nothing playing',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      syncopathySimpleMode
                          ? 'Open a video and funscript to begin.'
                          : 'Pick something from your library to begin.',
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
        ),
      ],
    );
  }
}
