import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncopathy/connection_button.dart';
import 'package:syncopathy/help_page.dart';
import 'package:syncopathy/logging.dart';
import 'package:syncopathy/media_page.dart';
import 'package:syncopathy/model/app_model.dart';
import 'package:syncopathy/model/player_model.dart';
import 'package:syncopathy/playlist_controls.dart';

import 'package:syncopathy/settings_page.dart';
import 'package:syncopathy/update_checker_widget.dart';
import 'package:syncopathy/video_player_page.dart';

import 'package:syncopathy/shortcut_handler.dart';

class Syncopathy extends StatelessWidget {
  const Syncopathy({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Syncopathy',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blueAccent,
          brightness: Brightness.dark,
        ),
      ),
      home: const SyncopathyHomePage(title: 'Syncopathy'),
    );
  }
}

class SyncopathyHomePage extends StatefulWidget {
  const SyncopathyHomePage({super.key, required this.title});

  final String title;

  @override
  State<SyncopathyHomePage> createState() => _SyncopathyHomePageState();
}

class _SyncopathyHomePageState extends State<SyncopathyHomePage> {
  int _selectedIndex = 0;

  late PageController _pageController;
  late FocusNode _videoPlayerFocusNode;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _selectedIndex);
    _videoPlayerFocusNode = FocusNode();
    final player = context.read<PlayerModel>();
    player.currentVideo.addListener(_handleVideoChange);
  }

  @override
  void dispose() {
    final player = context.read<PlayerModel>();
    player.currentVideo.removeListener(_handleVideoChange);
    _videoPlayerFocusNode.dispose();
    super.dispose();
  }

  void _onTabChanged(int index) {
    setState(() {
      _selectedIndex = index;
    });
    final int currentPage = _pageController.page?.round() ?? _selectedIndex;
    final int pageDelta = (index - currentPage).abs();
    _pageController.animateToPage(
      index,
      duration: Duration(milliseconds: 300 * pageDelta),
      curve: Curves.ease,
    );
  }

  void _handleVideoChange() {
    final model = context.read<SyncopathyModel>();
    final player = context.read<PlayerModel>();
    if (player.currentVideo.value != null &&
        model.settings.autoSwitchToVideoPlayerTab.value) {
      setState(() {
        _selectedIndex = 1; // Navigate to Video Player tab
      });
      _pageController.animateToPage(
        1,
        duration: const Duration(milliseconds: 300),
        curve: Curves.ease,
      );
    } else {
      setState(() {});
    }
  }

  List<NavigationRailDestination> get _destinations {
    final destinations = <NavigationRailDestination>[
      const NavigationRailDestination(
        icon: Icon(Icons.video_library_outlined),
        selectedIcon: Icon(Icons.video_library),
        label: Text('Media'),
      ),
      const NavigationRailDestination(
        icon: Icon(Icons.play_circle_outline),
        selectedIcon: Icon(Icons.play_circle_filled),
        label: Text("Video Player"),
      ),
      const NavigationRailDestination(
        icon: Icon(Icons.settings_outlined),
        selectedIcon: Icon(Icons.settings),
        label: Text('Settings'),
      ),
      const NavigationRailDestination(
        icon: Icon(Icons.help_outline),
        selectedIcon: Icon(Icons.help),
        label: Text('Help'),
      ),
    ];
    return destinations;
  }

  @override
  Widget build(BuildContext context) {
    final currentVideo = context.read<PlayerModel>().currentVideo.value;
    return ShortcutHandler(
      pageController: _pageController,
      onTabChanged: _onTabChanged,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Row(
            children: [
              Text(widget.title),
              Expanded(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  transitionBuilder:
                      (Widget child, Animation<double> animation) {
                        final inAnimation = Tween<Offset>(
                          begin: const Offset(
                            1.0,
                            0.0,
                          ), // New child comes from right
                          end: Offset.zero,
                        ).animate(animation);

                        final outAnimation = Tween<Offset>(
                          begin: Offset.zero,
                          end: const Offset(
                            -1.0,
                            0.0,
                          ), // Old child goes to left
                        ).animate(animation);

                        return SlideTransition(
                          position: animation.status == AnimationStatus.reverse
                              ? outAnimation
                              : inAnimation,
                          child: FadeTransition(
                            opacity: animation,
                            child: child,
                          ),
                        );
                      },
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      currentVideo?.title != null
                          ? " - ${currentVideo?.title}"
                          : "",
                      key: ValueKey<String>(currentVideo?.title ?? ""),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      softWrap: false,
                    ),
                  ),
                ),
              ),
            ],
          ),
          actions: [
            if (currentVideo != null) ...[
              IconButton(
                icon: Icon(
                  currentVideo.isFavorite ? Icons.star : Icons.star_border,
                  color: currentVideo.isFavorite
                      ? Colors.yellow.shade600
                      : null,
                ),
                onPressed: () {
                  setState(() {
                    currentVideo.isFavorite = !currentVideo.isFavorite;
                    if (currentVideo.isFavorite) {
                      currentVideo.isDislike = false;
                    }
                  });
                  context.read<SyncopathyModel>().mediaManager.saveFavorite(
                        currentVideo,
                      );
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
                  color: currentVideo.isDislike ? Colors.blue.shade300 : null,
                ),
                onPressed: () {
                  setState(() {
                    currentVideo.isDislike = !currentVideo.isDislike;
                    if (currentVideo.isDislike) {
                      currentVideo.isFavorite = false;
                    }
                  });
                  context.read<SyncopathyModel>().mediaManager.saveDislike(
                        currentVideo,
                      );
                },
                tooltip: currentVideo.isDislike
                    ? 'Remove Dislike'
                    : 'Dislike Video',
              ),
              const SizedBox(width: 20),
            ],
            const PlaylistControls(),
            const SizedBox(width: 20),
            const UpdateCheckerWidget(),
            const SizedBox(width: 20),
            const Padding(
              padding: EdgeInsets.only(right: 20.0),
              child: ConnectionButton(),
            ),
          ],
        ),
        body: Row(
          children: <Widget>[
            NavigationRail(
              selectedIndex: _selectedIndex,
              onDestinationSelected: _onTabChanged,
              labelType: NavigationRailLabelType.all,
              destinations: _destinations,
            ),
            const VerticalDivider(thickness: 1, width: 1),
            Expanded(
              child: PageContent(
                selectedIndex: _selectedIndex,
                onPageChanged: (index) {
                  setState(() {
                    _selectedIndex = index;
                  });
                },
                pageController: _pageController,
                videoPlayerFocusNode: _videoPlayerFocusNode,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PageContent extends StatefulWidget {
  const PageContent({
    super.key,
    required this.selectedIndex,
    required this.onPageChanged,
    required this.pageController,
    this.videoPlayerFocusNode,
  });

  final int selectedIndex;
  final ValueChanged<int> onPageChanged;
  final PageController pageController;
  final FocusNode? videoPlayerFocusNode;

  @override
  State<PageContent> createState() => _PageContentState();
}

class _PageContentState extends State<PageContent> {
  bool _isLogVisible = true;

  @override
  void didUpdateWidget(covariant PageContent oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedIndex == 1 && widget.videoPlayerFocusNode != null) {
      widget.videoPlayerFocusNode!.requestFocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // We need the total width to calculate the position of the button.
        // The log panel takes up 1/5th of the space when visible.
        final logPanelWidth = _isLogVisible ? constraints.maxWidth / 5 : 0;
        // We want to center the button on the divider. The button is 48px wide,
        // so we offset it by half its width (30px) from the divider.
        final buttonRightOffset = logPanelWidth - 30.0;

        return Stack(
          children: [
            Row(
              children: [
                Expanded(
                  flex: 4,
                  child: PageView(
                    controller: widget.pageController,
                    onPageChanged: widget.onPageChanged,
                    children: <Widget>[
                      MediaPage(
                        mediaManager: context
                            .read<SyncopathyModel>()
                            .mediaManager,
                      ),
                      VideoPlayerPage(focusNode: widget.videoPlayerFocusNode),
                      SettingsPage(),
                      HelpPage(),
                    ],
                  ),
                ),
                if (_isLogVisible) Expanded(flex: 1, child: LoggingPanel()),
              ],
            ),
            Positioned(
              top: 0,
              bottom: 0,
              right: buttonRightOffset,
              child: IconButton(
                icon: Icon(
                  _isLogVisible ? Icons.chevron_right : Icons.chevron_left,
                ),
                onPressed: () {
                  setState(() {
                    _isLogVisible = !_isLogVisible;
                  });
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
