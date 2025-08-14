import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncopathy/model/app_model.dart';
import 'package:syncopathy/media_library.dart';
import 'package:syncopathy/model/player_model.dart';

import 'package:syncopathy/media_manager.dart';

class MediaPage extends StatefulWidget {
  final MediaManager mediaManager;
  const MediaPage({super.key, required this.mediaManager});

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
    final model = context.read<SyncopathyModel>();
    final player = context.read<PlayerModel>();

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: MediaLibrary(
              mediaManager: model.mediaManager,
              onVideoTapped: (v) => player.openVideoAndScript(v),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              ElevatedButton.icon(
                onPressed: () => player.closeVideo(),
                icon: const Icon(Icons.close),
                label: const Text('Close Video'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}