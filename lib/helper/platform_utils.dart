import 'dart:io';

import 'package:flutter/material.dart';
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

  static bool isPortrait(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final heigth = MediaQuery.of(context).size.height;
    return (width / heigth) < 1.0;
  }
}
