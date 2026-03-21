import 'dart:collection';

// A list which retains it's buffer without letting it be freed by the GC
class BufferList<E> extends ListBase<E> {
  List<E> _buffer;
  int _length = 0;

  BufferList({required E initialValue, int initialCapacity = 10})
    : _buffer = List<E>.filled(initialCapacity, initialValue, growable: false);

  @override
  int get length => _length;

  @override
  set length(int newLength) {
    if (newLength < 0) throw ArgumentError("Length cannot be negative");
    if (newLength > _buffer.length) {
      _grow(newLength);
    }
    _length = newLength;
  }

  @override
  E operator [](int index) {
    if (index < 0 || index >= _length) throw RangeError.index(index, this);
    return _buffer[index];
  }

  @override
  void operator []=(int index, E value) {
    if (index < 0 || index >= _length) throw RangeError.index(index, this);
    _buffer[index] = value;
  }

  @override
  void clear() {
    _length = 0;
  }

  void _grow(int minCapacity) {
    int newCapacity = _buffer.length * 2;
    if (newCapacity < minCapacity) newCapacity = minCapacity;

    final newBuffer = List<E>.filled(newCapacity, _buffer[0], growable: false);

    for (int i = 0; i < _length; i++) {
      newBuffer[i] = _buffer[i];
    }
    _buffer = newBuffer;
  }

  int get capacity => _buffer.length;
}
