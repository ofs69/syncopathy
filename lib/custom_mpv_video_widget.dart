import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:signals/signals_flutter.dart';
import 'package:syncopathy/model/player_model.dart';

class CustomMpvVideoWidget extends StatefulWidget {
  final PlayerModel player;
  final bool isFullscreen;

  const CustomMpvVideoWidget({
    super.key,
    required this.player,
    this.isFullscreen = false,
  });

  @override
  State<CustomMpvVideoWidget> createState() => _CustomMpvVideoWidgetState();
}

class _CustomMpvVideoWidgetState extends State<CustomMpvVideoWidget> {
  @override
  Widget build(BuildContext context) {
    final player = context.read<PlayerModel>();

    return Watch.builder(
      builder: (context) {
        final videoParams = player.videoParams;
        if (videoParams.value.dw == 0 || videoParams.value.dh == 0) {
          return const Center(child: CircularProgressIndicator());
        }

        return AspectRatio(
          aspectRatio: videoParams.value.dw / videoParams.value.dh,
          child: Texture(textureId: player.textureId.watch(context)),
        );
      },
    );
  }
}
