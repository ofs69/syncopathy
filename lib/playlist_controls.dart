import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:signals/signals_flutter.dart';
import 'package:syncopathy/model/player_model.dart';

class PlaylistControls extends StatefulWidget {
  const PlaylistControls({super.key});

  @override
  State<PlaylistControls> createState() => _PlaylistControlsState();
}

class _PlaylistControlsState extends State<PlaylistControls> {
  @override
  Widget build(BuildContext context) {
    final model = context.watch<PlayerModel>();

    return Watch.builder(
      builder: (context) {
        final playlist = model.playlist.value;
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
              child: Watch.builder(
                builder: (context) {
                  final isLooping = model.isLoopingVideo.value;
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
            Watch.builder(
              builder: (context) {
                final currentIndex = playlist.currentIndex.value;
                return Text('${currentIndex + 1} / ${playlist.videos.length}');
              },
            ),
          ],
        );
      },
    );
  }
}
