import 'package:flutter_test/flutter_test.dart';
import 'package:signals/signals_flutter.dart';
import 'package:syncopathy/main.dart';

void main() {
  group('unwrapSignalError', () {
    test('returns a plain error and its stack untouched', () {
      final error = StateError('boom');
      final stack = StackTrace.current;

      final (cause, causeStack) = unwrapSignalError(error, stack);

      expect(cause, same(error));
      expect(causeStack, same(stack));
    });

    test('unwraps the cause and prefers the stack from inside the effect', () {
      final error = StateError('marked dirty mid-frame');
      final effectStack = StackTrace.current;
      final batchStack = StackTrace.current;

      final (cause, causeStack) = unwrapSignalError(
        SignalEffectException(error, effectStack),
        batchStack,
      );

      expect(cause, same(error));
      expect(
        causeStack,
        same(effectStack),
        reason: 'the batch stack stops at endBatch and says nothing useful',
      );
    });

    test('unwraps repeatedly for nested batches', () {
      final error = StateError('boom');

      final (cause, _) = unwrapSignalError(
        SignalEffectException(SignalEffectException(error, null), null),
        null,
      );

      expect(cause, same(error));
    });

    test('keeps the wrapper when it carries no cause', () {
      final wrapper = SignalEffectException(null, null);
      final stack = StackTrace.current;

      final (cause, causeStack) = unwrapSignalError(wrapper, stack);

      expect(cause, same(wrapper));
      expect(causeStack, same(stack));
    });
  });
}
