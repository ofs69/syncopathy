import 'package:flutter/material.dart';
import 'package:syncopathy/ioc.dart';
import 'package:syncopathy/media_library/media_library.dart';
import 'package:syncopathy/player/video_player.dart';

class MediaPage extends StatefulWidget {
  const MediaPage({super.key});

  @override
  State<MediaPage> createState() => _MediaPageState();
}

class _MediaPageState extends State<MediaPage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: MediaLibrary(
              onVideoTapped: (v) => getIt.get<VideoPlayer>().openSingleVideo(v),
            ),
          ),
        ],
      ),
    );
  }
}
