import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:signals/signals_flutter.dart';
import 'package:syncopathy/helper/extensions.dart';
import 'package:syncopathy/player/media_kit_player.dart';

class CustomMpvVideoWidget extends StatefulWidget {
  final MediaKitPlayer player;
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
    final player = widget.player;

    return Watch.builder(
      builder: (context) {
        final videoParams = player.videoParams;
        if (videoParams.value.dw == 0 || videoParams.value.dh == 0) {
          return SizedBox.expand();
        }

        return ClipRect(
          child: Stack(
            children: [
              // Layer 1: The Blurred Backlight
              Positioned.fill(
                child: Transform.scale(
                  scale: 1.1,
                  child: ImageFiltered(
                    imageFilter: ImageFilter.blur(sigmaX: 50, sigmaY: 50),
                    child: FittedBox(
                      fit: BoxFit.cover,
                      child: SizedBox(
                        width: videoParams.value.dw!.toDouble(),
                        height: videoParams.value.dh!.toDouble(),
                        child: Texture(textureId: player.textureId.value),
                      ),
                    ),
                  ),
                ),
              ),

              // Layer 2: Black overlay (optional, for better contrast)
              Positioned.fill(
                child: Container(color: Colors.black.withAlphaF(0.5)),
              ),

              // Layer 3: The Main Video
              Center(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlphaF(0.3),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: AspectRatio(
                    aspectRatio: videoParams.value.dw! / videoParams.value.dh!,
                    child: Texture(textureId: player.textureId.value),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
