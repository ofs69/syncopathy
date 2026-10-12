import 'dart:io';

import 'package:get_it/get_it.dart';
import 'package:path_provider/path_provider.dart';
import 'package:signals/signals.dart';
import 'package:syncopathy/persistence/objectbox.dart';

final getIt = GetIt.instance;
bool syncopathySimpleMode = false;

/// PageView index of the media library page. It is always first when present
/// (it only exists outside simple mode — see PageContent in syncopathy.dart).
const int mediaPageIndex = 0;

/// Index of the currently visible page in the main PageView.
/// The media grid reads this to suspend its reactive refresh while it's not the
/// visible page (e.g. during video playback on the player page), so off-screen
/// rebuilds triggered by DB writes can't compete with the video on the UI thread.
final activePageIndex = signal<int>(mediaPageIndex);

late ObjectBox oBox;

/// Absolute path to the app-owned mpv config directory. Set during native
/// platform init so the embedded player uses our own mpv.conf/input.conf
/// instead of inheriting the user's global mpv configuration.
String? mpvConfigDir;

/// Raw mpv `hwdec` value from a `--hwdec=` command line argument, overriding the
/// stored setting for this run. Any value mpv accepts is allowed here (not just
/// the curated [HwdecMode] set) so a specific decoder can be ruled in or out
/// when diagnosing a GPU driver problem.
String? hwdecOverride;

/// Directory from a `--data-dir=` command line argument, used instead of the
/// platform's application support directory for this run. Lets a debug session
/// run against its own database, thumbnails and logs without touching the
/// user's real library.
String? dataDirOverride;

/// Where the database, thumbnails, logs and mpv config live: [dataDirOverride]
/// when set, otherwise the platform's application support directory. Every
/// lookup of the app data directory must go through this, or a `--data-dir`
/// run would quietly mix in the real one.
Future<Directory> appDataDirectory() async {
  final override = dataDirOverride;
  if (override == null) return getApplicationSupportDirectory();
  return Directory(override).create(recursive: true);
}

bool isDesktop() {
  return Platform.isWindows || Platform.isLinux || Platform.isMacOS;
}
