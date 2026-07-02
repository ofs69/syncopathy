import 'dart:async';
import 'dart:ui';
import 'package:signals/signals_flutter.dart';
import 'package:syncopathy/helper/debouncer.dart';
import 'package:syncopathy/helper/entity_binding.dart';
import 'package:syncopathy/media_library/filter/media_filter_logic.dart';
import 'package:syncopathy/model/json/media_library_settings.dart';
import 'package:syncopathy/platform/key_value_store/key_value_store.dart';

class MediaLibrarySettingsModel {
  late MediaLibrarySettings _entity;
  final _debouncer = Debouncer(milliseconds: 500);

  final Signal<SortOption> sortOption = signal(SortOption.title);
  final Signal<bool> isSortAscending = signal(true);
  final Signal<int> videosPerRow = signal(4);
  final Signal<bool> showVideoTitles = signal(false);
  final Signal<bool> showAverageSpeed = signal(true);
  final Signal<bool> showAverageMinMax = signal(true);
  final Signal<bool> showDuration = signal(true);
  final Signal<bool> showPlayCount = signal(true);
  final Signal<bool> separateFavorites = signal(true);
  final SetSignal<VideoFilter> visibilityFilters = setSignal({});

  VoidCallback? _saveEffectDispose;

  /// The single source of truth for which fields persist: each binding copies
  /// one setting out of [_entity] on load and back into it on save, so declaring
  /// a persisted setting means adding one line here with no second copy site to
  /// keep in sync.
  late final List<EntityBinding> _bindings = [
    EntityBinding(
      () => sortOption.value = _entity.sortOption,
      () => _entity.sortOption = sortOption.value,
    ),
    EntityBinding(
      () => isSortAscending.value = _entity.isSortAscending,
      () => _entity.isSortAscending = isSortAscending.value,
    ),
    EntityBinding(
      () => videosPerRow.value = _entity.videosPerRow,
      () => _entity.videosPerRow = videosPerRow.value,
    ),
    EntityBinding(
      () => showVideoTitles.value = _entity.showVideoTitles,
      () => _entity.showVideoTitles = showVideoTitles.value,
    ),
    EntityBinding(
      () => showAverageSpeed.value = _entity.showAverageSpeed,
      () => _entity.showAverageSpeed = showAverageSpeed.value,
    ),
    EntityBinding(
      () => showAverageMinMax.value = _entity.showAverageMinMax,
      () => _entity.showAverageMinMax = showAverageMinMax.value,
    ),
    EntityBinding(
      () => showDuration.value = _entity.showDuration,
      () => _entity.showDuration = showDuration.value,
    ),
    EntityBinding(
      () => showPlayCount.value = _entity.showPlayCount,
      () => _entity.showPlayCount = showPlayCount.value,
    ),
    EntityBinding(
      () => separateFavorites.value = _entity.separateFavorites,
      () => _entity.separateFavorites = separateFavorites.value,
    ),
    EntityBinding(
      () => visibilityFilters.value = _entity.visibilityFilters.toSet(),
      () => _entity.visibilityFilters = visibilityFilters.toList(),
    ),
  ];

  MediaLibrarySettingsModel();

  Future<void> dispose() async {
    _saveEffectDispose?.call();
  }

  Future<void> load() async {
    _saveEffectDispose?.call();
    final settings = await KVStore.get(MediaLibrarySettings.key);
    _entity = settings != null
        ? MediaLibrarySettings.fromJson(settings)
        : MediaLibrarySettings();

    for (final binding in _bindings) {
      binding.loadFromEntity();
    }

    _saveEffectDispose = effect(() async {
      for (final binding in _bindings) {
        binding.saveToEntity();
      }
      await _save();
    });
  }

  Future<void> _save() async {
    _debouncer.run(() => _saveInternal());
  }

  Future<void> _saveInternal() async {
    KVStore.put(MediaLibrarySettings.key, _entity.toJson());
  }
}
