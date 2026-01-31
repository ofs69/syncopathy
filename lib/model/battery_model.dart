import 'package:signals/signals.dart';

class BatteryModel {
  var hasBattery = signal<bool>(false);
  var chargerConntected = signal<bool>(false);
  var batteryLevel = signal<int>(100);
}
