import 'package:json_annotation/json_annotation.dart';

part 'funscript_metadata.g.dart';

@JsonSerializable(fieldRename: FieldRename.none)
class Bookmark {
  String? name;
  int? timeMs;

  Bookmark({this.name, this.timeMs});

  // Map<String, dynamic> toJson() => {'name': name, 'timeMs': timeMs};
  // factory Bookmark.fromJson(Map<String, dynamic> json) =>
  //     Bookmark(name: json['name'], timeMs: json['timeMs']);

  Map<String, dynamic> toJson() => _$BookmarkToJson(this);
  factory Bookmark.fromJson(Map<String, dynamic> json) =>
      _$BookmarkFromJson(json);
}

@JsonSerializable(fieldRename: FieldRename.none)
class Chapter {
  String? name;
  int? timeMs;

  Chapter({this.name, this.timeMs});

  Map<String, dynamic> toJson() => _$ChapterToJson(this);
  factory Chapter.fromJson(Map<String, dynamic> json) =>
      _$ChapterFromJson(json);
}

@JsonSerializable(fieldRename: FieldRename.none)
class FunscriptMetadata {
  final List<Bookmark> bookmarks;
  final List<Chapter> chapters;
  final String? creator;
  final String? description;
  final int? duration;
  final String? license;
  final String? notes;
  final List<String> performers;
  final String? scriptUrl;
  final List<String> tags;
  final String? title;
  final String? type;
  final String? videoUrl;

  FunscriptMetadata({
    this.bookmarks = const [],
    this.chapters = const [],
    this.creator,
    this.description,
    this.duration,
    this.license,
    this.notes,
    this.performers = const [],
    this.scriptUrl,
    this.tags = const [],
    this.title,
    this.type,
    this.videoUrl,
  });
  Map<String, dynamic> toJson() => _$FunscriptMetadataToJson(this);
  factory FunscriptMetadata.fromJson(Map<String, dynamic> json) =>
      _$FunscriptMetadataFromJson(json);
}
