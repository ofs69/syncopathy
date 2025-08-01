import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncopathy/logging.dart';
import 'package:syncopathy/media_page.dart';
import 'package:syncopathy/model/app_model.dart';
import 'package:syncopathy/settings_page.dart';
import 'package:syncopathy/visualizer_page.dart';

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

  List<NavigationRailDestination> get _destinations {
    final destinations = <NavigationRailDestination>[
      const NavigationRailDestination(
        icon: Icon(Icons.video_library_outlined),
        selectedIcon: Icon(Icons.video_library),
        label: Text('Media'),
      ),
      const NavigationRailDestination(
        icon: Icon(Icons.line_axis_outlined),
        selectedIcon: Icon(Icons.line_axis),
        label: Text("Visualizer"),
      ),
      const NavigationRailDestination(
        icon: Icon(Icons.settings_outlined),
        selectedIcon: Icon(Icons.settings),
        label: Text('Settings'),
      ),
    ];
    return destinations;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
        actions: const [
          Center(
            child: Padding(
              padding: EdgeInsets.only(right: 20.0),
              child: Row(children: [ConnectionButton()]),
            ),
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
            },
            labelType: NavigationRailLabelType.all,
            destinations: _destinations,
          ),
          const VerticalDivider(thickness: 1, width: 1),
          Expanded(child: PageContent(selectedIndex: _selectedIndex)),
        ],
      ),
    );
  }
}

class ConnectionButton extends StatelessWidget {
  const ConnectionButton({super.key});

  @override
  Widget build(BuildContext context) {
    final model = context.watch<SyncopathyModel>();
    return ValueListenableBuilder(
      valueListenable: model.isScanning,
      builder: (context, scanning, child) {
        if (scanning) {
          return Padding(
            padding: EdgeInsets.all(8.0),
            child: Row(
              children: [
                SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(),
                ),
                SizedBox(width: 8),
                Text(
                  "Scanning for device...",
                  style: Theme.of(context).textTheme.labelLarge,
                ),
              ],
            ),
          );
        }
        return ValueListenableBuilder(
          valueListenable: model.isConnected,
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
                onPressed: scanning ? null : () => model.tryConnect(),
              ),
            );
          },
        );
      },
    );
  }
}

class PageContent extends StatefulWidget {
  const PageContent({super.key, required this.selectedIndex});

  final int selectedIndex;

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
                  child: IndexedStack(
                    index: widget.selectedIndex,
                    children: <Widget>[
                      const MediaPage(),
                      const VisualizerPage(),
                      const SettingsPage(),
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
