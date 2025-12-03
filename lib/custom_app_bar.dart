import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:syncopathy/connection_button.dart';
import 'package:syncopathy/model/app_model.dart';
import 'package:syncopathy/model/player_model.dart';
import 'package:syncopathy/sqlite/models/video_model.dart';
import 'package:syncopathy/playlist_controls.dart';
import 'package:syncopathy/update_checker_widget.dart';
import 'package:syncopathy/helper/constants.dart';
import 'package:window_manager/window_manager.dart';
import 'package:syncopathy/generated/constants.pb.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  const CustomAppBar({
    super.key,
    required this.currentVideoTitle,
    required this.widgetTitle,
    required this.currentVideo,
    required this.player,
    required this.showDebugNotifications,
    required this.batteryState,
  });

  final String? currentVideoTitle;
  final String widgetTitle;
  final Video? currentVideo;
  final PlayerModel player;
  final ValueNotifier<bool> showDebugNotifications;
  final ValueNotifier<BatteryState?> batteryState;

  @override
  CustomAppBarState createState() => CustomAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class CustomAppBarState extends State<CustomAppBar> {
  @override
  Widget build(BuildContext context) {
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
                        context
                            .read<SyncopathyModel>()
                            .mediaManager
                            .saveFavorite(widget.currentVideo!);
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
                        context
                            .read<SyncopathyModel>()
                            .mediaManager
                            .saveDislike(widget.currentVideo!);
                      },
                      tooltip: widget.currentVideo!.isDislike
                          ? 'Remove Dislike'
                          : 'Dislike Video',
                    ),
                    const SizedBox(width: 16),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => widget.player.closeVideo(),
                      tooltip: 'Close Video',
                    ),
                  ],
                )
              : const SizedBox.shrink(key: ValueKey<bool>(false)),
        ),
        if (widget.player.playlist.value != null) const SizedBox(width: 16),
        const PlaylistControls(),
        const SizedBox(width: 20),
        const UpdateCheckerWidget(),
        const SizedBox(width: 20),
        ValueListenableBuilder<BatteryState?>(
          valueListenable: widget.batteryState,
          builder: (context, batteryState, child) {
            if (batteryState == null || batteryState.level == 0) {
              return const SizedBox.shrink();
            }
            return Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Row(
                children: [
                  Icon(
                    batteryState.chargerConnected
                        ? Icons.battery_charging_full
                        : Icons.battery_full,
                    color: batteryState.chargerConnected
                        ? Colors.green
                        : (batteryState.level < 20 ? Colors.red : null),
                  ),
                  Text('${batteryState.level}%'),
                ],
              ),
            );
          },
        ),
        const Padding(
          padding: EdgeInsets.only(right: 20.0),
          child: ConnectionButton(),
        ),
        if (kDebugMode)
          Row(
            children: [
              Tooltip(
                message: 'Toggle debug notifications',
                child: ValueListenableBuilder<bool>(
                  valueListenable: widget.showDebugNotifications,
                  builder: (context, value, child) {
                    return Switch(
                      value: value,
                      onChanged: (newValue) {
                        widget.showDebugNotifications.value = newValue;
                      },
                    );
                  },
                ),
              ),
            ],
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
