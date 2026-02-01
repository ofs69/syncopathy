import 'dart:math';

import 'package:async_locks/async_locks.dart';
import 'package:collection/collection.dart';
import 'package:signals/signals_flutter.dart';
import 'package:syncopathy/helper/constants.dart';
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
  final Signal<Funscript?> _currentFunscript;
  late final Function _currentFunscriptEffectDispose;

  final List<FunscriptAction> _currentBuffer = List.empty(growable: true);

  static const int batchSize = 50;
  final FunscriptDevice? _device;
  final Signal<bool> canPlay = signal(false);
  final Lock bufferLock = Lock();

  FunscriptStreamController(this._device, this._currentFunscript) {
    _currentFunscriptEffectDispose = effect(() {
      _handleFunscriptChange(_currentFunscript.value);
    });
  }

  void dispose() {
    _currentFunscriptEffectDispose();
  }

  Future<void> _bufferBatch(
    List<FunscriptAction> batch,
    int tailActionIndex,
    bool flush,
  ) async {
    if (flush) {
      _currentBuffer.clear();
      canPlay.value = false;
    }
    _currentBuffer.addAll(batch);
    Logger.debug(
      "BUFFER: ${batch.length} -> ${_currentBuffer.length} ${flush ? "FLUSH" : ""}",
    );

    await _device?.bufferBatch(batch, tailActionIndex, flush);
    canPlay.value = true;
  }

  Future<void> _loadFunscript() async {
    canPlay.value = false;
    await _device?.initStream();
  }

  Future<void> _unloadFunscript() async {
    _currentBuffer.clear();
    canPlay.value = false;
    await _device?.deinitStream();
  }

  Future<void> stopPlayback() async {
    await _device?.stopPlayback();
  }

  Future<void> startPlayback(int positionMs, double playbackRate) async {
    if (_currentFunscript.value == null || !canPlay.value) return;
    await _device?.startPlayback(positionMs, playbackRate);
  }

  Future<bool> bufferFunscript(
    int positionMs,
    bool paused,
    double playbackRate,
  ) async {
    final currentFunscript = _currentFunscript.value;
    if (currentFunscript == null) return false;

    try {
      bufferLock.cancelAll();
      await bufferLock.acquire();
    } on LockAcquireFailureException catch (_) {
      return false;
    }

    try {
      // subtract an offset for the buffering
      // this causes some points that are already past to be buffered
      // which should prevent some issues
      positionMs -= paddingIntervalMs;

      // Determine if we need to flush the buffer.
      // - If playback is paused.
      // - If we seeked outside the current buffer range.
      bool flush = paused;
      if (_currentBuffer.isNotEmpty) {
        final firstAction = _currentBuffer.first;
        final lastAction = _currentBuffer.last;
        if (positionMs < firstAction.at) {
          flush = _currentBuffer.first.at != currentFunscript.actions.first.at;
        } else if (positionMs > lastAction.at) {
          flush = _currentBuffer.last.at != currentFunscript.actions.last.at;
        }
        if (flush) {
          Logger.debug(
            "Position $positionMs ms is outside of buffer [${firstAction.at}, ${lastAction.at}], flushing.",
          );
        }
      } else if (currentFunscript.actions.isNotEmpty) {
        // Buffer is empty, but we have a script, so it's the initial fill.
        flush = true;
      }

      // Find where we are in the current buffer
      final indexInBuffer = _currentBuffer.lowerBound(
        FunscriptAction(at: positionMs, pos: 0),
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
          startFromIndex = currentFunscript.actions.lowerBound(
            FunscriptAction(at: positionMs, pos: 0),
          );

          if (startFromIndex >= currentFunscript.actions.length) {
            startFromIndex = currentFunscript.actions.length - 1;
          }

          if (startFromIndex > 0 &&
              currentFunscript.actions[startFromIndex].at > positionMs) {
            startFromIndex--;
          }
          if (startFromIndex < currentFunscript.actions.length) {
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
                currentFunscript.actions.indexOf(lastBufferedAction) + 1;
          }

          if (startFromIndex < currentFunscript.actions.length) {
            Logger.debug(
              "Appending to buffer. Starting new batch from index $startFromIndex",
            );
          }
        }

        if (startFromIndex < currentFunscript.actions.length) {
          final endOfBatchIndex = min(
            startFromIndex + batchSize,
            currentFunscript.actions.length,
          );
          final batch = currentFunscript.actions.sublist(
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
            await _bufferBatch(batch, endOfBatchIndex, flush);
            return true;
          }
        }
      }
      return false;
    } finally {
      bufferLock.release();
    }
  }

  Future<void> positionUpdate(
    int positionMs,
    bool paused,
    double playbackRate,
  ) async {
    await _device?.positionUpdate(positionMs, paused, playbackRate);
  }

  void _handleFunscriptChange(Funscript? currentFunscript) async {
    if (currentFunscript != null) {
      await _loadFunscript();
    } else {
      await _unloadFunscript();
    }
  }
}
