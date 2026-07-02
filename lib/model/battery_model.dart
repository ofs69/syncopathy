import 'package:signals/signals_flutter.dart';

class BatteryModel {
  final hasBattery = signal<bool>(false);
  final chargerConnected = signal<bool>(false);
  final batteryLevel = signal<int>(100);
}
