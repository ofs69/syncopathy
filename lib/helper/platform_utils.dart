
import 'dart:io';

import 'package:url_launcher/url_launcher.dart';

class PlatformUtils {
  static Future<void> openFileExplorer(String path) async {
    if (Platform.isWindows) {
      await Process.run('explorer.exe', ['/select,', path]);
    } else {
      await launchUrl(Uri.file(path));
    }
  }
}
