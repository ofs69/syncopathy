import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:signals/signals_flutter.dart';
import 'package:syncopathy/connection_button.dart';
import 'package:syncopathy/media_manager.dart';
import 'package:syncopathy/model/battery_model.dart';
import 'package:syncopathy/model/player_model.dart';
import 'package:syncopathy/sqlite/models/video_model.dart';
import 'package:syncopathy/playlist_controls.dart';
import 'package:syncopathy/update_checker_widget.dart';
import 'package:syncopathy/helper/constants.dart';
import 'package:window_manager/window_manager.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  const CustomAppBar({
    super.key,
    required this.currentVideoTitle,
    required this.widgetTitle,
    required this.currentVideo,
    required this.player,
  });

  final String? currentVideoTitle;
  final String widgetTitle;
  final Video? currentVideo;
  final PlayerModel player;

  @override
  CustomAppBarState createState() => CustomAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class CustomAppBarState extends State<CustomAppBar> {
  @override
  Widget build(BuildContext context) {
    final mediaManager = context.read<MediaManager>();
    final player = context.read<PlayerModel>();
    final batteryModel = context.read<BatteryModel>();

    var hasBattery = batteryModel.hasBattery.watch(context);
    var chargerConnected = batteryModel.chargerConntected.watch(context);

    return AppBar(
      backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      title: DragToMoveArea(
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          transitionBuilder: (Widget child, Animation<double> animation) {
            return FadeTransition(opacity: animation, child: child);
          },
          child: Align(
            key: ValueKey<String>(
              widget.currentVideoTitle ?? widget.widgetTitle,
            ),
            alignment: Alignment.centerLeft,
            child: Text(
              widget.currentVideoTitle ?? widget.widgetTitle,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              softWrap: false,
            ),
          ),
        ),
      ),
      actions: [
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          transitionBuilder: (Widget child, Animation<double> animation) {
            return FadeTransition(opacity: animation, child: child);
          },
          child: widget.currentVideo != null
              ? Row(
                  key: const ValueKey<bool>(true),
                  children: [
                    IconButton(
                      icon: Icon(
                        widget.currentVideo!.isFavorite
                            ? Icons.star
                            : Icons.star_border,
                        color: widget.currentVideo!.isFavorite
                            ? favoriteColor
                            : null,
                      ),
                      onPressed: () {
                        setState(() {
                          widget.currentVideo!.isFavorite =
                              !widget.currentVideo!.isFavorite;
                          if (widget.currentVideo!.isFavorite) {
                            widget.currentVideo!.isDislike = false;
                          }
                        });
                        mediaManager.saveFavorite(widget.currentVideo!);
                      },
                      tooltip: widget.currentVideo!.isFavorite
                          ? 'Remove from Favorites'
                          : 'Add to Favorites',
                    ),
                    IconButton(
                      icon: Icon(
                        widget.currentVideo!.isDislike
                            ? Icons.thumb_down
                            : Icons.thumb_down_off_alt,
                        color: widget.currentVideo!.isDislike
                            ? dislikeColor
                            : null,
                      ),
                      onPressed: () {
                        setState(() {
                          widget.currentVideo!.isDislike =
                              !widget.currentVideo!.isDislike;
                          if (widget.currentVideo!.isDislike) {
                            widget.currentVideo!.isFavorite = false;
                          }
                        });
                        mediaManager.saveDislike(widget.currentVideo!);
                      },
                      tooltip: widget.currentVideo!.isDislike
                          ? 'Remove Dislike'
                          : 'Dislike Video',
                    ),
                    const SizedBox(width: 16),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => player.closeVideoOrPlaylist(),
                      tooltip: player.playlist.value != null
                          ? 'Close Playlist'
                          : 'Close Video',
                    ),
                  ],
                )
              : const SizedBox.shrink(key: ValueKey<bool>(false)),
        ),
        if (widget.player.playlist.value != null) const SizedBox(width: 16),
        const PlaylistControls(),
        const SizedBox(width: 24),
        const UpdateCheckerWidget(),
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
}
