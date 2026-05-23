import 'package:flutter/widgets.dart';
import 'package:flutter/services.dart';
import 'package:json_annotation/json_annotation.dart';

part 'shortcut_settings.g.dart';

@JsonSerializable()
class ShortcutBinding {
  final int keyId;
  final bool control;
  final bool shift;
  final bool alt;
  final bool meta;

  ShortcutBinding({
    required this.keyId,
    this.control = false,
    this.shift = false,
    this.alt = false,
    this.meta = false,
  });

  factory ShortcutBinding.fromActivator(SingleActivator activator) {
    return ShortcutBinding(
      keyId: activator.trigger.keyId,
      control: activator.control,
      shift: activator.shift,
      alt: activator.alt,
      meta: activator.meta,
    );
  }

  SingleActivator toActivator() {
    return SingleActivator(
      LogicalKeyboardKey(keyId),
      control: control,
      shift: shift,
      alt: alt,
      meta: meta,
    );
  }

  factory ShortcutBinding.fromJson(Map<String, dynamic> json) =>
      _$ShortcutBindingFromJson(json);

  Map<String, dynamic> toJson() => _$ShortcutBindingToJson(this);

  @override
  String toString() {
    final List<String> modifiers = [];
    if (control) modifiers.add('Ctrl');
    if (alt) modifiers.add('Alt');
    if (shift) modifiers.add('Shift');
    if (meta) modifiers.add('Meta');

    final key = LogicalKeyboardKey(keyId);
    String label = key.keyLabel;
    if (key == LogicalKeyboardKey.space) {
      label = 'Space';
    } else if (label.trim().isEmpty) {
      label = key.debugName ?? 'Unknown';
    }

    modifiers.add(label);
    return modifiers.join(' + ');
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ShortcutBinding &&
          runtimeType == other.runtimeType &&
          keyId == other.keyId &&
          control == other.control &&
          shift == other.shift &&
          alt == other.alt &&
          meta == other.meta;

  @override
  int get hashCode =>
      keyId.hashCode ^
      control.hashCode ^
      shift.hashCode ^
      alt.hashCode ^
      meta.hashCode;
}

class AppShortcut {
  final String id;
  final String name;
  final String description;
  final SingleActivator defaultActivator;

  const AppShortcut({
    required this.id,
    required this.name,
    required this.description,
    required this.defaultActivator,
  });

  ShortcutBinding get defaultBinding =>
      ShortcutBinding.fromActivator(defaultActivator);
}

class ShortcutDefinitions {
  static const togglePause = AppShortcut(
    id: 'togglePause',
    name: 'Toggle Play/Pause',
    description: 'Play or pause the video',
    defaultActivator: SingleActivator(LogicalKeyboardKey.space),
  );

  static const nextTrack = AppShortcut(
    id: 'nextTrack',
    name: 'Next Track',
    description: 'Play next track in playlist',
    defaultActivator: SingleActivator(LogicalKeyboardKey.keyN),
  );

  static const previousTrack = AppShortcut(
    id: 'previousTrack',
    name: 'Previous Track',
    description: 'Play previous track in playlist',
    defaultActivator: SingleActivator(LogicalKeyboardKey.keyP),
  );

  static const toggleHomeMode = AppShortcut(
    id: 'toggleHomeMode',
    name: 'Toggle Home Mode',
    description: 'Toggle Home Mode (Handy)',
    defaultActivator: SingleActivator(LogicalKeyboardKey.keyH),
  );

  static List<AppShortcut> get all => [
    togglePause,
    nextTrack,
    previousTrack,
    toggleHomeMode,
  ];
}
