
import 'dart:convert';
import 'package:syncopathy/media_library.dart'; // For SortOption enum

class MediaLibrarySettings {
  final int id = 1; // Singleton ID
  SortOption sortOption;
  bool isSortAscending;
  int videosPerRow;
  bool showVideoTitles;
  bool showAverageSpeed;
  bool showAverageMinMax;
  bool showDuration;
  bool separateFavorites;
  List<String> visibilityFilters;

  MediaLibrarySettings({
    this.sortOption = SortOption.title,
    this.isSortAscending = true,
    this.videosPerRow = 6,
    this.showVideoTitles = true,
    this.showAverageSpeed = true,
    this.showAverageMinMax = true,
    this.showDuration = true,
    this.separateFavorites = true,
    this.visibilityFilters = const [],
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'sortOption': sortOption.toString().split('.').last,
      'isSortAscending': isSortAscending ? 1 : 0,
      'videosPerRow': videosPerRow,
      'showVideoTitles': showVideoTitles ? 1 : 0,
      'showAverageSpeed': showAverageSpeed ? 1 : 0,
      'showAverageMinMax': showAverageMinMax ? 1 : 0,
      'showDuration': showDuration ? 1 : 0,
      'separateFavorites': separateFavorites ? 1 : 0,
      'visibilityFilters': jsonEncode(visibilityFilters),
    };
  }

  factory MediaLibrarySettings.fromMap(Map<String, dynamic> map) {
    return MediaLibrarySettings(
      sortOption: SortOption.values
          .firstWhere((e) => e.toString().split('.').last == map['sortOption']),
      isSortAscending: map['isSortAscending'] == 1,
      videosPerRow: map['videosPerRow'],
      showVideoTitles: map['showVideoTitles'] == 1,
      showAverageSpeed: map['showAverageSpeed'] == 1,
      showAverageMinMax: map['showAverageMinMax'] == 1,
      showDuration: map['showDuration'] == 1,
      separateFavorites: map['separateFavorites'] == 1,
      visibilityFilters: List<String>.from(jsonDecode(map['visibilityFilters'])),
    );
  }
}
