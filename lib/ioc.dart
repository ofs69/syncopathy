import 'dart:io';

import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;
bool syncopathySimpleMode = false;

bool isDesktop() {
  return Platform.isWindows || Platform.isLinux || Platform.isMacOS;
}
