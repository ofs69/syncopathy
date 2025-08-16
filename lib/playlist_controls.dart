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
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: ToggleButtons(
                isSelected: [playlist.isShuffled],
                onPressed: (int index) {
                  playlist.shuffle();
                  setState(() {});
                },
                borderRadius: BorderRadius.circular(20.0),
                constraints: const BoxConstraints(
                  minWidth: 40.0,
                  minHeight: 40.0,
                ),
                selectedColor: Colors.green,
                children: const <Widget>[
                  Tooltip(message: 'Shuffle', child: Icon(Icons.shuffle)),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: ValueListenableBuilder<bool>(
                valueListenable: model.isLoopingVideo,
                builder: (context, isLooping, child) {
                  return ToggleButtons(
                    isSelected: [isLooping],
                    onPressed: (int index) {
                      model.toggleLoopVideo();
                    },
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
                          isLooping ? Icons.repeat_on_outlined : Icons.repeat,
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
                onPressed: () {
                  playlist.previous();
                  setState(() {});
                },
                tooltip: 'Previous',
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: IconButton(
                icon: const Icon(Icons.skip_next),
                onPressed: () {
                  playlist.next();
                  setState(() {});
                },
                tooltip: 'Next',
              ),
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
