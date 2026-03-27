import 'package:flutter/material.dart';
import 'package:syncopathy/media_library/media_library.dart';

class MediaPage extends StatefulWidget {
  const MediaPage({super.key});

  @override
  State<MediaPage> createState() => _MediaPageState();
}

class _MediaPageState extends State<MediaPage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  final GlobalKey<NavigatorState> _nestedNavKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Padding(
      padding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 0.0),
      child: PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) async {
          if (didPop) return;
          if (_nestedNavKey.currentState?.canPop() ?? false) {
            _nestedNavKey.currentState?.pop();
          }
        },
        child: Navigator(
          key: _nestedNavKey,
          onGenerateRoute: (routeSettings) {
            return MaterialPageRoute(
              builder: (context) => const MediaLibrary(),
            );
          },
        ),
      ),
    );
  }
}
