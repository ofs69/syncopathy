import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:signals/signals_flutter.dart';
import 'package:syncopathy/helper/debouncer.dart';
import 'package:syncopathy/helper/entity_binding.dart';
import 'package:syncopathy/media_library/filter/media_filter_logic.dart';
import 'package:syncopathy/media_library/media_badge.dart';
import 'package:syncopathy/model/json/media_library_settings.dart';
import 'package:syncopathy/platform/key_value_store/key_value_store.dart';

class MediaLibrarySettingsModel {
  late MediaLibrarySettings _entity;
  final _debouncer = Debouncer(milliseconds: 500);

  final Signal<SortOption> sortOption = signal(SortOption.title);
  final Signal<bool> isSortAscending = signal(true);
  final Signal<int> videosPerRow = signal(4);
  final Signal<bool> showVideoTitles = signal(false);
  final ListSignal<String> enabledBadges = listSignal(defaultBadgeIds);
  final Signal<bool> separateFavorites = signal(true);
  final SetSignal<VideoFilter> visibilityFilters = setSignal({});

  VoidCallback? _saveEffectDispose;

  /// Whether any view option differs from its default, so the toolbar button
  /// can show that the grid is not in its default presentation. Sort order is
  /// deliberately excluded: it has its own always-visible control.
  late final ReadonlySignal<bool> isViewCustomized = computed(() {
    final defaults = MediaLibrarySettings();
    return videosPerRow.value != defaults.videosPerRow ||
        showVideoTitles.value != defaults.showVideoTitles ||
        separateFavorites.value != defaults.separateFavorites ||
        visibilityFilters.value.isNotEmpty ||
        !setEquals(enabledBadges.value.toSet(), defaults.enabledBadges.toSet());
  });

  /// Restores every view option to its default. The defaults come from a fresh
  /// entity rather than being repeated here, so there is still one source.
  void resetViewOptions() {
    final defaults = MediaLibrarySettings();
    batch(() {
      videosPerRow.value = defaults.videosPerRow;
      showVideoTitles.value = defaults.showVideoTitles;
      separateFavorites.value = defaults.separateFavorites;
      visibilityFilters.value = defaults.visibilityFilters.toSet();
      enabledBadges.value = List.from(defaults.enabledBadges);
    });
  }

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
      () => enabledBadges.value = List.from(_entity.enabledBadges),
      () => _entity.enabledBadges = enabledBadges.value.toList(),
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
    isViewCustomized.dispose();
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
