import 'dart:math';

import 'package:flutter/material.dart';
import 'package:signals/signals_flutter.dart';
import 'package:syncopathy/helper/effect_dispose_mixin.dart';
import 'package:syncopathy/model/battery_model.dart';
import 'package:syncopathy/model/funscript.dart';
import 'package:syncopathy/model/settings_model.dart';
import 'package:syncopathy/model/timesource_model.dart';
import 'package:syncopathy/player/player_backend_type.dart';

class ActionBuffer {
  static const int maxBufferSize = 10;
  final int id;
  final List<FunscriptAction> allActions;
  final int startIndex;
  final int endIndex;

  int get tailPointIndex => (id * maxBufferSize) + (endIndex - startIndex);
  int get tailPointTreshold => (id * maxBufferSize);

  ActionBuffer({
    required this.id,
    required this.allActions,
    required this.startIndex,
    required this.endIndex,
  });

  List<FunscriptAction> toActions() => allActions.sublist(startIndex, endIndex);

  static ActionBuffer? fromActions(
    int bufferIndex,
    List<FunscriptAction> actions,
  ) {
    final startIndex = bufferIndex * ActionBuffer.maxBufferSize;
    final endIndex = min(
      startIndex + ActionBuffer.maxBufferSize,
      actions.length - 1,
    );
    if (endIndex - startIndex < 0 || startIndex < 0) {
      return null;
    }
    return ActionBuffer(
      id: bufferIndex,
      allActions: actions,
      startIndex: startIndex,
      endIndex: endIndex,
    );
  }

  static ActionBuffer? fromActionsIndex(
    int actionIndex,
    List<FunscriptAction> actions,
  ) {
    final bufferId = actionIndex ~/ ActionBuffer.maxBufferSize;
    return ActionBuffer.fromActions(bufferId, actions);
  }
}

abstract class PlayerBackend with EffectDispose {
  ReadonlySignal<bool> get connected;
  ReadonlySignal<bool> get isConnecting;

  bool get isBluetooth;

  final PlayerBackendType backendType;

  // HACK: this should be readonly
  final Signal<int?> playbackDelta = signal(null);

  final BatteryModel batteryModel;
  final SettingsModel settingsModel;

  final TimesourceModel timesource;
  final ReadonlySignal<Funscript?> currentFunscript;
  late final ReadonlySignal<List<FunscriptAction>?> currentActions = computed(
    () {
      final actions = currentFunscript.value?.processedActions.value;
      if (actions?.isEmpty ?? true) return null;
      return actions;
    },
  );

  PlayerBackend({
    required this.timesource,
    required this.currentFunscript,
    required this.settingsModel,
    required this.batteryModel,
    required this.backendType,
  });

  Widget settingsWidget(BuildContext context);
  Future<void> tryConnect();
  Future<void> dispose() async {
    effectDispose();
  }
}

// TODO: rewrite the command based logic
abstract class ICommandBackendBase {
  void positionWithDuration(double relPos, int moveOverTimeMs);
}

class CommandPacket {
  final int actualMoveToPos;
  final int moveOverTimeMs;

  final int deviceMaxPos;
  final int deviceMinPos;

  int get logicalMoveToPos => actualMoveToPos.clamp(deviceMinPos, deviceMaxPos);

  CommandPacket(
    this.actualMoveToPos,
    this.moveOverTimeMs,
    this.deviceMaxPos,
    this.deviceMinPos,
  );
}

mixin CommandPacketBackend on ICommandBackendBase {
  void Function() commandEffect(
    TimesourceModel timesource,
    SettingsModel settingsModel,
    ReadonlySignal<List<FunscriptAction>?> currentActions,
  ) {
    return effect(() {
      final currentTime =
          timesource.smoothPosition.value +
          (settingsModel.offsetMs.value / 1000.0);
      final actions = currentActions.value;
      final isPaused = timesource.paused.value;
      final playbackSpeed = timesource.playbackSpeed.value;
      final homeMode = settingsModel.homeDeviceEnabled.value;

      if (homeMode) {
        untracked(() {
          updateCommand(
            CommandPacket(
              0,
              500,
              settingsModel.max.value,
              settingsModel.min.value,
            ),
          );
        });
        return;
      }

      if (actions != null && !isPaused) {
        final currentMs = (currentTime * 1000.0).round();
        final index = Funscript.getActionBefore(currentMs, actions);

        if (index >= 0 && index < actions.length) {
          final action = actions[index];
          final strokeDuration =
              ((action.at - currentMs).toDouble() / playbackSpeed).round();

          untracked(() {
            updateCommand(
              CommandPacket(
                action.pos,
                strokeDuration,
                settingsModel.max.value,
                settingsModel.min.value,
              ),
            );
          });
        }
      }
      return null;
    });
  }

  void updateCommand(CommandPacket cmd);
}
