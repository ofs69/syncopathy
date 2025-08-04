import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:syncopathy/model/player_model.dart';
import 'package:syncopathy/model/settings.dart';
import 'package:syncopathy/model/user_category.dart';

class SyncopathyModel extends ChangeNotifier {
  final Settings settings;
  late final PlayerModel player;

  final _errorController = StreamController<String>.broadcast();
  final _notificationController = StreamController<String>.broadcast();

  Stream<String> get onError => _errorController.stream;
  Stream<String> get onNotification => _notificationController.stream;

  ValueNotifier<UserCategory?> selectedCategory = ValueNotifier(null);

  SyncopathyModel(this.settings) {
    player = PlayerModel(
      settings,
      _errorController,
      _notificationController,
    );
  }

  void selectCategory(UserCategory? category) {
    selectedCategory.value = category;
  }

  @override
  void dispose() {
    _errorController.close();
    _notificationController.close();
    super.dispose();
  }
}
