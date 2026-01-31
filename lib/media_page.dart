import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncopathy/media_library.dart';
import 'package:syncopathy/model/player_model.dart';

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
    final player = context.read<PlayerModel>();

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: MediaLibrary(
              onVideoTapped: (v) => player.openVideoAndScript(v, false),
            ),
          ),
        ],
      ),
    );
  }
}
