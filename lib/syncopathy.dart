import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncopathy/help_page.dart';

import 'package:syncopathy/media_page.dart';
import 'package:syncopathy/model/player_model.dart';
import 'package:syncopathy/model/settings_model.dart';
import 'package:syncopathy/notification_feed.dart';

import 'package:syncopathy/settings_page.dart';
import 'package:syncopathy/video_player_page.dart';

import 'package:syncopathy/shortcut_handler.dart';
import 'package:syncopathy/custom_app_bar.dart';
import 'package:syncopathy/sqlite/database_helper.dart';
import 'package:syncopathy/widgets/database_reset_dialog.dart';

class Syncopathy extends StatelessWidget {
  const Syncopathy({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => NotificationFeedManager(),
      child: MaterialApp(
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
      ),
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

    // Check for database reset and show dialog if necessary
    if (DatabaseHelper().databaseWasReset) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        // Ensure context is still valid before showing dialog
        if (mounted) {
          showDatabaseResetDialog(
            context,
            DatabaseHelper().databaseWasResetName!,
          );
        }
      });
    }
  }

  @override
  void dispose() {
    final player = context.read<PlayerModel>();
    player.currentVideo.removeListener(_handleVideoChange);
    _videoPlayerFocusNode.dispose();
    super.dispose();
  }

  void _onTabChanged(int index) {
    if (_selectedIndex == index) {
      return;
    }

    setState(() {
      _selectedIndex = index;
    });
    final int currentPage = _pageController.page?.round() ?? _selectedIndex;
    final int pageDelta = (index - currentPage).abs();
    _pageController.animateToPage(
      index,
      duration: Duration(milliseconds: 300 * (pageDelta == 0 ? 1 : pageDelta)),
      curve: Curves.ease,
    );
  }

  void _handleVideoChange() {
    final settings = context.read<SettingsModel>();
    final player = context.read<PlayerModel>();
    if (player.currentVideo.value != null &&
        settings.autoSwitchToVideoPlayerTab.value) {
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
    final player = context.read<PlayerModel>();
    final currentVideo = player.currentVideo.value;

    return LogNotificationObserver(
      child: Stack(
        children: [
          ShortcutHandler(
            pageController: _pageController,
            onTabChanged: _onTabChanged,
            child: Scaffold(
              appBar: CustomAppBar(
                currentVideoTitle: currentVideo?.title,
                widgetTitle: widget.title,
                currentVideo: currentVideo,
                player: player,
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
          ),
          const NotificationFeed(),
        ],
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
  @override
  void didUpdateWidget(covariant PageContent oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedIndex == 1 && widget.videoPlayerFocusNode != null) {
      widget.videoPlayerFocusNode!.requestFocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: widget.pageController,
      onPageChanged: widget.onPageChanged,
      children: <Widget>[
        MediaPage(),
        VideoPlayerPage(focusNode: widget.videoPlayerFocusNode),
        SettingsPage(),
        HelpPage(),
      ],
    );
  }
}
