import 'package:flutter/material.dart';
import 'package:syncopathy/events/event_bus.dart';
import 'package:syncopathy/events/player_event.dart';
import 'package:syncopathy/media_library.dart';

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
              onVideoTapped: (v) =>
                  Events.emit(OpenVideoEvent(v)),
            ),
          ),
        ],
      ),
    );
  }
}
