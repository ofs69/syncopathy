import 'dart:math';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:signals/signals_flutter.dart';
import 'package:syncopathy/generated/constants.pb.dart';
import 'package:syncopathy/helper/effect_dispose_mixin.dart';
import 'package:syncopathy/model/battery_model.dart';
import 'package:syncopathy/model/funscript.dart';
import 'package:syncopathy/model/settings_model.dart';
import 'package:syncopathy/model/timesource_model.dart';

class ActionBuffer {
  static const int maxBufferSize = 10;
  final int id;
  final Iterable<FunscriptAction> bufferActions;
  final List<FunscriptAction> allActions;
  int get tailPointIndex => (id * maxBufferSize) + bufferActions.length;
  int get tailPointTreshold => (id * maxBufferSize);

  ActionBuffer(this.id, this.bufferActions, this.allActions);

  List<Point> toPoints() =>
      bufferActions.map((a) => Point(t: a.at, x: a.pos.clamp(0, 100))).toList();

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
      bufferIndex,
      actions.skip(startIndex).take(ActionBuffer.maxBufferSize),
      actions,
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

  // HACK: this should be readonly
  final Signal<int?> playbackDelta = signal(null);

  final BatteryModel batteryModel;
  final SettingsModel settingsModel;

  final TimesourceModel timesource;
  final ReadonlySignal<Funscript?> currentFunscript;
  late final ReadonlySignal<List<FunscriptAction>?> currentActions = computed(
    () => currentFunscript.value?.actions.value,
  );

  PlayerBackend({
    required this.timesource,
    required this.currentFunscript,
    required this.settingsModel,
    required this.batteryModel,
  });

  Widget settingsWidget(BuildContext context);
  Future<void> tryConnect();
  Future<void> dispose() async {
    effectDispose();
  }

  static int getActionIndex(int timeMs, List<FunscriptAction> actions) {
    final index = lowerBound(actions, FunscriptAction(at: timeMs, pos: 0));
    return index == actions.length ? index - 1 : index;
  }
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

mixin CommandPacketBackend {
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

      if (actions != null && !isPaused) {
        final currentMs = (currentTime * 1000.0).round();
        final index = lowerBound(
          actions,
          FunscriptAction(at: currentMs, pos: 0),
        );
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
