import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:signals/signals_flutter.dart';
import 'package:syncopathy/helper/effect_dispose_mixin.dart';
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
  void dispose() async {
    effectDispose();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final player = context.read<VideoPlayer>();
    final playerModel = context.read<PlayerModel>();
    final settingsModel = context.read<SettingsModel>();
    final noFunscriptLoaded = playerModel.currentlyOpen.watch(context) == null;

    return Column(
      children: [
        Expanded(
          flex: 6,
          child: Stack(
            alignment: Alignment.center,
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

              if (noFunscriptLoaded)
                Container(
                  color: Colors.black54,
                  child: Text("No funscript loaded"),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
