
import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:syncopathy/model/video_model.dart';

class Playlist extends ChangeNotifier {
  final List<Video> _videos;
  int _currentIndex;
  bool _isShuffled;

  Playlist({
    required List<Video> videos,
    int initialIndex = 0,
    bool isShuffled = false,
  })  : _videos = List.of(videos),
        _currentIndex = initialIndex,
        _isShuffled = isShuffled {
    if (_isShuffled) {
      _videos.shuffle();
    }
  }

  Video? get currentVideo => _videos.isEmpty ? null : _videos[_currentIndex];
  List<Video> get videos => UnmodifiableListView(_videos);

  bool get isShuffled => _isShuffled;

  void shuffle() {
    _isShuffled = !_isShuffled;
    if (_isShuffled) {
      final current = currentVideo;
      _videos.shuffle();
      if (current != null) {
        _currentIndex = _videos.indexOf(current);
      }
    } else {
      // Unshuffle logic would require original order, this is a simplified version
    }
    notifyListeners();
  }

  void next() {
    if (_videos.isNotEmpty) {
      _currentIndex = (_currentIndex + 1) % _videos.length;
      notifyListeners();
    }
  }

  void previous() {
    if (_videos.isNotEmpty) {
      _currentIndex = (_currentIndex - 1 + _videos.length) % _videos.length;
      notifyListeners();
    }
  }

  void setVideo(Video video) {
    final index = _videos.indexOf(video);
    if (index != -1) {
      _currentIndex = index;
      notifyListeners();
    }
  }
}
