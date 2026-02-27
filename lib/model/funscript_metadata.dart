import 'dart:convert';

// These embedded classes are simple data holders, so we can define them here.
// In a larger application, they might get their own files.

class Bookmark {
  String? name;
  int? timeMs;

  Bookmark({this.name, this.timeMs});

  Map<String, dynamic> toJson() => {'name': name, 'timeMs': timeMs};

  factory Bookmark.fromJson(Map<String, dynamic> json) =>
      Bookmark(name: json['name'], timeMs: json['timeMs']);
}

class Chapter {
  String? name;
  int? timeMs;

  Chapter({this.name, this.timeMs});

  Map<String, dynamic> toJson() => {'name': name, 'timeMs': timeMs};

  factory Chapter.fromJson(Map<String, dynamic> json) =>
      Chapter(name: json['name'], timeMs: json['timeMs']);
}

class FunscriptMetadata {
  int? id;
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
    this.id,
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

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'creator': creator,
      'description': description,
      'duration': duration,
      'license': license,
      'notes': notes,
      'scriptUrl': scriptUrl,
      'title': title,
      'type': type,
      'videoUrl': videoUrl,
      'bookmarks': jsonEncode(bookmarks.map((b) => b.toJson()).toList()),
      'chapters': jsonEncode(chapters.map((c) => c.toJson()).toList()),
      'performers': jsonEncode(performers),
      'tags': jsonEncode(tags),
    };
  }

  factory FunscriptMetadata.fromMap(Map<String, dynamic> map) {
    return FunscriptMetadata(
      id: map['id'],
      creator: map['creator'],
      description: map['description'],
      duration: map['duration'],
      license: map['license'],
      notes: map['notes'],
      scriptUrl: map['scriptUrl'],
      title: map['title'],
      type: map['type'],
      videoUrl: map['videoUrl'],
      bookmarks: (jsonDecode(map['bookmarks']) as List)
          .map((i) => Bookmark.fromJson(i))
          .toList(),
      chapters: (jsonDecode(map['chapters']) as List)
          .map((i) => Chapter.fromJson(i))
          .toList(),
      performers: List<String>.from(jsonDecode(map['performers'])),
      tags: List<String>.from(jsonDecode(map['tags'])),
    );
  }

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
