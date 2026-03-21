import 'dart:async';

import 'package:rxdart/rxdart.dart';
import 'package:signals/signals_flutter.dart';

abstract class BaseRequest {
  int get id;
}

abstract class TaskQueue<I extends BaseRequest, O> {
  final Map<int, (I, Completer<O?>)> _pending = {};
  final ListSignal<int> _queue = listSignal([]);
  late final ReadonlySignal<int> _queueLengthRaw = computed(() {
    return _queue.length;
  });
  late final ReadonlySignal<int> queueLength = _queueLengthRaw
      .toStream()
      .throttleTime(
        const Duration(milliseconds: 300),
        leading: false,
        trailing: true,
      )
      .toSyncSignal(_queueLengthRaw.value);

  int _activeWorkers = 0;
  final int maxConcurrent;

  TaskQueue({required this.maxConcurrent});

  Future<O?> processRequest(I request);

  Future<O?> addRequest(I request) {
    if (_pending.containsKey(request.id)) {
      _queue.remove(request.id);
      _queue.add(request.id);
      return _pending[request.id]!.$2.future;
    }

    final completer = Completer<O?>();
    _pending[request.id] = (request, completer);
    _queue.add(request.id);

    _startWorkers();
    return completer.future;
  }

  void _startWorkers() {
    while (_activeWorkers < maxConcurrent && _queue.isNotEmpty) {
      _activeWorkers++;
      _workerLoop();
    }
  }

  Future<void> _workerLoop() async {
    while (_queue.isNotEmpty) {
      final id = _queue.removeLast();
      final entry = _pending.remove(id);
      if (entry == null) continue;

      final (request, completer) = entry;

      try {
        // Execute the request.
        final result = await processRequest(request);
        if (!completer.isCompleted) completer.complete(result);
      } catch (e, stack) {
        if (!completer.isCompleted) completer.completeError(e, stack);
      }
    }
    _activeWorkers--;
  }
}
