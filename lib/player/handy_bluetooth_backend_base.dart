import 'package:flutter/material.dart';
import 'package:signals/signals_flutter.dart';
import 'package:syncopathy/generated/constants.pb.dart';
import 'package:syncopathy/notification_feed.dart';
import 'package:syncopathy/player/handy_ble.dart';
import 'package:syncopathy/player/handy_native_hsp_mixin.dart';
import 'package:syncopathy/player/player_backend.dart';

abstract class HandyBluetoothBackendBase extends PlayerBackend
    with HandyHspCommandDelegation
    implements IHandyHspBase, ICommandBackendBase {
  @override
  ReadonlySignal<bool> get connected => _connected;
  late final ReadonlySignal<bool> _connected = computed(() {
    return _handyBle.value?.isConnected.value ?? false;
  });

  @override
  ReadonlySignal<bool> get isConnecting => _isConnecting;
  final Signal<bool> _isConnecting = signal(false);

  @override
  bool get isBluetooth => true;

  final Signal<HandyBle?> _handyBle = signal(null);
  late final ReadonlySignal<HspState?> hspState = computed(() {
    return _handyBle.value?.hspState.value;
  });

  Function(bool)? hspThresholdReachedHandler;
  Function()? hspLoopHandler;

  @override
  ReadonlySignal<HspStateAdapter?> get hspStateAdapter => _hspStateAdapter;
  late final ReadonlySignal<HspStateAdapter?> _hspStateAdapter;

  HandyBluetoothBackendBase({
    required super.settingsModel,
    required super.batteryModel,
    required super.timesource,
    required super.currentlyOpen,
    required super.backendType,
  }) {
    _hspStateAdapter = computed(() {
      final state = hspState.value;
      if (state == null) return null;
      return HspStateAdapter.fromNativeState(state);
    });
    effectAdd([
      effect(() {
        if (!connected.value) {
          _handyBle.value?.dispose();
          _handyBle.value = null;
          batteryModel.hasBattery.value = false;
        }
      }),
    ]);
  }

  @override
  Widget settingsWidget(BuildContext context) {
    return Text("Only use this with firmware v4.1.1+");
  }

  @override
  Future<void> tryConnect() async {
    await _handyBle.value?.dispose();
    _handyBle.value = null;

    _isConnecting.value = true;
    try {
      final ble = await HandyBle.startScanning(
        settingsModel.min,
        settingsModel.max,
      );
      _handyBle.value = ble;
      if (ble == null) {
        // scanForDevice already timed out (30s) or found nothing.
        AlertManager.showError(
          "No Handy found. Make sure it's powered on, nearby, and Bluetooth "
          "is enabled.",
        );
        return;
      }
      await ble.init();

      // TODO: this is jank
      ble.hspThresholdReached = (starving) =>
          hspThresholdReachedHandler?.call(starving);
      ble.hspLooped = () => hspLoopHandler?.call();

      effectAdd([
        effect(() {
          final battery = _handyBle.value?.batteryState.value;
          batteryModel.hasBattery.value = battery != null;
          if (battery != null) {
            batteryModel.chargerConnected.value = battery.chargerConnected;
            batteryModel.batteryLevel.value = battery.level;
          }
        }),
      ]);
    } catch (e) {
      // A thrown scan/init (adapter off, permission denied, GATT failure)
      // would otherwise strand the button on "Scanning…" and leak the
      // half-open handle. Tear it down and surface a reason.
      await _handyBle.value?.dispose();
      _handyBle.value = null;
      AlertManager.showError("Couldn't connect to the Handy: $e");
    } finally {
      _isConnecting.value = false;
    }
  }

  @override
  Future<void> dispose() async {
    await super.dispose();
    await _handyBle.value?.dispose();
    _handyBle.value = null;
  }

  @override
  IHspCommands? get hspCommandTarget => _handyBle.value;
}
