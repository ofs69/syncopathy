import 'package:flutter/foundation.dart';
import 'dart:async';
import 'package:isar/isar.dart';
import 'package:syncopathy/logging.dart';
import 'package:syncopathy/main.dart';
import 'package:syncopathy/helper/throttler.dart';
import 'package:syncopathy/media_library.dart';

part 'media_library_settings.g.dart';

@collection
class MediaLibrarySettingsEntity {
  // Use a fixed ID for the single settings object
  Id id = 1;

  @enumerated
  SortOption sortOption = SortOption.title;
  bool isSortAscending = true;
  int videosPerRow = 6;
  bool showVideoTitles = true;
  List<String> visibilityFilters = [];
}

class MediaLibrarySettings {
  late MediaLibrarySettingsEntity _entity;
  final _throttler = Throttler(milliseconds: 500);

  late ValueNotifier<SortOption> sortOption;
  late ValueNotifier<bool> isSortAscending;
  late ValueNotifier<int> videosPerRow;
  late ValueNotifier<bool> showVideoTitles;
  late ValueNotifier<Set<VideoFilter>> visibilityFilters;

  StreamController<void> get saveNotifier => _saveNotifier;
  final _saveNotifier = StreamController<void>.broadcast();

  MediaLibrarySettings() {
    sortOption = ValueNotifier<SortOption>(SortOption.title);
    isSortAscending = ValueNotifier<bool>(true);
    videosPerRow = ValueNotifier<int>(6);
    showVideoTitles = ValueNotifier<bool>(true);
    visibilityFilters = ValueNotifier<Set<VideoFilter>>({});
  }

  Future<void> load() async {
    _entity =
        await isar.mediaLibrarySettingsEntitys.get(1) ??
        MediaLibrarySettingsEntity();
    sortOption.value = _entity.sortOption;
    isSortAscending.value = _entity.isSortAscending;
    videosPerRow.value = _entity.videosPerRow;
    showVideoTitles.value = _entity.showVideoTitles;
    visibilityFilters.value = _entity.visibilityFilters
        .map((id) => VideoFilter.values.firstWhere((f) => f.id == id))
        .toSet();
    await _save();
  }

  Future<void> _save() async {
    _throttler.run(() => _saveInternal());
  }

  Future<void> _saveInternal() async {
    await isar.writeTxn(() async {
      await isar.mediaLibrarySettingsEntitys.put(_entity);
    });
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

  Future<void> setVisibilityFilters(Set<VideoFilter> value) async {
    _entity.visibilityFilters = value.map((f) => f.id).toList();
    await _save();
    visibilityFilters.value = value;
  }
}
