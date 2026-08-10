import 'dart:async';

import 'package:rxdart/rxdart.dart';
import 'package:signals/signals_flutter.dart';

abstract class BaseRequest {
  int get id;
}

class _PendingTask<I, O> {
  final I request;
  final Completer<O?> completer = Completer<O?>();

  /// Callers awaiting this task. [TaskQueue.addRequest] hands back the same
  /// future for an id that is already queued, so the task may only be dropped
  /// once every one of those callers has cancelled.
  int waiters = 1;

  _PendingTask(this.request);
}

/// One caller's claim on a queued request, handed out by [TaskQueue.addRequest].
///
/// [cancel] withdraws only this claim; the task is dropped once every claim on
/// it is gone. A ticket is bound to the task it was issued for, so cancelling
/// one whose task has already run is a no-op and can never drop a later request
/// that happens to reuse the same id.
class RequestTicket<O> {
  /// The task's result, or null if every claim was withdrawn before a worker
  /// picked it up.
  final Future<O?> result;

  final void Function() _release;
  bool _cancelled = false;

  RequestTicket._(this.result, this._release);

  void cancel() {
    if (_cancelled) return;
    _cancelled = true;
    _release();
  }
}

abstract class TaskQueue<I extends BaseRequest, O> {
  final Map<int, _PendingTask<I, O>> _pending = {};
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

  RequestTicket<O> addRequest(I request) {
    final existing = _pending[request.id];
    if (existing != null) {
      existing.waiters++;
      _queue.remove(request.id);
      _queue.add(request.id);
      return RequestTicket._(
        existing.completer.future,
        () => _releaseClaim(existing),
      );
    }

    final task = _PendingTask<I, O>(request);
    _pending[request.id] = task;
    _queue.add(request.id);

    _startWorkers();
    return RequestTicket._(task.completer.future, () => _releaseClaim(task));
  }

  /// Withdraws one claim on [task], dropping it and completing its future with
  /// null once no claim is left.
  ///
  /// Requests a worker has already picked up run to completion: the backlog is
  /// where the wasted work is (a fast scroll can queue hundreds of items), and
  /// aborting mid-flight would leave a partially written output behind. The
  /// identity check covers that case as well as an already-finished task, whose
  /// id may since have been re-queued by somebody else.
  void _releaseClaim(_PendingTask<I, O> task) {
    if (--task.waiters > 0) return;

    final id = task.request.id;
    if (!identical(_pending[id], task)) return;

    _pending.remove(id);
    _queue.remove(id);
    if (!task.completer.isCompleted) task.completer.complete(null);
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
      final task = _pending.remove(id);
      if (task == null) continue;

      try {
        // Execute the request.
        final result = await processRequest(task.request);
        if (!task.completer.isCompleted) task.completer.complete(result);
      } catch (e, stack) {
        if (!task.completer.isCompleted) task.completer.completeError(e, stack);
      }
    }
    _activeWorkers--;
  }
}
