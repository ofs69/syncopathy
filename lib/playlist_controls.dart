import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:signals/signals_flutter.dart';
import 'package:syncopathy/helper/constants.dart';
import 'package:syncopathy/player/video_player.dart';

class PlaylistControls extends StatefulWidget {
  const PlaylistControls({super.key});

  @override
  State<PlaylistControls> createState() => _PlaylistControlsState();
}

class _PlaylistControlsState extends State<PlaylistControls> {
  @override
  Widget build(BuildContext context) {
    final player = context.read<VideoPlayer>();

    return Watch.builder(
      builder: (context) {
        final playlist = player.currentPlaylist.value;

        if (playlist.entries.length <= 1) {
          return const SizedBox.shrink();
        }

        final isShuffled = player.playlistShuffled.watch(context);
        return Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: ToggleButtons(
                isSelected: [isShuffled],
                onPressed: (int index) =>
                    player.setPlaylistShuffle(!isShuffled),
                borderRadius: BorderRadius.circular(20.0),
                constraints: const BoxConstraints(
                  minWidth: 40.0,
                  minHeight: 40.0,
                ),
                selectedColor: successColor,
                children: [
                  Tooltip(message: 'Shuffle', child: Icon(Icons.shuffle)),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Watch.builder(
                builder: (context) {
                  final isLooping = player.loopFile.value;
                  return ToggleButtons(
                    isSelected: [isLooping],
                    onPressed: (int index) => player.toggleLooping(),
                    borderRadius: BorderRadius.circular(20.0),
                    constraints: const BoxConstraints(
                      minWidth: 40.0,
                      minHeight: 40.0,
                    ),
                    selectedColor: successColor,
                    children: <Widget>[
                      // Selected state is conveyed by ToggleButtons' selectedColor;
                      // a single consistent icon avoids the contradictory swap.
                      Tooltip(
                        message: 'Loop',
                        child: Icon(Icons.repeat),
                      ),
                    ],
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: IconButton(
                icon: const Icon(Icons.skip_previous),
                onPressed: () => player.jumpPreviousPlaylistEntry(),
                tooltip: 'Previous',
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: IconButton(
                icon: const Icon(Icons.skip_next),
                onPressed: () => player.jumpNextPlaylistEntry(),
                tooltip: 'Next',
              ),
            ),
            const SizedBox(width: 8),
            Tooltip(
              message: 'Playlist position',
              child: Text(
                '${playlist.currentIndex.watch(context) + 1} / ${playlist.entries.length}',
              ),
            ),
          ],
        );
      },
    );
  }
}
