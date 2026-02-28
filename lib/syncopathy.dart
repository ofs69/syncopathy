import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncopathy/help_page.dart';
import 'package:syncopathy/helper/effect_dispose_mixin.dart';
import 'package:syncopathy/model/settings_model.dart';
import 'package:syncopathy/notification_feed.dart';
import 'package:syncopathy/settings_page.dart';
import 'package:syncopathy/video_player_page.dart';
import 'package:syncopathy/custom_app_bar.dart';
import 'package:syncopathy/web/start_modal.dart';
import 'package:syncopathy/web_drag_and_drop.dart';

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

class _SyncopathyHomePageState extends State<SyncopathyHomePage>
    with EffectDispose {
  int _selectedIndex = 0;
  late final PageController _pageController = PageController(
    initialPage: _selectedIndex,
  );

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // Show start modal
      final settingsModel = context.read<SettingsModel>();
      if (settingsModel.dismissedStartModal.value <
          StartupModal.currentModalVersion) {
        final dismiss = await showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => const StartupModal(),
        );
        if (dismiss) {
          settingsModel.dismissedStartModal.value =
              StartupModal.currentModalVersion;
        }
      }
    });
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

  List<NavigationRailDestination> _destinations() =>
      <NavigationRailDestination>[
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

  List<NavigationDestination> _bottomDestinations() {
    return _destinations()
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
    final isMobile = MediaQuery.of(context).size.width < 600;

    return LogNotificationObserver(
      child: Scaffold(
        appBar: CustomAppBar(widgetTitle: widget.title),
        bottomNavigationBar: isMobile
            ? NavigationBar(
                selectedIndex: _selectedIndex,
                onDestinationSelected: _onTabChanged,
                destinations: _bottomDestinations(), // Same icons as your rail
              )
            : null,
        body: WebDragAndDrop(
          child: Row(
            children: [
              if (!isMobile)
                NavigationRail(
                  selectedIndex: _selectedIndex,
                  onDestinationSelected: _onTabChanged,
                  labelType: NavigationRailLabelType.all,
                  destinations: _destinations(),
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
    return PageView(
      controller: widget.pageController,
      onPageChanged: widget.onPageChanged,
      children: [VideoPlayerPage(), SettingsPage(), HelpPage()],
    );
  }
}
