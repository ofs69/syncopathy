import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:signals/signals_flutter.dart';
import 'package:syncopathy/help_page.dart';
import 'package:syncopathy/helper/effect_dispose_mixin.dart';
import 'package:syncopathy/helper/platform_utils.dart';
import 'package:syncopathy/ioc.dart';
import 'package:syncopathy/media_library/media_page.dart';
import 'package:syncopathy/media_library/thumbnail_generator.dart';
import 'package:syncopathy/model/player_model.dart';
import 'package:syncopathy/model/settings_model.dart';
import 'package:syncopathy/notification_feed.dart';

import 'package:syncopathy/settings_page.dart';
import 'package:syncopathy/simple/simple_drag_and_drop.dart';
import 'package:syncopathy/video_player_page.dart';

import 'package:syncopathy/custom_app_bar.dart';
import 'package:syncopathy/web/start_modal.dart';

class Syncopathy extends StatelessWidget {
  const Syncopathy({super.key});

  @override
  Widget build(BuildContext context) {
    // AlertManager is provided (and registered in getIt) from main.dart.
    return MaterialApp(
      title: 'Syncopathy',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: GoogleFonts.roboto().fontFamily,
        textTheme: GoogleFonts.robotoTextTheme(
          ThemeData(brightness: Brightness.dark).textTheme,
        ),
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blueAccent,
          brightness: Brightness.dark,
        ),
      ),
      home: const SyncopathyHomePage(title: 'Syncopathy'),
    );
  }
}

class _NavItem {
  final IconData icon;
  final IconData selectedIcon;
  final String label;
  final bool mediaOnly;
  const _NavItem({
    required this.icon,
    required this.selectedIcon,
    required this.label,
    required this.mediaOnly,
  });
}

class SyncopathyHomePage extends StatefulWidget {
  const SyncopathyHomePage({super.key, required this.title});

  final String title;

  @override
  State<SyncopathyHomePage> createState() => _SyncopathyHomePageState();
}

class _SyncopathyHomePageState extends State<SyncopathyHomePage>
    with EffectDispose {
  // The visible page index is backed by the global [activePageIndex] signal,
  // which build() watches — assigning it rebuilds this widget reactively and
  // lets the media grid suspend its refresh while it's off-screen.
  int get _selectedIndex => activePageIndex.value;
  set _selectedIndex(int index) => activePageIndex.value = index;

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

    _startupModal();
  }

  Future<void> _startupModal() async {
    final sharedPref = await SharedPreferences.getInstance();
    final dismissedStartModal = sharedPref.getInt('dismissedStartModal') ?? 0;
    if (dismissedStartModal >= StartupModal.currentModalVersion) return;
    if (kIsWeb) {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        // Show start modal
        final dismiss = await showDialog<bool>(
          context: context,
          barrierDismissible: false,
          builder: (context) => const StartupModal(),
        );
        // The modal can close without returning true (e.g. a plain pop); only
        // record dismissal on an explicit true so it reappears otherwise.
        if (dismiss == true) {
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

    _selectedIndex = index;
    final int currentPage = _pageController.page?.round() ?? _selectedIndex;
    final int pageDelta = (index - currentPage).abs();
    // Scale the duration with the distance jumped, but clamp it so crossing
    // several tabs at once can't produce a multi-second animation.
    final int durationMs = (300 * (pageDelta == 0 ? 1 : pageDelta)).clamp(
      300,
      600,
    );
    _pageController.animateToPage(
      index,
      duration: Duration(milliseconds: durationMs),
      curve: Curves.ease,
    );
  }

  void _handleVideoChange(MediaFunscript? currentlyOpen) {
    final settings = context.read<SettingsModel>();

    if (currentlyOpen != null && settings.autoSwitchToVideoPlayerTab.value) {
      final videoTab = _videoPlayerTabIndex;
      _selectedIndex = videoTab;
      _pageController.animateToPage(
        videoTab,
        duration: const Duration(milliseconds: 300),
        curve: Curves.ease,
      );
    }
  }

  // Single source of truth for the navigation entries; both the rail and the
  // bottom bar are derived from this so labels stay plain strings (no Text
  // down-casting) and tab indices stay tied to one ordering.
  static const List<_NavItem> _navItems = [
    _NavItem(
      icon: Icons.video_library_outlined,
      selectedIcon: Icons.video_library,
      label: 'Media',
      mediaOnly: true,
    ),
    _NavItem(
      icon: Icons.play_circle_outline,
      selectedIcon: Icons.play_circle_filled,
      label: 'Video Player',
      mediaOnly: false,
    ),
    _NavItem(
      icon: Icons.settings_outlined,
      selectedIcon: Icons.settings,
      label: 'Settings',
      mediaOnly: false,
    ),
    _NavItem(
      icon: Icons.help_outline,
      selectedIcon: Icons.help,
      label: 'Help',
      mediaOnly: false,
    ),
  ];

  List<_NavItem> _visibleNavItems(bool withMedia) =>
      _navItems.where((n) => withMedia || !n.mediaOnly).toList();

  /// Index of the Video Player tab in the currently visible destinations.
  int get _videoPlayerTabIndex =>
      _visibleNavItems(!syncopathySimpleMode).indexWhere((n) => !n.mediaOnly);

  List<NavigationRailDestination> _destinations(bool withMedia) =>
      _visibleNavItems(withMedia)
          .map(
            (n) => NavigationRailDestination(
              icon: Icon(n.icon),
              selectedIcon: Icon(n.selectedIcon),
              label: Text(n.label),
            ),
          )
          .toList();

  List<NavigationDestination> _bottomDestinations(bool withMedia) =>
      _visibleNavItems(withMedia)
          .map(
            (n) => NavigationDestination(
              icon: Icon(n.icon),
              selectedIcon: Icon(n.selectedIcon),
              label: n.label,
            ),
          )
          .toList();

  @override
  Widget build(BuildContext context) {
    final isPortrait = PlatformUtils.isPortrait(context);
    final withMedia = !syncopathySimpleMode;
    final selectedIndex = activePageIndex.watch(context);

    return Scaffold(
      endDrawer: const AlertPanel(),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: ExcludeFocus(child: CustomAppBar(widgetTitle: widget.title)),
      ),
      bottomNavigationBar: isPortrait
          ? NavigationBar(
              selectedIndex: selectedIndex,
              onDestinationSelected: _onTabChanged,
              destinations: _bottomDestinations(withMedia),
            )
          : null,
      body: SimpleModeDragAndDrop(
        child: Row(
          children: [
            if (!isPortrait)
              ExcludeFocus(
                excluding: true,
                child: NavigationRail(
                  selectedIndex: selectedIndex,
                  onDestinationSelected: _onTabChanged,
                  labelType: NavigationRailLabelType.all,
                  destinations: _destinations(withMedia),
                  trailing: withMedia
                      ? Expanded(
                          child: Align(
                            alignment: Alignment.bottomCenter,
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 24.0),
                              child: AnimatedSwitcher(
                                duration: const Duration(milliseconds: 300),
                                child: _buildStatus(context),
                              ),
                            ),
                          ),
                        )
                      : null,
                ),
              ),
            const VerticalDivider(thickness: 1, width: 1),
            Expanded(
              child: Stack(
                children: [
                  PageContent(
                    selectedIndex: selectedIndex,
                    onPageChanged: (index) => _selectedIndex = index,
                    pageController: _pageController,
                  ),
                  // Portrait has no rail to host the trailing status, so float
                  // the thumbnail-generation indicator over the page instead.
                  if (isPortrait && withMedia)
                    Positioned(
                      right: 16,
                      bottom: 16,
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        child: _buildStatus(context),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatus(BuildContext context) {
    final count = ThumbnailGenerator().queueLength.watch(context);

    if (count > 0) {
      final scheme = Theme.of(context).colorScheme;
      return Tooltip(
        key: const ValueKey('busy'),
        message: "Generating thumbnails…",
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: scheme.primaryContainer,
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 14,
                height: 14,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: scheme.onPrimaryContainer,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                "$count",
                style: TextStyle(color: scheme.onPrimaryContainer),
              ),
            ],
          ),
        ),
      );
    }
    return const SizedBox.shrink(key: ValueKey("not_busy"));
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
    final withMedia = !syncopathySimpleMode;

    final List<Widget> pages = [
      if (withMedia) const MediaPage(),
      const VideoPlayerPage(),
      const SettingsPage(),
      const HelpPage(),
    ];

    return PageView(
      physics: const NeverScrollableScrollPhysics(),
      controller: widget.pageController,
      onPageChanged: widget.onPageChanged,
      children: [
        for (int i = 0; i < pages.length; i += 1)
          ExcludeFocus(excluding: widget.selectedIndex != i, child: pages[i]),
      ],
    );
  }
}
