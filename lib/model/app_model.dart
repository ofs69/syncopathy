import 'package:flutter/widgets.dart';
import 'package:syncopathy/media_manager.dart';
import 'package:syncopathy/model/player_model.dart';
import 'package:syncopathy/model/settings.dart';
import 'package:syncopathy/model/user_category.dart';

class SyncopathyModel extends ChangeNotifier {
  final Settings settings;
  late final PlayerModel player;
  late final MediaManager mediaManager;

  ValueNotifier<UserCategory?> selectedCategory = ValueNotifier(null);

  SyncopathyModel(this.settings) {
    player = PlayerModel(settings);
    mediaManager = MediaManager(settings.mediaPaths);
  }

  void selectCategory(UserCategory? category) {
    selectedCategory.value = category;
  }

}
