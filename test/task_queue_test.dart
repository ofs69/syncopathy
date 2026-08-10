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
  group('TaskQueue.cancelRequest', () {
    test('drops a queued request and completes it with null', () async {
      final queue = _TestQueue();
      final blocking = queue.addRequest(_TestRequest(1));
      final queued = queue.addRequest(_TestRequest(2));

      queue.cancelRequest(2);
      expect(await queued, isNull);

      queue.gate.complete();
      expect(await blocking, 1);
      expect(queue.processed, [1], reason: 'the cancelled job never ran');
    });

    test('keeps a shared request until every caller cancels', () async {
      final queue = _TestQueue();
      final blocking = queue.addRequest(_TestRequest(1));
      final first = queue.addRequest(_TestRequest(2));
      final second = queue.addRequest(_TestRequest(2));

      // Only one of the two callers goes away.
      queue.cancelRequest(2);
      queue.gate.complete();

      expect(await first, 2);
      expect(await second, 2);
      expect(await blocking, 1);
      expect(queue.processed, [1, 2]);
    });

    test('drops a shared request once every caller cancels', () async {
      final queue = _TestQueue();
      final blocking = queue.addRequest(_TestRequest(1));
      final first = queue.addRequest(_TestRequest(2));
      final second = queue.addRequest(_TestRequest(2));

      queue.cancelRequest(2);
      queue.cancelRequest(2);

      expect(await first, isNull);
      expect(await second, isNull);

      queue.gate.complete();
      expect(await blocking, 1);
      expect(queue.processed, [1]);
    });

    test('is a no-op for an in-flight or unknown request', () async {
      final queue = _TestQueue();
      final blocking = queue.addRequest(_TestRequest(1));

      queue.cancelRequest(1); // already handed to the worker
      queue.cancelRequest(99); // never seen

      queue.gate.complete();
      expect(await blocking, 1);
      expect(queue.processed, [1]);
    });

    test('keeps draining the remaining queue after a cancellation', () async {
      final queue = _TestQueue();
      final blocking = queue.addRequest(_TestRequest(1));
      final cancelled = queue.addRequest(_TestRequest(2));
      final survivor = queue.addRequest(_TestRequest(3));

      queue.cancelRequest(2);
      queue.gate.complete();

      expect(await cancelled, isNull);
      expect(await survivor, 3);
      expect(await blocking, 1);
      expect(queue.processed, [1, 3]);
    });
  });
}
