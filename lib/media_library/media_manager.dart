import 'package:signals/signals_flutter.dart';

class MediaManager {
  final Signal<bool> _isIndexing = signal(false);
  ReadonlySignal<bool> get isIndexing => _isIndexing;

  MediaManager();

  void startIndexing() {
    if (_isIndexing.value) return;
    _isIndexing.value = true;
    try {
      // index
    } finally {
      _isIndexing.value = false;
    }
  }
}
