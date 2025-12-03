import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:syncopathy/sqlite/models/video_model.dart';

class Playlist extends ChangeNotifier {
  final List<Video> _videos;
  final List<Video> _originalVideos; // Store the original order
  final ValueNotifier<int> _currentIndex;
  bool _isShuffled;

  Playlist({
    required List<Video> videos,
    int initialIndex = 0,
    bool isShuffled = false,
  }) : _videos = List.of(videos),
       _originalVideos = List.of(videos), // Initialize with original order
       _currentIndex = ValueNotifier<int>(initialIndex),
       _isShuffled = isShuffled {
    if (_isShuffled) {
      _videos.shuffle();
    }
  }

  Video? get currentVideo =>
      _videos.isEmpty ? null : _videos[_currentIndex.value];
  ValueNotifier<int> get currentIndex => _currentIndex;
  List<Video> get videos => UnmodifiableListView(_videos);

  bool get isShuffled => _isShuffled;

  void shuffle() {
    _isShuffled = !_isShuffled;
    if (_isShuffled) {
      _videos.shuffle();
    } else {
      _videos
        ..clear()
        ..addAll(_originalVideos);
    }
    notifyListeners();
  }

  void next() {
    if (_videos.isNotEmpty) {
      _currentIndex.value = (_currentIndex.value + 1) % _videos.length;
      notifyListeners();
    }
  }

  void previous() {
    if (_videos.isNotEmpty) {
      _currentIndex.value =
          (_currentIndex.value - 1 + _videos.length) % _videos.length;
      notifyListeners();
    }
  }
}
