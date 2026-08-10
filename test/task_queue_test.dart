import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:syncopathy/helper/task_queue.dart';

class _TestRequest extends BaseRequest {
  @override
  final int id;
  _TestRequest(this.id);
}

/// Single-worker queue whose first job blocks on [gate], so every request added
/// afterwards stays queued and can be cancelled before a worker picks it up.
class _TestQueue extends TaskQueue<_TestRequest, int> {
  _TestQueue() : super(maxConcurrent: 1);

  final List<int> processed = [];
  final Completer<void> gate = Completer<void>();
  bool _blockNext = true;

  @override
  Future<int?> processRequest(_TestRequest request) async {
    if (_blockNext) {
      _blockNext = false;
      await gate.future;
    }
    processed.add(request.id);
    return request.id;
  }
}

void main() {
  group('RequestTicket.cancel', () {
    test('drops a queued request and completes it with null', () async {
      final queue = _TestQueue();
      final blocking = queue.addRequest(_TestRequest(1));
      final queued = queue.addRequest(_TestRequest(2));

      queued.cancel();
      expect(await queued.result, isNull);

      queue.gate.complete();
      expect(await blocking.result, 1);
      expect(queue.processed, [1], reason: 'the cancelled job never ran');
    });

    test('keeps a shared request until every caller cancels', () async {
      final queue = _TestQueue();
      final blocking = queue.addRequest(_TestRequest(1));
      final first = queue.addRequest(_TestRequest(2));
      final second = queue.addRequest(_TestRequest(2));

      // Only one of the two callers goes away.
      first.cancel();
      queue.gate.complete();

      expect(await first.result, 2);
      expect(await second.result, 2);
      expect(await blocking.result, 1);
      expect(queue.processed, [1, 2]);
    });

    test('drops a shared request once every caller cancels', () async {
      final queue = _TestQueue();
      final blocking = queue.addRequest(_TestRequest(1));
      final first = queue.addRequest(_TestRequest(2));
      final second = queue.addRequest(_TestRequest(2));

      first.cancel();
      second.cancel();

      expect(await first.result, isNull);
      expect(await second.result, isNull);

      queue.gate.complete();
      expect(await blocking.result, 1);
      expect(queue.processed, [1]);
    });

    test('is a no-op for an in-flight request', () async {
      final queue = _TestQueue();
      final blocking = queue.addRequest(_TestRequest(1));

      blocking.cancel(); // already handed to the worker

      queue.gate.complete();
      expect(await blocking.result, 1);
      expect(queue.processed, [1]);
    });

    test('is a no-op when cancelled twice', () async {
      final queue = _TestQueue();
      final blocking = queue.addRequest(_TestRequest(1));
      final first = queue.addRequest(_TestRequest(2));
      final second = queue.addRequest(_TestRequest(2));

      first.cancel();
      first.cancel(); // must not consume the second caller's claim

      queue.gate.complete();
      expect(await second.result, 2);
      expect(await blocking.result, 1);
      expect(queue.processed, [1, 2]);
    });

    test('does not drop a later request that reuses the id', () async {
      final queue = _TestQueue();
      final blocking = queue.addRequest(_TestRequest(1));
      final finished = queue.addRequest(_TestRequest(2));

      queue.gate.complete();
      expect(await finished.result, 2);

      // Somebody else asks for the same id, then the first caller goes away —
      // the media grid does exactly this when a re-sort replaces a card that
      // stays on screen.
      final resubmitted = queue.addRequest(_TestRequest(2));
      finished.cancel();

      expect(await resubmitted.result, 2);
      expect(await blocking.result, 1);
      expect(queue.processed, [1, 2, 2]);
    });

    test('does not notify queueLength watchers during the enqueue', () async {
      final queue = _TestQueue();
      var notifications = 0;
      queue.queueLength.subscribe((_) => notifications++);
      // subscribe() delivers the current value immediately.
      final baseline = notifications;

      queue.addRequest(_TestRequest(1));
      queue.addRequest(_TestRequest(2));
      queue.addRequest(_TestRequest(3));

      // Enqueuing must not write a signal in the caller's stack. Thumbnail
      // cards enqueue from initState, which a lazy grid runs during layout, and
      // a watcher marked dirty at that point makes Flutter throw.
      expect(
        notifications,
        baseline,
        reason: 'queueLength was written during addRequest',
      );

      await Future<void>.delayed(const Duration(milliseconds: 400));
      expect(notifications, greaterThan(baseline));
      expect(queue.queueLength.value, 2, reason: 'one job is in flight');

      queue.gate.complete();
    });

    test('keeps draining the remaining queue after a cancellation', () async {
      final queue = _TestQueue();
      final blocking = queue.addRequest(_TestRequest(1));
      final cancelled = queue.addRequest(_TestRequest(2));
      final survivor = queue.addRequest(_TestRequest(3));

      cancelled.cancel();
      queue.gate.complete();

      expect(await cancelled.result, isNull);
      expect(await survivor.result, 3);
      expect(await blocking.result, 1);
      expect(queue.processed, [1, 3]);
    });
  });
}
