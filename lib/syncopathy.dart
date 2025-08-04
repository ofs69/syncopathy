import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncopathy/help_page.dart';
import 'package:syncopathy/logging.dart';
import 'package:syncopathy/media_page.dart';
import 'package:syncopathy/model/app_model.dart';
import 'package:syncopathy/model/player_model.dart';

import 'package:syncopathy/settings_page.dart';
import 'package:syncopathy/update_checker.dart';
import 'package:syncopathy/video_player_page.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:path/path.dart' as p;
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
  String? _latestVersion;
  bool _isCheckingForUpdates = false;
  bool _isUpToDate = false;
  late PageController _pageController;
  String _currentVideoTitle = '';

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _selectedIndex);
    final player = context.read<PlayerModel>();
    player.path.addListener(_handleVideoPathChange);
    player.path.addListener(_updateVideoTitle);
    _updateVideoTitle(); // Initial update
  }

  @override
  void dispose() {
    final player = context.read<PlayerModel>();
    player.path.removeListener(_handleVideoPathChange);
    player.path.removeListener(_updateVideoTitle);
    super.dispose();
  }

  void _onTabChanged(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _updateVideoTitle() {
    final player = context.read<PlayerModel>();
    final path = player.path.value;
    setState(() {
      _currentVideoTitle = path.isNotEmpty
          ? p.basenameWithoutExtension(path)
          : '';
    });
  }

  void _handleVideoPathChange() {
    final model = context.read<SyncopathyModel>();
    final player = context.read<PlayerModel>();
    if (player.path.value.isNotEmpty && model.settings.embeddedVideoPlayer) {
      setState(() {
        _selectedIndex = 1; // Navigate to Video Player tab
      });
      _pageController.animateToPage(
        1,
        duration: const Duration(milliseconds: 300),
        curve: Curves.ease,
      );
    }
  }

  Future<void> _checkForUpdates() async {
    setState(() {
      _isCheckingForUpdates = true;
      _isUpToDate = false;
    });
    final version = await UpdateChecker.checkForUpdates();
    if (mounted) {
      setState(() {
        _latestVersion = version;
        _isCheckingForUpdates = false;
        if (version == null) {
          _isUpToDate = true;
        }
      });
      if (version != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('New version $version available!')),
        );
      } else {
        // Optionally, show a temporary green checkmark or a subtle animation
        Future.delayed(const Duration(seconds: 2), () {
          if (mounted) {
            setState(() {
              _isUpToDate = false;
            });
          }
        });
      }
    }
  }

  Future<void> _openReleasePage() async {
    final url = Uri.parse('https://github.com/ofs69/syncopathy/releases');
    if (!await launchUrl(url)) {
      Logger.error('Could not launch $url');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not open the release page.')),
        );
      }
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
    return ShortcutHandler(
      pageController: _pageController,
      onTabChanged: _onTabChanged,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Row(
            children: [
              Text(widget.title),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                transitionBuilder: (Widget child, Animation<double> animation) {
                  final inAnimation = Tween<Offset>(
                    begin: const Offset(1.0, 0.0), // New child comes from right
                    end: Offset.zero,
                  ).animate(animation);

                  final outAnimation = Tween<Offset>(
                    begin: Offset.zero,
                    end: const Offset(-1.0, 0.0), // Old child goes to left
                  ).animate(animation);

                  return SlideTransition(
                    position: animation.status == AnimationStatus.reverse
                        ? outAnimation
                        : inAnimation,
                    child: FadeTransition(opacity: animation, child: child),
                  );
                },
                child: Text(
                  _currentVideoTitle.isNotEmpty
                      ? " - $_currentVideoTitle"
                      : "", // Handle empty case
                  key: ValueKey<String>(
                    _currentVideoTitle,
                  ), // Key based on changing content
                ),
              ),
            ],
          ),
          actions: [
            if (_isCheckingForUpdates)
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(),
                ),
              )
            else if (_isUpToDate)
              const Tooltip(
                message: 'You are on the latest version!',
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Icon(Icons.check_circle, color: Colors.green),
                ),
              )
            else if (_latestVersion != null)
              Tooltip(
                message: 'New version available: $_latestVersion',
                child: IconButton(
                  icon: const Icon(Icons.update, color: Colors.amber),
                  onPressed: _openReleasePage,
                ),
              )
            else
              IconButton(
                icon: const Icon(Icons.update_sharp),
                onPressed: _checkForUpdates,
                tooltip: 'Check for Updates',
              ),
            const SizedBox(width: 20),
            const Padding(
              padding: EdgeInsets.only(right: 20.0),
              child: ConnectionButton(),
            ),
            IconButton(
              icon: const Icon(Icons.help_outline),
              onPressed: () {
                _pageController.animateToPage(
                  3, // Index of the RebindShortcutsPage
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.ease,
                );
                setState(() {
                  _selectedIndex = 3;
                });
              },
              tooltip: 'Help',
            ),
          ],
        ),
        body: Row(
          children: <Widget>[
            NavigationRail(
              selectedIndex: _selectedIndex,
              onDestinationSelected: (int index) {
                setState(() {
                  _selectedIndex = index;
                });
                _pageController.animateToPage(
                  index,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.ease,
                );
              },
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
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ConnectionButton extends StatelessWidget {
  const ConnectionButton({super.key});

  @override
  Widget build(BuildContext context) {
    final player = context.watch<PlayerModel>();
    return ValueListenableBuilder(
      valueListenable: player.isScanning,
      builder: (context, scanning, child) {
        if (scanning) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(),
                ),
                const SizedBox(width: 8),
                Text(
                  "Scanning for device...",
                  style: Theme.of(context).textTheme.labelLarge,
                ),
              ],
            ),
          );
        }
        return ValueListenableBuilder(
          valueListenable: player.isConnected,
          builder: (context, connected, child) {
            return Tooltip(
              message: connected ? "Connected" : "Disconnected",
              child: TextButton.icon(
                label: Text(connected ? "Connected" : "Disconnected"),
                icon: Icon(
                  connected
                      ? Icons.bluetooth_connected
                      : Icons.bluetooth_disabled,
                  color: connected ? Colors.green : Colors.red,
                ),
                onPressed: scanning ? null : () => player.tryConnect(),
              ),
            );
          },
        );
      },
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
  bool _isLogVisible = true;

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
                      VideoPlayerPage(),
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
