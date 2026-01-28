import 'dart:async';

import 'package:flutter/material.dart';
import 'package:syncopathy/helper/throttler.dart';
import 'package:syncopathy/logging.dart';
import 'package:syncopathy/media_library.dart';
import 'package:syncopathy/sqlite/database_helper.dart';
import 'package:syncopathy/sqlite/models/media_library_settings.dart';

class MediaLibrarySettingsModel {
  late MediaLibrarySettings _entity;
  final _throttler = Throttler(milliseconds: 500);

  late ValueNotifier<SortOption> sortOption;
  late ValueNotifier<bool> isSortAscending;
  late ValueNotifier<int> videosPerRow;
  late ValueNotifier<bool> showVideoTitles;
  late ValueNotifier<bool> showAverageSpeed;
  late ValueNotifier<bool> showAverageMinMax;
  late ValueNotifier<bool> showDuration;
  late ValueNotifier<bool> showPlayCount;
  late ValueNotifier<bool> separateFavorites;
  late ValueNotifier<Set<VideoFilter>> visibilityFilters;

  StreamController<void> get saveNotifier => _saveNotifier;
  final _saveNotifier = StreamController<void>.broadcast();

  MediaLibrarySettingsModel() {
    sortOption = ValueNotifier<SortOption>(SortOption.title);
    isSortAscending = ValueNotifier<bool>(true);
    videosPerRow = ValueNotifier<int>(6);
    showVideoTitles = ValueNotifier<bool>(true);
    showAverageSpeed = ValueNotifier<bool>(true);
    showAverageMinMax = ValueNotifier<bool>(true);
    showDuration = ValueNotifier<bool>(true);
    showPlayCount = ValueNotifier<bool>(true);
    separateFavorites = ValueNotifier<bool>(true);
    visibilityFilters = ValueNotifier<Set<VideoFilter>>({});
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
    await _save();
  }

  Future<void> _save() async {
    _throttler.run(() => _saveInternal());
  }

  Future<void> _saveInternal() async {
    await DatabaseHelper().updateMediaLibrarySettings(_entity);
    _saveNotifier.add(null);
    Logger.debug("Media library settings save");
  }

  Future<void> setSortOption(SortOption value) async {
    _entity.sortOption = value;
    await _save();
    sortOption.value = value;
  }

  Future<void> setIsSortAscending(bool value) async {
    _entity.isSortAscending = value;
    await _save();
    isSortAscending.value = value;
  }

  Future<void> setVideosPerRow(int value) async {
    _entity.videosPerRow = value;
    await _save();
    videosPerRow.value = value;
  }

  Future<void> setShowVideoTitles(bool value) async {
    _entity.showVideoTitles = value;
    await _save();
    showVideoTitles.value = value;
  }

  Future<void> setShowAverageSpeed(bool value) async {
    _entity.showAverageSpeed = value;
    await _save();
    showAverageSpeed.value = value;
  }

  Future<void> setShowAverageMinMax(bool value) async {
    _entity.showAverageMinMax = value;
    await _save();
    showAverageMinMax.value = value;
  }

  Future<void> setShowDuration(bool value) async {
    _entity.showDuration = value;
    await _save();
    showDuration.value = value;
  }

  Future<void> setShowPlayCount(bool value) async {
    _entity.showPlayCount = value;
    await _save();
    showPlayCount.value = value;
  }

  Future<void> setSeparateFavorites(bool value) async {
    _entity.separateFavorites = value;
    await _save();
    separateFavorites.value = value;
  }

  Future<void> setVisibilityFilters(Set<VideoFilter> value) async {
    _entity.visibilityFilters = value.map((f) => f.id).toList();
    await _save();
    visibilityFilters.value = value;
  }
}
