import 'dart:async';

mixin EventSubscriber {
  final List<StreamSubscription> _subscriptions = [];

  void eventSubs(List<StreamSubscription> subscriptions) =>
      _subscriptions.addAll(subscriptions);

  Future<void> eventDispose() async {
    for (var sub in _subscriptions) {
      await sub.cancel();
    }
  }
}
