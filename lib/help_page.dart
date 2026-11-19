import 'package:flutter/foundation.dart';
import 'package:material_ui/material_ui.dart';
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
  static String _getHelpFile(bool simple, bool isWeb) =>
      "${isWeb ? "web" : "native"}_${simple ? "simple" : "media"}.md";

  // Loaded once — the help file only depends on constant mode/platform flags,
  // so there's no need to re-issue the bundle read on every rebuild.
  late final Future<String> _helpMd = rootBundle.loadString(
    'assets/wiki/${_getHelpFile(syncopathySimpleMode, kIsWeb)}',
  );

  @override
  Widget build(BuildContext context) {
    final helpMd = _helpMd;
    final isPortrait =
        PlatformUtils.isPortrait(context) ||
        MediaQuery.of(context).size.width < 1200;

    return Scaffold(
      body: FutureBuilder(
        future: helpMd,
        builder: (context, snapshot) {
          if (!snapshot.hasData) return CircularProgressIndicator();
          if (snapshot.hasError) return Text("No help file");
          final theme = Theme.of(context);
          final type = theme.textTheme.apply(fontSizeDelta: 4.0);
          return Center(
            child: FractionallySizedBox(
              widthFactor: isPortrait ? 1.0 : 0.5,
              child: SelectionArea(
                child: Markdown(
                  data: snapshot.data!,
                  padding: const EdgeInsets.all(24),
                  styleSheet: MarkdownStyleSheet(
                    p: type.bodyMedium,
                    h1: type.headlineSmall,
                    h1Padding: const EdgeInsets.only(top: 24),
                    h2: type.titleLarge,
                    h3: type.titleMedium,
                    h4: type.bodyLarge,
                    listBullet: type.bodyMedium,
                    code: type.bodyMedium?.apply(
                      fontFamily: 'monospace',
                      fontSizeFactor: 0.85,
                      backgroundColor: theme.cardTheme.color,
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
