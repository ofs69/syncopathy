import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:syncopathy/connection_button.dart';
import 'package:syncopathy/model/app_model.dart';
import 'package:syncopathy/model/player_model.dart';
import 'package:syncopathy/playlist_controls.dart';
import 'package:syncopathy/update_checker_widget.dart';
import 'package:syncopathy/helper/constants.dart';
import 'package:window_manager/window_manager.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({
    super.key,
    required this.currentVideoTitle,
    required this.widgetTitle,
    required this.currentVideo,
    required this.player,
    required this.showDebugNotifications,
  });

  final String? currentVideoTitle;
  final String widgetTitle;
  final dynamic
  currentVideo; // Using dynamic as the type is not fully known here
  final PlayerModel player;
  final ValueNotifier<bool> showDebugNotifications;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

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
            key: ValueKey<String>(currentVideoTitle ?? widgetTitle),
            alignment: Alignment.centerLeft,
            child: Text(
              currentVideoTitle ?? widgetTitle,
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
          child: currentVideo != null
              ? Row(
                  key: const ValueKey<bool>(true),
                  children: [
                    IconButton(
                      icon: Icon(
                        currentVideo.isFavorite
                            ? Icons.star
                            : Icons.star_border,
                        color: currentVideo.isFavorite ? favoriteColor : null,
                      ),
                      onPressed: () {
                        currentVideo.isFavorite = !currentVideo.isFavorite;
                        if (currentVideo.isFavorite) {
                          currentVideo.isDislike = false;
                        }
                        context
                            .read<SyncopathyModel>()
                            .mediaManager
                            .saveFavorite(currentVideo);
                      },
                      tooltip: currentVideo.isFavorite
                          ? 'Remove from Favorites'
                          : 'Add to Favorites',
                    ),
                    IconButton(
                      icon: Icon(
                        currentVideo.isDislike
                            ? Icons.thumb_down
                            : Icons.thumb_down_off_alt,
                        color: currentVideo.isDislike ? dislikeColor : null,
                      ),
                      onPressed: () {
                        currentVideo.isDislike = !currentVideo.isDislike;
                        if (currentVideo.isDislike) {
                          currentVideo.isFavorite = false;
                        }
                        context
                            .read<SyncopathyModel>()
                            .mediaManager
                            .saveDislike(currentVideo);
                      },
                      tooltip: currentVideo.isDislike
                          ? 'Remove Dislike'
                          : 'Dislike Video',
                    ),
                    const SizedBox(width: 16),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => player.closeVideo(),
                      tooltip: 'Close Video',
                    ),
                  ],
                )
              : const SizedBox.shrink(key: ValueKey<bool>(false)),
        ),
        if (player.playlist.value != null) const SizedBox(width: 16),
        const PlaylistControls(),
        const SizedBox(width: 20),
        const UpdateCheckerWidget(),
        const SizedBox(width: 20),
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
                  valueListenable: showDebugNotifications,
                  builder: (context, value, child) {
                    return Switch(
                      value: value,
                      onChanged: (newValue) {
                        showDebugNotifications.value = newValue;
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
