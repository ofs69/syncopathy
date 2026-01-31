import 'package:flutter/widgets.dart';
import 'package:syncopathy/media_manager.dart';
import 'package:syncopathy/model/battery_model.dart';
import 'package:syncopathy/model/player_model.dart';
import 'package:syncopathy/model/settings_model.dart';
import 'package:syncopathy/sqlite/models/user_category.dart';

class SyncopathyModel extends ChangeNotifier {
  final SettingsModel settings;
  final BatteryModel batteryModel;
  final MediaManager mediaManager;
  late final PlayerModel player;
  ValueNotifier<UserCategory?> selectedCategory = ValueNotifier(null);
  ValueNotifier<bool> showDebugNotifications = ValueNotifier(false);

  SyncopathyModel(this.settings, this.batteryModel, this.mediaManager) {
    player = PlayerModel(settings, batteryModel);
  }

  void selectCategory(UserCategory? category) {
    selectedCategory.value = category;
  }
}
