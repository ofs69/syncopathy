import 'dart:async';
import 'dart:convert';

import 'package:signals/signals_flutter.dart';
import 'package:syncopathy/media_library/filter/media_filter_preset.dart';
import 'package:syncopathy/platform/key_value_store/key_value_store.dart';
import 'package:uuid/uuid.dart';

class MediaFilterPreset {
  final String id;
  final String name;
  final MediaFilterSnapshot snapshot;

  const MediaFilterPreset({
    required this.id,
    required this.name,
    required this.snapshot,
  });

  factory MediaFilterPreset.fromJson(Map<String, dynamic> json) =>
      MediaFilterPreset(
        id: json['id'] as String,
        name: json['name'] as String,
        snapshot: MediaFilterSnapshot.fromJson(
          (json['filter'] as Map).cast<String, dynamic>(),
        ),
      );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'filter': snapshot.toJson(),
  };
}

class MediaFilterPresetsModel {
  static const key = 'MediaFilterPresets';
  static const schemaVersion = 1;

  final ListSignal<MediaFilterPreset> presets = listSignal([]);
  final Signal<String?> activePresetId = signal(null);

  /// Reactive view of the selected preset. Reading this inside a `SignalBuilder`
  /// or `computed` tracks both the list and the selection.
  late final ReadonlySignal<MediaFilterPreset?> activePreset = computed(
    () => presetById(activePresetId.value),
  );

  Future<void> load() async {
    final json = await KVStore.get(key);
    if (json == null || json['schemaVersion'] != schemaVersion) return;
    final rawPresets = json['presets'];
    if (rawPresets is List) {
      final decoded = <MediaFilterPreset>[];
      for (final raw in rawPresets.whereType<Map>()) {
        try {
          decoded.add(MediaFilterPreset.fromJson(raw.cast<String, dynamic>()));
        } catch (_) {
          // Ignore only the malformed preset; keep other saved presets usable.
        }
      }
      presets.value = decoded;
    }
    final activeId = json['activePresetId'];
    if (activeId is String && presets.any((preset) => preset.id == activeId)) {
      activePresetId.value = activeId;
    }
  }

  MediaFilterPreset? presetById(String? id) =>
      presets.where((preset) => preset.id == id).firstOrNull;

  Future<MediaFilterPreset> add(
    String name,
    MediaFilterSnapshot snapshot,
  ) async {
    final preset = MediaFilterPreset(
      id: const Uuid().v4(),
      name: name.trim(),
      snapshot: snapshot,
    );
    presets.add(preset);
    activePresetId.value = preset.id;
    await _save();
    return preset;
  }

  Future<void> update(String id, MediaFilterSnapshot snapshot) async {
    final index = presets.indexWhere((preset) => preset.id == id);
    if (index < 0) return;
    final old = presets[index];
    presets[index] = MediaFilterPreset(
      id: old.id,
      name: old.name,
      snapshot: snapshot,
    );
    await _save();
  }

  Future<void> rename(String id, String name) async {
    final index = presets.indexWhere((preset) => preset.id == id);
    if (index < 0 || name.trim().isEmpty) return;
    final old = presets[index];
    presets[index] = MediaFilterPreset(
      id: old.id,
      name: name.trim(),
      snapshot: old.snapshot,
    );
    await _save();
  }

  Future<void> remove(String id) async {
    presets.removeWhere((preset) => preset.id == id);
    if (activePresetId.value == id) activePresetId.value = null;
    await _save();
  }

  Future<void> activate(String? id) async {
    activePresetId.value = presetById(id)?.id;
    await _save();
  }

  bool matches(MediaFilterSnapshot snapshot, MediaFilterPreset preset) =>
      jsonEncode(snapshot.toJson()) == jsonEncode(preset.snapshot.toJson());

  Future<void> _save() => KVStore.put(key, {
    'schemaVersion': schemaVersion,
    'activePresetId': activePresetId.value,
    'presets': presets.map((preset) => preset.toJson()).toList(),
  });

  void dispose() {
    activePreset.dispose();
    presets.dispose();
    activePresetId.dispose();
  }
}
