import 'dart:io';

import 'package:path/path.dart';
import 'package:url_launcher/url_launcher.dart';

class PlatformUtils {
  static Future<void> openFileExplorer(String path) async {
    if (Platform.isWindows) {
      await Process.run('explorer.exe', ['/select,', path]);
    } else {
      var directory = File.fromUri(Uri.file(path)).parent.path;
      await launchUrl(Uri.parse("file://$directory"));
    }
  }
}
