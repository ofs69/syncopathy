import 'package:freezed_annotation/freezed_annotation.dart';

part 'filter.freezed.dart';

@freezed
abstract class MediaFilter with _$MediaFilter {
  static const int allCategoriesCategoryId = -1;
  static const int uncategorizedCategoryId = -2;

  const MediaFilter._();

  const factory MediaFilter({
    int? filterCategory,
    Set<String>? funscriptAuthors,
    Set<String>? funscriptTags,
    Set<String>? funscriptPerformers,
  }) = _MediaFilter;

  bool get isCustomized =>
      filterCategory != null ||
      funscriptAuthors != null ||
      funscriptTags != null ||
      funscriptPerformers != null;
}
