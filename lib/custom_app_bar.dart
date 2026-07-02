import 'package:flutter/foundation.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:signals/signals_flutter.dart';
import 'package:syncopathy/connection_button.dart';
import 'package:syncopathy/helper/extensions.dart';
import 'package:syncopathy/home_button.dart';
import 'package:syncopathy/ioc.dart';
import 'package:syncopathy/media_library/media_manager.dart';
import 'package:syncopathy/model/battery_model.dart';
import 'package:syncopathy/model/player_model.dart';
import 'package:syncopathy/persistence/entities/media_file.dart';
import 'package:syncopathy/player/video_player.dart';
import 'package:syncopathy/playlist_controls.dart';
import 'package:syncopathy/simple/simple_mode/simple_mode.dart';
import 'package:syncopathy/notification_feed.dart';

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
    final player = context.read<VideoPlayer>();
    final batteryModel = context.read<BatteryModel>();
    final playerModel = context.read<PlayerModel>();

    final hasBattery = batteryModel.hasBattery.watch(context);
    final chargerConnected = batteryModel.chargerConnected.watch(context);
    final currentPlaylist = player.currentPlaylist.watch(context);
    final currentlyOpen = playerModel.currentlyOpen.watch(context);

    return AppBar(
      backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      flexibleSpace: !kIsWeb
          ? DragToMoveArea(child: Container(color: Colors.transparent))
          : null,
      title: _buildTitle(currentlyOpen),
      actions: [
        HomeButton(),
        if (kIsWeb) SizedBox(width: 4),
        if (kIsWeb)
          IconButton(
            icon: const Icon(Icons.fullscreen),
            tooltip: "Fullscreen",
            onPressed: () async {
              SimpleMode.toggleFullscreen();
            },
          ),
        if (syncopathySimpleMode) SizedBox(width: 4),
        if (syncopathySimpleMode)
          TextButton.icon(
            label: Text("Open files..."),
            onPressed: () =>
                SimpleMode.pickAndLoadFiles(context.read<PlayerModel>()),
            icon: Icon(Icons.open_in_browser),
            style: TextButton.styleFrom(
              side: BorderSide(
                color: Theme.of(context).colorScheme.outline.withAlphaF(0.5),
                width: 1.0,
              ),
            ),
          ),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          transitionBuilder: (Widget child, Animation<double> animation) {
            return FadeTransition(opacity: animation, child: child);
          },
          child: actionRow(
            currentlyOpen,
            mediaManager,
            currentPlaylist.entries.length > 1,
          ),
        ),
        if (currentlyOpen?.media != null) const SizedBox(width: 4),
        const PlaylistControls(),
        const SizedBox(width: 4),

        if (hasBattery)
          _buildBatteryIndicator(context, batteryModel, chargerConnected),
        const SizedBox(width: 4.0),
        ConnectionButton(),
        const SizedBox(width: 4.0),

        _buildNotificationButton(),
        const SizedBox(width: 4),

        ..._buildWindowButtons(context),
      ],
    );
  }

  Widget _buildTitle(MediaFunscript? currentlyOpen) {
    final title = currentlyOpen?.media.name ?? widget.widgetTitle;
    return IgnorePointer(
      ignoring: true,
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        transitionBuilder: (Widget child, Animation<double> animation) {
          return FadeTransition(opacity: animation, child: child);
        },
        child: Align(
          key: ValueKey<String>(title),
          alignment: Alignment.centerLeft,
          child: Text(
            title,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            softWrap: false,
          ),
        ),
      ),
    );
  }

  Widget _buildBatteryIndicator(
    BuildContext context,
    BatteryModel batteryModel,
    bool chargerConnected,
  ) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          child: Text(
            '${batteryModel.batteryLevel.watch(context).toString().padLeft(3, ' ')}%',
            textAlign: TextAlign.end, // Aligns text against the icon
            style: GoogleFonts.robotoMono(
              fontFeatures: [FontFeature.tabularFigures()],
            ),
          ),
        ),
        const SizedBox(width: 4), // Small gap between text and icon
        Icon(
          chargerConnected ? Icons.battery_charging_full : Icons.battery_full,
          color: chargerConnected
              ? Colors.green
              : (batteryModel.batteryLevel.value < 20 ? Colors.red : null),
        ),
      ],
    );
  }

  Widget _buildNotificationButton() {
    return Watch.builder(
      builder: (context) {
        final unreadCount = context.read<AlertManager>().unreadCount.value;
        return Badge(
          label: Text('$unreadCount'),
          isLabelVisible: unreadCount > 0,
          child: IconButton(
            icon: const Icon(Icons.notifications_none),
            onPressed: () {
              Scaffold.of(context).openEndDrawer();
            },
          ),
        );
      },
    );
  }

  List<Widget> _buildWindowButtons(BuildContext context) {
    if (kIsWeb) return const [];
    final brightness = Theme.of(context).brightness;
    return [
      WindowCaptionButton.minimize(
        brightness: brightness,
        onPressed: () => windowManager.minimize(),
      ),
      WindowCaptionButton.maximize(
        brightness: brightness,
        onPressed: () async => await windowManager.isMaximized()
            ? windowManager.restore()
            : windowManager.maximize(),
      ),
      WindowCaptionButton.close(
        brightness: brightness,
        onPressed: () => windowManager.close(),
      ),
    ];
  }

  Widget actionRow(
    MediaFunscript? currentlyOpen,
    MediaManager? mediaManager,
    bool playlist,
  ) {
    final currentVideo = currentlyOpen?.media;
    if (currentVideo == null) return const SizedBox.shrink();
    return Row(
      children: [
        if (mediaManager != null)
          _buildRatingButton(
            video: currentVideo,
            active: currentVideo.isFavorite,
            activeIcon: Icons.star,
            inactiveIcon: Icons.star_border,
            activeColor: favoriteColor,
            rating: MediaRating.like,
            activeTooltip: 'Remove from Favorites',
            inactiveTooltip: 'Add to Favorites',
          ),
        if (mediaManager != null)
          _buildRatingButton(
            video: currentVideo,
            active: currentVideo.isDislike,
            activeIcon: Icons.thumb_down,
            inactiveIcon: Icons.thumb_down_off_alt,
            activeColor: dislikeColor,
            rating: MediaRating.dislike,
            activeTooltip: 'Remove Dislike',
            inactiveTooltip: 'Dislike Video',
          ),
        if (mediaManager != null) const SizedBox(width: 16),
        if (!syncopathySimpleMode)
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => getIt.get<VideoPlayer>().closeMedia(),
            tooltip: playlist ? 'Close Playlist' : 'Close Video',
          ),
      ],
    );
  }

  /// A rating toggle: when [active] it shows [activeIcon]/[activeColor] and
  /// clears the rating on tap; otherwise it applies [rating]. Shared by the
  /// favorite and dislike buttons.
  Widget _buildRatingButton({
    required MediaFile video,
    required bool active,
    required IconData activeIcon,
    required IconData inactiveIcon,
    required Color activeColor,
    required MediaRating rating,
    required String activeTooltip,
    required String inactiveTooltip,
  }) {
    return IconButton(
      icon: Icon(active ? activeIcon : inactiveIcon, color: active ? activeColor : null),
      onPressed: () {
        setState(() {
          video.rating = active ? MediaRating.noRating : rating;
        });
        oBox.mediaService.save(video);
      },
      tooltip: active ? activeTooltip : inactiveTooltip,
    );
  }
}
