import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';
import 'package:syncopathy/helper/platform_utils.dart';
import 'package:syncopathy/ioc.dart';

class HelpPage extends StatefulWidget {
  const HelpPage({super.key});

  @override
  State<HelpPage> createState() => _HelpPageState();
}

class _HelpPageState extends State<HelpPage> {
  String _getHelpFile(bool simple, bool isWeb) =>
      "${isWeb ? "web" : "native"}_${simple ? "simple" : "media"}.md";

  @override
  Widget build(BuildContext context) {
    final helpFile = _getHelpFile(syncopathySimpleMode, kIsWeb);
    final helpMd = rootBundle.loadString('assets/wiki/$helpFile');
    final isPortrait =
        PlatformUtils.isPortrait(context) ||
        MediaQuery.of(context).size.width < 1200;

    return Scaffold(
      body: FutureBuilder(
        future: helpMd,
        builder: (context, snapshot) {
          if (!snapshot.hasData) return CircularProgressIndicator();
          if (snapshot.hasError) return Text("No help file");
          return Center(
            child: FractionallySizedBox(
              widthFactor: isPortrait ? 1.0 : 0.5,
              child: Markdown(
                data: snapshot.data!,
                padding: EdgeInsets.all(24.0),
                selectable: true,
                styleSheet: MarkdownStyleSheet.fromTheme(
                  Theme.of(context).copyWith(
                    textTheme: Theme.of(
                      context,
                    ).textTheme.apply(fontSizeFactor: 1.0, fontSizeDelta: 4.0),
                  ),
                ).copyWith(h1Padding: EdgeInsets.fromLTRB(0.0, 24.0, 0.0, 0.0)),
              ),
            ),
          );
        },
      ),
    );
  }
}
