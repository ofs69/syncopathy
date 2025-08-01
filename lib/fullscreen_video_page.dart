import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:libmpv_dart/libmpv.dart';
import 'package:syncopathy/custom_mpv_video_widget.dart';

class FullscreenVideoPage extends StatefulWidget {
  final Player player;
  final ValueNotifier<VideoParams> videoParamsNotifier;

  const FullscreenVideoPage({
    super.key,
    required this.player,
    required this.videoParamsNotifier,
  });

  @override
  State<FullscreenVideoPage> createState() => _FullscreenVideoPageState();
}

class _FullscreenVideoPageState extends State<FullscreenVideoPage> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onDoubleTap: () {
          Navigator.pop(context);
        },
        child: Center(
          child: Hero(
            tag: 'videoPlayer',
            child: CustomMpvVideoWidget(
              player: widget.player,
              videoParamsNotifier: widget.videoParamsNotifier,
              isFullscreen: true,
            ),
          ),
        ),
      ),
    );
  }
}
