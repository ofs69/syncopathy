import 'dart:io';

import 'package:get_it/get_it.dart';
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

bool isDesktop() {
  return Platform.isWindows || Platform.isLinux || Platform.isMacOS;
}
