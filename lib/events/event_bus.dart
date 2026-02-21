import 'package:event_bus/event_bus.dart';

class Events {
  static final Events _instance = Events._internal();
  factory Events() => _instance;
  Events._internal();

  final EventBus _eventBus = EventBus(sync: false);

  static void emit(dynamic event) => Events()._emit(event);
  static Stream<T> on<T>() => Events()._on<T>();

  void _emit(dynamic event) => _eventBus.fire(event);
  Stream<T> _on<T>() => _eventBus.on<T>();
}
