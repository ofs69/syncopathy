mixin EffectDispose {
  final List<Function> _disposeFn = [];

  void effectAdd(List<Function> dispose) => _disposeFn.addAll(dispose);

  void effectDispose() {
    for (var dispose in _disposeFn) {
      dispose();
    }
  }
}
