import 'package:flutter/material.dart';
import 'package:signals/signals_flutter.dart';
import 'package:syncopathy/generated/constants.pb.dart';
import 'package:syncopathy/logging.dart';
import 'package:syncopathy/notification_feed.dart';
import 'package:syncopathy/player/handy_ble.dart';
import 'package:syncopathy/player/handy_native_hsp_mixin.dart';
import 'package:syncopathy/player/player_backend.dart';
import 'package:syncopathy/player/reconnect.dart';

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

  /// How often a connection that dropped on its own is retried, when
  /// [SettingsModel.autoReconnect] is on.
  ///
  /// A Handy does not only drop out of range for a moment; it also gets
  /// switched off, put on the charger, or taken to another room. Two attempts
  /// covered the first case and none of the others, so anything longer than a
  /// glitch ended with the user reconnecting by hand. With the backoff below
  /// these attempts keep watch for a few minutes, which is long enough for a
  /// device to be switched off and on again.
  static const int maxReconnectAttempts = 6;

  /// Breathing room for the BLE stack to finish tearing the old link down and
  /// for the device to start advertising again before the next scan.
  static const Duration reconnectDelay = Duration(seconds: 2);

  /// Ceiling on the doubling gap between attempts. Keeps a device that is off
  /// from being scanned for continuously, while staying short enough that one
  /// switched back on is found promptly.
  static const Duration maxReconnectDelay = Duration(seconds: 30);

  /// Only a connection that was established and then lost is worth retrying: a
  /// scan that never found anything has already told the user so.
  bool _wasConnected = false;
  bool _reconnecting = false;
  bool _disposed = false;

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
        if (connected.value) {
          _wasConnected = true;
          return;
        }

        _handyBle.value?.dispose();
        _handyBle.value = null;
        batteryModel.hasBattery.value = false;

        // untracked: the retry reads settings and drives tryConnect, none of
        // which should become a dependency of this effect.
        if (_wasConnected) untracked(_reconnectAfterLoss);
      }),
    ]);
  }

  /// Re-establishes a connection that dropped on its own, up to
  /// [maxReconnectAttempts] times. A user-initiated disconnect disposes the
  /// backend, so it never reaches this. Each loss gets its own budget: a
  /// reconnect that worked and then dropped again is retried afresh.
  Future<void> _reconnectAfterLoss() async {
    if (_reconnecting || _disposed) return;
    if (!settingsModel.autoReconnect.value) return;

    _reconnecting = true;
    try {
      AlertManager.showWarning(
        "Lost the connection to the Handy. Reconnecting…",
      );

      final reconnected = await retryUntilConnected(
        connect: tryConnect,
        isConnected: () => connected.value,
        // Turning auto-reconnect off mid-campaign is the user saying to stop,
        // and the campaign can run for minutes — long enough for them to.
        isCancelled: () => _disposed || !settingsModel.autoReconnect.value,
        maxAttempts: maxReconnectAttempts,
        delay: reconnectDelay,
        maxDelay: maxReconnectDelay,
        onAttempt: (attempt) =>
            Logger.info("Reconnect attempt $attempt of $maxReconnectAttempts"),
      );

      if (reconnected) {
        AlertManager.showSuccess("Reconnected to the Handy.");
      } else if (!_disposed && settingsModel.autoReconnect.value) {
        // Only when the attempts were actually spent. A campaign the user
        // called off by switching auto-reconnect back off is not a failure,
        // and reporting it as one would answer their own action with an error.
        AlertManager.showError(
          "Couldn't reconnect to the Handy after $maxReconnectAttempts "
          "attempts. Connect again when it's ready.",
        );
      }
    } finally {
      _reconnecting = false;
    }
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
        _reportConnectFailure(
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
      _reportConnectFailure("Couldn't connect to the Handy: $e");
    } finally {
      _isConnecting.value = false;
    }
  }

  /// A failed attempt is only worth an alert when the user asked for this
  /// connection; while reconnecting, [_reconnectAfterLoss] reports the outcome
  /// once instead of once per attempt.
  void _reportConnectFailure(String message) {
    if (_reconnecting) {
      Logger.warning(message);
    } else {
      AlertManager.showError(message);
    }
  }

  @override
  Future<void> dispose() async {
    _disposed = true;
    await super.dispose();
    await _handyBle.value?.dispose();
    _handyBle.value = null;
  }

  @override
  IHspCommands? get hspCommandTarget => _handyBle.value;
}
