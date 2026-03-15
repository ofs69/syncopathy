// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'funscript_metadata.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Bookmark _$BookmarkFromJson(Map<String, dynamic> json) => Bookmark(
  name: json['name'] as String?,
  timeMs: (json['timeMs'] as num?)?.toInt(),
);

Map<String, dynamic> _$BookmarkToJson(Bookmark instance) => <String, dynamic>{
  'name': instance.name,
  'timeMs': instance.timeMs,
};

Chapter _$ChapterFromJson(Map<String, dynamic> json) => Chapter(
  name: json['name'] as String?,
  timeMs: (json['timeMs'] as num?)?.toInt(),
);

Map<String, dynamic> _$ChapterToJson(Chapter instance) => <String, dynamic>{
  'name': instance.name,
  'timeMs': instance.timeMs,
};

FunscriptMetadata _$FunscriptMetadataFromJson(Map<String, dynamic> json) =>
    FunscriptMetadata(
      bookmarks:
          (json['bookmarks'] as List<dynamic>?)
              ?.map((e) => Bookmark.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      chapters:
          (json['chapters'] as List<dynamic>?)
              ?.map((e) => Chapter.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      creator: json['creator'] as String?,
      description: json['description'] as String?,
      duration: (json['duration'] as num?)?.toInt(),
      license: json['license'] as String?,
      notes: json['notes'] as String?,
      performers:
          (json['performers'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      scriptUrl: json['scriptUrl'] as String?,
      tags:
          (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList() ??
          const [],
      title: json['title'] as String?,
      type: json['type'] as String?,
      videoUrl: json['videoUrl'] as String?,
    );

Map<String, dynamic> _$FunscriptMetadataToJson(FunscriptMetadata instance) =>
    <String, dynamic>{
      'bookmarks': instance.bookmarks,
      'chapters': instance.chapters,
      'creator': instance.creator,
      'description': instance.description,
      'duration': instance.duration,
      'license': instance.license,
      'notes': instance.notes,
      'performers': instance.performers,
      'scriptUrl': instance.scriptUrl,
      'tags': instance.tags,
      'title': instance.title,
      'type': instance.type,
      'videoUrl': instance.videoUrl,
    };
