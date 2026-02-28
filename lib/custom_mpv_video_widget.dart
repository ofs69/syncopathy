
import 'package:flutter/material.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:signals/signals_flutter.dart';
import 'package:syncopathy/helper/extensions.dart';
import 'package:syncopathy/player/media_kit_player.dart';

class CustomMpvVideoWidget extends StatefulWidget {
  final MediaKitPlayer player;
  final VideoController controller;

  const CustomMpvVideoWidget({
    super.key,
    required this.player,
    required this.controller,
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
        final videoWidth = player.videoWidth.value;
        final videoHeight = player.videoHeight.value;

        if ((videoWidth == 0 || videoWidth == null) ||
            (videoHeight == 0 || videoHeight == null)) {
          return SizedBox.expand();
        }

        return ClipRect(
          child: Stack(
            children: [
              // Layer 1: The Blurred Backlight
              // Positioned.fill(
              //   child: Transform.scale(
              //     scale: 1.1,
              //     child: ImageFiltered(
              //       imageFilter: ImageFilter.blur(sigmaX: 50, sigmaY: 50),
              //       child: FittedBox(
              //         fit: BoxFit.cover,
              //         child: SizedBox(
              //           width: videoWidth.toDouble(),
              //           height: videoHeight.toDouble(),
              //           child: Video(
              //             controller: widget.controller,
              //             controls: null,
              //           ),
              //         ),
              //       ),
              //     ),
              //   ),
              // ),

              // Layer 2: Black overlay (optional, for better contrast)
              // Positioned.fill(
              //   child: Container(color: Colors.black.withAlphaF(0.5)),
              // ),

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
                    aspectRatio: videoWidth / videoHeight,
                    child: Video(controller: widget.controller, controls: null),
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
