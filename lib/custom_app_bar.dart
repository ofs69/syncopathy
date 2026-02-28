import 'dart:async';
import 'dart:js_interop';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:signals/signals_flutter.dart';
import 'package:syncopathy/connection_button.dart';
import 'package:syncopathy/events/event_bus.dart';
import 'package:syncopathy/events/player_event.dart';
import 'package:syncopathy/helper/extensions.dart';
import 'package:syncopathy/home_button.dart';
import 'package:syncopathy/logging.dart';
import 'package:syncopathy/model/battery_model.dart';
import 'package:syncopathy/model/player_model.dart';
import 'package:syncopathy/model/video.dart';
import 'package:syncopathy/player/media_kit_player.dart';
import 'package:web/web.dart' as web;

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key, required this.widgetTitle});

  final String widgetTitle;

  @override
  CustomAppBarState createState() => CustomAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class CustomAppBarState extends State<CustomAppBar> with SignalsMixin {
  bool fullscreen = false;

  @override
  Widget build(BuildContext context) {
    final player = context.read<MediaKitPlayer>();
    final batteryModel = context.read<BatteryModel>();
    final playerModel = context.read<PlayerModel>();

    final hasBattery = batteryModel.hasBattery.watch(context);
    final chargerConnected = batteryModel.chargerConntected.watch(context);
    // ignore: unused_local_variable
    final currentPlaylist = player.currentPlaylist.watch(context);
    final currentVideo = playerModel.currentVideo.watch(context);

    return AppBar(
      backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      title: IgnorePointer(
        ignoring: true,
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          transitionBuilder: (Widget child, Animation<double> animation) {
            return FadeTransition(opacity: animation, child: child);
          },
          child: Align(
            key: ValueKey<String>(currentVideo?.title ?? widget.widgetTitle),
            alignment: Alignment.centerLeft,
            child: Text(
              currentVideo?.title ?? widget.widgetTitle,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              softWrap: false,
            ),
          ),
        ),
      ),
      actions: [
        HomeButton(),
        SizedBox(width: 4),
        IconButton(
          icon: const Icon(Icons.fullscreen),
          tooltip: "Fullscreen",
          onPressed: () {
            final element = web.document.documentElement;

            if (element != null) {
              // Check if we are already in fullscreen
              if (web.document.fullscreenElement == null) {
                // Request Fullscreen
                element.requestFullscreen();
              } else {
                // Exit Fullscreen
                web.document.exitFullscreen();
              }
            }
          },
        ),
        SizedBox(width: 4),
        TextButton.icon(
          label: Text("Open files..."),
          onPressed: _loadFile,
          icon: Icon(Icons.open_in_browser),
          style: TextButton.styleFrom(
            side: BorderSide(
              color: Theme.of(context).colorScheme.outline.withAlphaF(0.5),
              width: 1.0,
            ),
          ),
        ),
        // AnimatedSwitcher(
        //   duration: const Duration(milliseconds: 300),
        //   transitionBuilder: (Widget child, Animation<double> animation) {
        //     return FadeTransition(opacity: animation, child: child);
        //   },
        //   child: actionRow(currentVideo, currentPlaylist.entries.length > 1),
        // ),
        // const PlaylistControls(),
        const SizedBox(width: 4),

        if (hasBattery)
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Row(
              children: [
                Icon(
                  chargerConnected
                      ? Icons.battery_charging_full
                      : Icons.battery_full,
                  color: chargerConnected
                      ? Colors.green
                      : (batteryModel.batteryLevel.value < 20
                            ? Colors.red
                            : null),
                ),
                Text('${batteryModel.batteryLevel.watch(context)}%'),
              ],
            ),
          ),
        const Padding(
          padding: EdgeInsets.only(right: 8.0),
          child: ConnectionButton(),
        ),
      ],
    );
  }

  Widget actionRow(Video? currentVideo, bool playlist) {
    if (currentVideo == null) return const SizedBox.shrink();
    return Row(
      children: [
        IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Events.emit(CloseMediaEvent()),
          tooltip: playlist ? 'Close Playlist' : 'Close Video',
        ),
      ],
    );
  }

  Future<String> readBlobUrlAsString(String blobUrl) async {
    // 1. Fetch the data from the Blob URL
    final response = await web.window.fetch(blobUrl.toJS).toDart;

    // 2. Convert the response body to a Blob object
    final web.Blob blob = await response.blob().toDart;

    // 3. Create a FileReader to read the Blob as text
    final reader = web.FileReader();
    final completer = Completer<String>();

    reader.onLoadEnd.listen((event) {
      // The result contains the string content of the file
      completer.complete(reader.result.toString());
    });

    reader.readAsText(blob);

    return completer.future;
  }

  Future<List<(String, String, String)>> pickFileAndGetBlobUrl() async {
    // 1. Create a hidden HTML input element
    final web.HTMLInputElement input =
        web.document.createElement('input') as web.HTMLInputElement;
    input.type = 'file';
    input.accept = 'audio/*,video/*,.funscript';
    input.multiple = true;

    // 2. Create a "Completer" to wait for the user's selection
    final completer = Completer<List<(String, String, String)>>();

    // 3. Listen for the 'change' event (when the user selects a file)
    input.onChange.listen((event) {
      if (input.files != null && input.files!.length > 0) {
        final result = <(String, String, String)>[];
        for (int i = 0; i < input.files!.length; i += 1) {
          final web.File file = input.files!.item(i)!;
          final name = file.name;
          final mimeType = file.type;

          // 4. Generate the Blob URL
          final String blobUrl = web.URL.createObjectURL(file);
          result.add((name, blobUrl, mimeType));
        }
        completer.complete(result);
      } else {
        completer.complete([]);
      }
    });

    // 5. Trigger the file picker dialog
    input.click();

    return completer.future;
  }

  Future<void> _loadFile() async {
    final playerModel = context.read<PlayerModel>();

    // 1. Open the file picker dialog
    final result = await pickFileAndGetBlobUrl();

    if (result.isNotEmpty) {
      try {
        for (final file in result) {
          playerModel.openFile(
            file.$1,
            file.$2,
            file.$3,
            () => readBlobUrlAsString(file.$2),
          );
        }
      } catch (e) {
        Logger.error(e.toString());
      }
    }
  }
}
