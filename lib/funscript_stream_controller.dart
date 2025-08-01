import 'package:syncopathy/model/funscript.dart';
import 'package:syncopathy/logging.dart';

abstract class FunscriptDevice {
  Future<void> bufferBatch(
    List<FunscriptAction> batch,
    int tailActionIndex,
    bool flush,
  );
  Future<void> initStream();
  Future<void> deinitStream();
  Future<void> stopPlayback();
  Future<void> startPlayback(int positionMs, double playbackRate);
  Future<void> positionUpdate(int positionMs, bool paused, double playbackRate);
}

class FunscriptStreamController {
  Funscript? _currentFunscript;
  final List<FunscriptAction> _currentBuffer = List.empty(growable: true);
  static const int batchSize = 50;

  final FunscriptDevice? _device;

  FunscriptStreamController(this._device);

  void _bufferBatch(
    List<FunscriptAction> batch,
    int tailActionIndex,
    bool flush,
  ) async {
    if (flush) {
      _currentBuffer.clear();
    }
    _currentBuffer.addAll(batch);
    Logger.debug(
      "BUFFER: ${batch.length} -> ${_currentBuffer.length} ${flush ? "FLUSH" : ""}",
    );

    await _device?.bufferBatch(batch, tailActionIndex, flush);
  }

  void loadFunscript(
    Funscript funscript,
    int positionMs,
    double playbackRate,
  ) async {
    _currentFunscript = funscript;
    await _device?.initStream();

    positionUpdate(positionMs, true, playbackRate);
  }

  void unloadFunscript() async {
    _currentFunscript = null;
    _currentBuffer.clear();
    await _device?.deinitStream();
  }

  void stopPlayback() async {
    await _device?.stopPlayback();
  }

  void startPlayback(int positionMs, double playbackRate) async {
    if (_currentFunscript == null) return;
    await _device?.startPlayback(positionMs, playbackRate);
  }

  void positionUpdate(int positionMs, bool paused, double playbackRate) async {
    if (_currentFunscript == null) return;

    bool flush = paused;
    if (_currentBuffer.isNotEmpty) {
      var first = _currentBuffer.first;
      var last = _currentBuffer.last;
      if (positionMs > last.at || positionMs < first.at) {
        if (last.at != _currentFunscript!.actions.last.at) {
          flush = true;
        }
      }
    }

    var indexInBuffer = _currentBuffer.indexWhere(
      (action) => action.at >= positionMs,
    );

    if (indexInBuffer >= 0) {
      var actionInBuffer = _currentBuffer[indexInBuffer];

      var indexInScript = _currentFunscript!.actions.indexWhere(
        (action) => action.at >= positionMs,
      );
      if (indexInScript == -1) {
        indexInScript = _currentFunscript!.actions.length - 1;
      }

      var actionInScript = _currentFunscript!.actions[indexInScript];
      indexInBuffer = actionInBuffer.at == actionInScript.at
          ? indexInBuffer
          : -1;
    }

    if (_currentBuffer.length - indexInBuffer <= (batchSize / 2) ||
        indexInBuffer == -1) {
      // buffer batch
      var lastIndex = flush
          ? _currentFunscript!.actions.indexWhere(
              (action) => action.at >= positionMs,
            )
          : _currentFunscript!.actions.indexOf(_currentBuffer.last) + 1;
      if (lastIndex == -1) {
        lastIndex = 0;
      }

      if (lastIndex < _currentFunscript!.actions.length) {
        var batch = List<FunscriptAction>.empty(growable: true);
        for (int i = 0; i < batchSize; i++) {
          if (lastIndex + i >= _currentFunscript!.actions.length) {
            break;
          }

          var action = _currentFunscript!.actions[lastIndex + i];
          batch.add(action);
        }
        Logger.debug("BATCHING $lastIndex -> ${lastIndex + batch.length}");

        _bufferBatch(batch, lastIndex + batch.length, flush);
      }
    } else {
      // NOP
    }
    await _device?.positionUpdate(positionMs, paused, playbackRate);
  }
}
