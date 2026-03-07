import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:signals/signals_flutter.dart';
import 'package:syncopathy/events/event_bus.dart';
import 'package:syncopathy/events/player_event.dart';
import 'package:syncopathy/player/media_kit_player.dart';

class PlaylistControls extends StatefulWidget {
  const PlaylistControls({super.key});

  @override
  State<PlaylistControls> createState() => _PlaylistControlsState();
}

class _PlaylistControlsState extends State<PlaylistControls> {
  @override
  Widget build(BuildContext context) {
    final player = context.read<MediaKitPlayer>();

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
                    Events.emit(PlaylistSetShuffleEvent(!isShuffled)),
                borderRadius: BorderRadius.circular(20.0),
                constraints: const BoxConstraints(
                  minWidth: 40.0,
                  minHeight: 40.0,
                ),
                selectedColor: Colors.green,
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
                    selectedColor: Colors.green,
                    children: <Widget>[
                      Tooltip(
                        message: 'Loop',
                        child: Icon(
                          isLooping ? Icons.repeat_outlined : Icons.repeat,
                        ),
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
                onPressed: () => Events.emit(PlaylistPreviousEvent()),
                tooltip: 'Previous',
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: IconButton(
                icon: const Icon(Icons.skip_next),
                onPressed: () => Events.emit(PlaylistNextEvent()),
                tooltip: 'Next',
              ),
            ),
            const SizedBox(width: 8),
            Text(
              '${playlist.currentIndex.watch(context) + 1} / ${playlist.entries.length}',
            ),
          ],
        );
      },
    );
  }
}
