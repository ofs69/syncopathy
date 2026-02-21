import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:signals/signals_flutter.dart';
import 'package:syncopathy/connection_button.dart';
import 'package:syncopathy/events/event_bus.dart';
import 'package:syncopathy/events/player_event.dart';
import 'package:syncopathy/home_button.dart';
import 'package:syncopathy/media_manager.dart';
import 'package:syncopathy/model/battery_model.dart';
import 'package:syncopathy/model/player_model.dart';
import 'package:syncopathy/player/mpv.dart';
import 'package:syncopathy/playlist_controls.dart';
import 'package:syncopathy/sqlite/models/video_model.dart';
import 'package:syncopathy/helper/constants.dart';
import 'package:window_manager/window_manager.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key, required this.widgetTitle});

  final String widgetTitle;

  @override
  CustomAppBarState createState() => CustomAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class CustomAppBarState extends State<CustomAppBar> {
  @override
  Widget build(BuildContext context) {
    final mediaManager = context.read<MediaManager?>();
    final player = context.read<MpvVideoplayer>();
    final batteryModel = context.read<BatteryModel>();
    final playerModel = context.read<PlayerModel>();

    final hasBattery = batteryModel.hasBattery.watch(context);
    final chargerConnected = batteryModel.chargerConntected.watch(context);
    final currentPlaylist = player.currentPlaylist.watch(context);
    final currentVideo = playerModel.currentVideo.watch(context);

    return AppBar(
      backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      flexibleSpace: DragToMoveArea(
        child: Container(color: Colors.transparent),
      ),
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
        SizedBox(width: 8),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          transitionBuilder: (Widget child, Animation<double> animation) {
            return FadeTransition(opacity: animation, child: child);
          },
          child: actionRow(
            currentVideo,
            mediaManager,
            currentPlaylist.entries.length > 1,
          ),
        ),
        if (currentVideo != null) const SizedBox(width: 16),
        const PlaylistControls(),
        const SizedBox(width: 8),

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
        // Window control buttons
        WindowCaptionButton.minimize(
          brightness: Theme.of(context).brightness,
          onPressed: () => windowManager.minimize(),
        ),
        WindowCaptionButton.maximize(
          brightness: Theme.of(context).brightness,
          onPressed: () async => await windowManager.isMaximized()
              ? windowManager.restore()
              : windowManager.maximize(),
        ),
        WindowCaptionButton.close(
          brightness: Theme.of(context).brightness,
          onPressed: () => windowManager.close(),
        ),
      ],
    );
  }

  Widget actionRow(
    Video? currentVideo,
    MediaManager? mediaManager,
    bool playlist,
  ) {
    if (currentVideo == null) return const SizedBox.shrink();
    return Row(
      children: [
        if (mediaManager != null)
          IconButton(
            icon: Icon(
              currentVideo.isFavorite ? Icons.star : Icons.star_border,
              color: currentVideo.isFavorite ? favoriteColor : null,
            ),
            onPressed: () {
              setState(() {
                currentVideo.isFavorite = !currentVideo.isFavorite;
                if (currentVideo.isFavorite) {
                  currentVideo.isDislike = false;
                }
              });
              mediaManager.saveFavorite(currentVideo);
            },
            tooltip: currentVideo.isFavorite
                ? 'Remove from Favorites'
                : 'Add to Favorites',
          ),
        if (mediaManager != null)
          IconButton(
            icon: Icon(
              currentVideo.isDislike
                  ? Icons.thumb_down
                  : Icons.thumb_down_off_alt,
              color: currentVideo.isDislike ? dislikeColor : null,
            ),
            onPressed: () {
              setState(() {
                currentVideo.isDislike = !currentVideo.isDislike;
                if (currentVideo.isDislike) {
                  currentVideo.isFavorite = false;
                }
              });
              mediaManager.saveDislike(currentVideo);
            },
            tooltip: currentVideo.isDislike
                ? 'Remove Dislike'
                : 'Dislike Video',
          ),
        if (mediaManager != null) const SizedBox(width: 16),
        IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Events.emit(CloseMediaEvent()),
          tooltip: playlist ? 'Close Playlist' : 'Close Video',
        ),
      ],
    );
  }
}
