
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncopathy/model/playlist.dart';

class PlaylistControls extends StatelessWidget {
  const PlaylistControls({super.key});

  @override
  Widget build(BuildContext context) {
    final playlist = context.watch<Playlist?>();

    if (playlist == null) {
      return const SizedBox.shrink();
    }

    return Row(
      children: [
        IconButton(
          icon: const Icon(Icons.shuffle),
          color: playlist.isShuffled ? Theme.of(context).colorScheme.primary : null,
          onPressed: () => playlist.shuffle(),
          tooltip: 'Shuffle',
        ),
        IconButton(
          icon: const Icon(Icons.skip_previous),
          onPressed: () => playlist.previous(),
          tooltip: 'Previous',
        ),
        IconButton(
          icon: const Icon(Icons.skip_next),
          onPressed: () => playlist.next(),
          tooltip: 'Next',
        ),
      ],
    );
  }
}
