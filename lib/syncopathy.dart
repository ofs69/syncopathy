import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:signals/signals_core.dart';
import 'package:syncopathy/help_page.dart';
import 'package:syncopathy/helper/effect_dispose_mixin.dart';
import 'package:syncopathy/helper/platform_utils.dart';
import 'package:syncopathy/media_library/media_manager.dart';
import 'package:syncopathy/media_library/media_page.dart';
import 'package:syncopathy/model/player_model.dart';
import 'package:syncopathy/model/settings_model.dart';
import 'package:syncopathy/notification_feed.dart';

import 'package:syncopathy/settings_page.dart';
import 'package:syncopathy/simple/simple_drag_and_drop.dart';
import 'package:syncopathy/sqlite/database_helper.dart';
import 'package:syncopathy/video_player_page.dart';

import 'package:syncopathy/custom_app_bar.dart';
import 'package:syncopathy/web/start_modal.dart';
import 'package:syncopathy/widgets/database_reset_dialog.dart';

class Syncopathy extends StatelessWidget {
  const Syncopathy({super.key});

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

class _SyncopathyHomePageState extends State<SyncopathyHomePage>
    with EffectDispose {
  int _selectedIndex = 0;

  late final PageController _pageController = PageController(
    initialPage: _selectedIndex,
  );

  @override
  void initState() {
    super.initState();
    final playerModel = context.read<PlayerModel>();

    effectAdd([
      effect(() {
        _handleVideoChange(playerModel.currentlyOpen.value);
      }),
    ]);

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
    _startupModal();
  }

  Future<void> _startupModal() async {
    final sharedPref = await SharedPreferences.getInstance();
    final dismissedStartModal = sharedPref.getInt('dismissedStartModal') ?? 0;
    if (dismissedStartModal >= StartupModal.currentModalVersion) return;
    if (kIsWeb) {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        // Show start modal
        final dismiss = await showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => const StartupModal(),
        );
        if (dismiss) {
          sharedPref.setInt(
            'dismissedStartModal',
            StartupModal.currentModalVersion,
          );
        }
      });
    }
  }

  @override
  void dispose() {
    effectDispose();
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

  void _handleVideoChange(MediaFunscript? currentlyOpen) {
    final settings = context.read<SettingsModel>();

    if (currentlyOpen != null && settings.autoSwitchToVideoPlayerTab.value) {
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

  List<NavigationRailDestination> _destinations(bool withMedia) =>
      <NavigationRailDestination>[
        if (withMedia)
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

  List<NavigationDestination> _bottomDestinations(bool withMedia) {
    return _destinations(withMedia)
        .map(
          (d) => NavigationDestination(
            icon: d.icon,
            selectedIcon: d.selectedIcon,
            label: (d.label as Text)
                .data!, // Extracts the string from the Text widget
          ),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final isPortrait = PlatformUtils.isPortrait(context);
    final withMedia = context.read<MediaManager?>() != null;

    return LogNotificationObserver(
      child: Scaffold(
        appBar: CustomAppBar(widgetTitle: widget.title),
        bottomNavigationBar: isPortrait
            ? NavigationBar(
                selectedIndex: _selectedIndex,
                onDestinationSelected: _onTabChanged,
                destinations: _bottomDestinations(withMedia),
              )
            : null,
        body: SimpleModeDragAndDrop(
          child: Row(
            children: [
              if (!isPortrait)
                NavigationRail(
                  selectedIndex: _selectedIndex,
                  onDestinationSelected: _onTabChanged,
                  labelType: NavigationRailLabelType.all,
                  destinations: _destinations(withMedia),
                ),
              const VerticalDivider(thickness: 1, width: 1),
              Expanded(
                child: Stack(
                  children: [
                    PageContent(
                      selectedIndex: _selectedIndex,
                      onPageChanged: (index) {
                        setState(() {
                          _selectedIndex = index;
                        });
                      },
                      pageController: _pageController,
                    ),
                    const NotificationFeed(),
                  ],
                ),
              ),
            ],
          ),
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
  });

  final int selectedIndex;
  final ValueChanged<int> onPageChanged;
  final PageController pageController;

  @override
  State<PageContent> createState() => _PageContentState();
}

class _PageContentState extends State<PageContent> {
  @override
  Widget build(BuildContext context) {
    final withMedia = context.read<MediaManager?>() != null;
    return PageView(
      physics: const NeverScrollableScrollPhysics(),
      controller: widget.pageController,
      onPageChanged: widget.onPageChanged,
      children: <Widget>[
        if (withMedia) MediaPage(),
        VideoPlayerPage(),
        SettingsPage(),
        HelpPage(),
      ],
    );
  }
}
