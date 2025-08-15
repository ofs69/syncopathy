import 'dart:math';

import 'package:collection/collection.dart';
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

  static const int batchSize = 40;
  final FunscriptDevice? _device;

  FunscriptStreamController(this._device);

  Future<void> _bufferBatch(
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

  Future<void> loadFunscript(Funscript funscript, double playbackRate) async {
    _currentFunscript = funscript;
    await _device?.initStream();

    await positionUpdate(0, true, playbackRate);
  }

  Future<void> unloadFunscript() async {
    _currentFunscript = null;
    _currentBuffer.clear();
    await _device?.deinitStream();
  }

  Future<void> stopPlayback() async {
    await _device?.stopPlayback();
  }

  Future<void> startPlayback(int positionMs, double playbackRate) async {
    if (_currentFunscript == null) return;
    positionUpdate(positionMs, false, playbackRate);
    await _device?.startPlayback(positionMs, playbackRate);
  }

  Future<void> positionUpdate(
    int positionMs,
    bool paused,
    double playbackRate,
  ) async {
    if (_currentFunscript == null) return;

    // Determine if we need to flush the buffer.
    // - If playback is paused.
    // - If we seeked outside the current buffer range.
    bool flush = paused;
    if (_currentBuffer.isNotEmpty) {
      final firstAction = _currentBuffer.first;
      final lastAction = _currentBuffer.last;
      if (positionMs < firstAction.at || positionMs > lastAction.at) {
        flush = true;

        if (_currentBuffer.isNotEmpty) {
          flush = _currentBuffer.last.at != _currentFunscript!.actions.last.at;
        }
        if (flush) {
          Logger.debug(
            "Position $positionMs ms is outside of buffer [${firstAction.at}, ${lastAction.at}], flushing.",
          );
        }
      }
    } else if (_currentFunscript!.actions.isNotEmpty) {
      // Buffer is empty, but we have a script, so it's the initial fill.
      flush = true;
    }

    // Find where we are in the current buffer
    final indexInBuffer = _currentBuffer.indexWhere(
      (action) => action.at >= positionMs,
    );

    // Check if we need to buffer a new batch.
    // We'll buffer if:
    // - The buffer needs a flush (e.g. we seeked).
    // - We are getting close to the end of the buffer.
    final remainingActions = indexInBuffer != -1
        ? _currentBuffer.length - indexInBuffer
        : 0;
    if (flush || (indexInBuffer != -1 && remainingActions < batchSize / 2)) {
      int startFromIndex;
      if (flush) {
        // Determine the index of the action at or just before the current position
        startFromIndex = _currentFunscript!.actions.lowerBound(
          FunscriptAction(at: positionMs, pos: 0),
        );

        if (startFromIndex >= _currentFunscript!.actions.length) {
          startFromIndex = _currentFunscript!.actions.length - 1;
        }

        if (startFromIndex > 0 &&
            _currentFunscript!.actions[startFromIndex].at > positionMs) {
          startFromIndex--;
        }
        if (startFromIndex < _currentFunscript!.actions.length) {
          Logger.debug(
            "Flushing buffer. Starting new batch from index $startFromIndex",
          );
        }
      } else {
        final lastBufferedAction = _currentBuffer.lastOrNull;
        if (lastBufferedAction == null) {
          startFromIndex = 0;
        } else {
          startFromIndex =
              _currentFunscript!.actions.indexOf(lastBufferedAction) + 1;
        }

        if (startFromIndex < _currentFunscript!.actions.length) {
          Logger.debug(
            "Appending to buffer. Starting new batch from index $startFromIndex",
          );
        }
      }

      if (startFromIndex < _currentFunscript!.actions.length) {
        final endOfBatchIndex = min(
          startFromIndex + batchSize,
          _currentFunscript!.actions.length,
        );
        final batch = _currentFunscript!.actions.sublist(
          startFromIndex,
          endOfBatchIndex,
        );

        bool batchIsSameAsBuffer = false;
        if (_currentBuffer.isNotEmpty) {
          batchIsSameAsBuffer =
              batch.first.at == _currentBuffer.first.at &&
              batch.last.at == _currentBuffer.last.at;
        }

        if (batch.isNotEmpty && !batchIsSameAsBuffer) {
          Logger.debug(
            "Preparing batch of size ${batch.length}. From ${batch.first.at}ms to ${batch.last.at}ms.",
          );
          _bufferBatch(batch, endOfBatchIndex, flush);
        }
      }
    }

    await _device?.positionUpdate(positionMs, paused, playbackRate);
  }
}
