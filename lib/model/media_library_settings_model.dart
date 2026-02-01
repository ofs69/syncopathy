import 'dart:async';
import 'package:signals/signals_flutter.dart';
import 'package:syncopathy/helper/debouncer.dart';
import 'package:syncopathy/logging.dart';
import 'package:syncopathy/media_library.dart';
import 'package:syncopathy/sqlite/database_helper.dart';
import 'package:syncopathy/sqlite/models/media_library_settings.dart';

class MediaLibrarySettingsModel {
  late final MediaLibrarySettings _entity;
  final _debouncer = Debouncer(milliseconds: 500);

  final Signal<SortOption> sortOption = signal(SortOption.title);
  final Signal<bool> isSortAscending = signal(true);
  final Signal<int> videosPerRow = signal(6);
  final Signal<bool> showVideoTitles = signal(true);
  final Signal<bool> showAverageSpeed = signal(true);
  final Signal<bool> showAverageMinMax = signal(true);
  final Signal<bool> showDuration = signal(true);
  final Signal<bool> showPlayCount = signal(true);
  final Signal<bool> separateFavorites = signal(true);
  final Signal<Set<VideoFilter>> visibilityFilters = setSignal({});

  late final Function _saveEffectDispose;

  MediaLibrarySettingsModel();

  Future<void> dispose() async {
    _saveEffectDispose();
  }

  Future<void> load() async {
    _entity = await DatabaseHelper().getMediaLibrarySettings();
    sortOption.value = _entity.sortOption;
    isSortAscending.value = _entity.isSortAscending;
    videosPerRow.value = _entity.videosPerRow;
    showVideoTitles.value = _entity.showVideoTitles;
    showAverageSpeed.value = _entity.showAverageSpeed;
    showAverageMinMax.value = _entity.showAverageMinMax;
    showDuration.value = _entity.showDuration;
    showPlayCount.value = _entity.showPlayCount;
    separateFavorites.value = _entity.separateFavorites;
    visibilityFilters.value = _entity.visibilityFilters
        .map((id) => VideoFilter.values.firstWhere((f) => f.id == id))
        .toSet();

    _saveEffectDispose = effect(() async {
      _entity.sortOption = sortOption.value;
      _entity.isSortAscending = isSortAscending.value;
      _entity.videosPerRow = videosPerRow.value;
      _entity.showVideoTitles = showVideoTitles.value;
      _entity.showAverageSpeed = showAverageSpeed.value;
      _entity.showAverageMinMax = showAverageMinMax.value;
      _entity.showDuration = showDuration.value;
      _entity.showPlayCount = showPlayCount.value;
      _entity.separateFavorites = separateFavorites.value;
      _entity.visibilityFilters = visibilityFilters.map((f) => f.id).toList();
      await _save();
    });
  }

  Future<void> _save() async {
    _debouncer.run(() => _saveInternal());
  }

  Future<void> _saveInternal() async {
    await DatabaseHelper().updateMediaLibrarySettings(_entity);
    Logger.debug("Media library settings save");
  }
}
