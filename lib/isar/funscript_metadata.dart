import 'package:isar/isar.dart';

part 'funscript_metadata.g.dart';

int _parseDuration(String s) {
  try {
    final parts = s.split(':');
    if (parts.length != 3) {
      throw FormatException("Invalid time format, expected HH:MM:SS.sss", s);
    }

    final secondsParts = parts[2].split('.');
    final hours = int.parse(parts[0]);
    final minutes = int.parse(parts[1]);
    final seconds = int.parse(secondsParts[0]);
    final milliseconds = secondsParts.length > 1
        ? int.parse(secondsParts[1])
        : 0;

    return Duration(
      hours: hours,
      minutes: minutes,
      seconds: seconds,
      milliseconds: milliseconds,
    ).inMilliseconds;
  } catch (e) {
    throw FormatException("Failed to parse duration string: '$s'", e);
  }
}

/// Represents a bookmark in the Funscript metadata.
@embedded
class Bookmark {
  String? name;
  int? timeMs;

  Bookmark({this.name, this.timeMs});

  factory Bookmark.fromJson(Map<String, dynamic> json) {
    final name = json['name'] as String? ?? '';
    final timeStr = json['time'] as String?;
    if (timeStr == null) {
      throw FormatException("Bookmark missing 'time' key.", json);
    }
    return Bookmark(name: name, timeMs: _parseDuration(timeStr));
  }
}

/// Represents a chapter in the Funscript metadata.
@embedded
class Chapter {
  String? name;
  int? timeMs;

  Chapter({this.name, this.timeMs});

  factory Chapter.fromJson(Map<String, dynamic> json) {
    final name = json['name'] as String? ?? '';
    final timeStr = json['time'] as String?;
    if (timeStr == null) {
      throw FormatException("Chapter missing 'time' key.", json);
    }
    return Chapter(name: name, timeMs: _parseDuration(timeStr));
  }
}

/// Represents the metadata in a Funscript file.
@embedded
class FunscriptMetadata {
  final List<Bookmark> bookmarks;
  final List<Chapter> chapters;
  final String? creator;
  final String? description;
  final int? duration; // in seconds
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

  factory FunscriptMetadata.fromJson(Map<String, dynamic> json) {
    return FunscriptMetadata(
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
      duration: json['duration'] as int?,
      license: json['license'] as String?,
      notes: json['notes'] as String?,
      performers:
          (json['performers'] as List<dynamic>?)?.cast<String>().toList() ??
          const [],
      scriptUrl: json['script_url'] as String?,
      tags:
          (json['tags'] as List<dynamic>?)?.cast<String>().toList() ?? const [],
      title: json['title'] as String?,
      type: json['type'] as String?,
      videoUrl: json['video_url'] as String?,
    );
  }
}
