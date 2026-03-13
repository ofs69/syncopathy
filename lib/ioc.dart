import 'dart:io';

import 'package:get_it/get_it.dart';
import 'package:syncopathy/persistence/objectbox.dart';

final getIt = GetIt.instance;
bool syncopathySimpleMode = false;

late ObjectBox oBox;

bool isDesktop() {
  return Platform.isWindows || Platform.isLinux || Platform.isMacOS;
}
