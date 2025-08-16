import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncopathy/model/player_model.dart';
import 'package:syncopathy/model/playlist.dart';

class PlaylistControls extends StatefulWidget {
  const PlaylistControls({super.key});

  @override
  State<PlaylistControls> createState() => _PlaylistControlsState();
}

class _PlaylistControlsState extends State<PlaylistControls> {
  @override
  Widget build(BuildContext context) {
    final model = context.watch<PlayerModel>();

    return ValueListenableBuilder<Playlist?>(
      valueListenable: model.playlist,
      builder: (context, playlist, child) {
        if (playlist == null) {
          return const SizedBox.shrink();
        }

        return Row(
          children: [
            IconButton(
              icon: Icon(
                playlist.isShuffled ? Icons.shuffle_on_outlined : Icons.shuffle,
              ),
              color: playlist.isShuffled
                  ? Theme.of(context).colorScheme.primary
                  : null,
              onPressed: () {
                playlist.shuffle();
                setState(() {});
              },
              tooltip: 'Shuffle',
            ),
            IconButton(
              icon: const Icon(Icons.skip_previous),
              onPressed: () {
                playlist.previous();
                setState(() {});
              },
              tooltip: 'Previous',
            ),
            IconButton(
              icon: const Icon(Icons.skip_next),
              onPressed: () {
                playlist.next();
                setState(() {});
              },
              tooltip: 'Next',
            ),
            const SizedBox(width: 8),
            ValueListenableBuilder(
              valueListenable: playlist.currentIndex,
              builder: (context, currentIndex, child) {
                return Text('${currentIndex + 1} / ${playlist.videos.length}');
              },
            ),
          ],
        );
      },
    );
  }
}
