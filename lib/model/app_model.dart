import 'package:flutter/widgets.dart';
import 'package:syncopathy/media_manager.dart';
import 'package:syncopathy/model/player_model.dart';
import 'package:syncopathy/isar/settings.dart';
import 'package:syncopathy/isar/user_category.dart';

class SyncopathyModel extends ChangeNotifier {
  final Settings settings;
  late final PlayerModel player;
  late final MediaManager mediaManager;
  ValueNotifier<UserCategory?> selectedCategory = ValueNotifier(null);

  SyncopathyModel(this.settings) {
    mediaManager = MediaManager(settings.mediaPaths.value);
    player = PlayerModel(settings);
  }

  void selectCategory(UserCategory? category) {
    selectedCategory.value = category;
  }
}
