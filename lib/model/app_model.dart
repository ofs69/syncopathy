import 'package:flutter/widgets.dart';
import 'package:syncopathy/media_manager.dart';
import 'package:syncopathy/model/player_model.dart';
import 'package:syncopathy/model/playlist.dart';
import 'package:syncopathy/model/settings.dart';
import 'package:syncopathy/model/user_category.dart';
import 'package:syncopathy/model/video_model.dart';

class SyncopathyModel extends ChangeNotifier {
  final Settings settings;
  late final PlayerModel player;
  late final MediaManager mediaManager;
  Playlist? playlist;

  ValueNotifier<UserCategory?> selectedCategory = ValueNotifier(null);

  SyncopathyModel(this.settings) {
    mediaManager = MediaManager(settings.mediaPaths.value);
    player = PlayerModel(settings, mediaManager);
  }

  void selectCategory(UserCategory? category) {
    selectedCategory.value = category;
  }

  void setPlaylist(List<Video> videos, int initialIndex) {
    playlist = Playlist(videos: videos, initialIndex: initialIndex);
    notifyListeners();
  }

  void clearPlaylist() {
    playlist = null;
    notifyListeners();
  }
}
