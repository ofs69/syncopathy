import 'package:flutter/material.dart';
import 'package:libmpv_dart/libmpv.dart';
import 'package:syncopathy/model/player_model.dart';

class CustomMpvVideoWidget extends StatefulWidget {
  final PlayerModel player;
  final ValueNotifier<VideoParams> videoParamsNotifier;
  final bool isFullscreen;

  const CustomMpvVideoWidget({
    super.key,
    required this.player,
    required this.videoParamsNotifier,
    this.isFullscreen = false,
  });

  @override
  State<CustomMpvVideoWidget> createState() => _CustomMpvVideoWidgetState();
}

class _CustomMpvVideoWidgetState extends State<CustomMpvVideoWidget> {
  int? _textureId;

  @override
  void initState() {
    super.initState();
    _textureId = widget.player.textureId.value;
    widget.player.textureId.addListener(_updateTextureId);
  }

  void _updateTextureId() {
    if (mounted) {
      setState(() {
        _textureId = widget.player.textureId.value;
      });
    }
  }

  @override
  void dispose() {
    widget.player.textureId.removeListener(_updateTextureId);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_textureId == null) {
      return const Center(child: CircularProgressIndicator());
    }
    return ValueListenableBuilder<VideoParams>(
      valueListenable: widget.videoParamsNotifier,
      builder: (context, videoParams, child) {
        if (videoParams.dw == 0 || videoParams.dh == 0) {
          return const Center(child: CircularProgressIndicator());
        }
        final videoWidget = Texture(textureId: _textureId!);
        return AspectRatio(
          aspectRatio: videoParams.dw / videoParams.dh,
          child: videoWidget,
        );
      },
    );
  }
}
