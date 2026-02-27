import 'package:flutter/material.dart';
import 'package:media_kit/media_kit.dart';
import 'package:provider/provider.dart';
import 'package:signals/signals_flutter.dart';

import 'package:syncopathy/model/battery_model.dart';
import 'package:syncopathy/model/player_model.dart';
import 'package:syncopathy/model/settings_model.dart';
import 'package:syncopathy/model/timesource_model.dart';
import 'package:syncopathy/player/media_kit_player.dart';
import 'package:syncopathy/syncopathy.dart';

import 'package:flutter/foundation.dart';

bool isDesktop() {
  return defaultTargetPlatform == TargetPlatform.windows ||
      defaultTargetPlatform == TargetPlatform.macOS ||
      defaultTargetPlatform == TargetPlatform.linux;
}

Future<Widget> _initializeAppAndRun({
  required bool simple,
  required String? file,
}) async {
  SettingsModel settings = SettingsModel();
  await settings.load();

  var batteryModel = BatteryModel();
  var mpvPlayer = MediaKitPlayer(videoOutput: true);

  var playerModel = PlayerModel(
    settings,
    TimesourceModel.fromPlayer(mpvPlayer),
    mpvPlayer,
    batteryModel,
  );

  return MultiProvider(
    providers: [
      Provider.value(value: settings),
      Provider.value(value: mpvPlayer),
      Provider.value(value: playerModel),
      Provider.value(value: batteryModel),
    ],
    child: const Syncopathy(),
  );
}

void main(List<String> args) async {
  // comment this out if you want to use the signals devtools
  SignalsObserver.instance = null;
  WidgetsFlutterBinding.ensureInitialized();
  MediaKit.ensureInitialized();

  final mainApp = await _initializeAppAndRun(simple: true, file: null);
  runApp(mainApp);
}
