import 'dart:convert';

import 'package:objectbox/objectbox.dart';
import 'package:syncopathy/persistence/entities/funscript_file.dart';
import 'package:syncopathy/persistence/entities/user_category.dart';

enum MediaType {
  unknown(0),
  video(1),
  audio(2);

  final int id;
  const MediaType(this.id);

  static MediaType fromId(int? id) {
    return MediaType.values.firstWhere(
      (element) => element.id == id,
      orElse: () => MediaType.unknown,
    );
  }
}

enum MediaRating {
  noRating(0),
  like(1),
  dislike(2);

  final int id;
  const MediaRating(this.id);

  static MediaRating fromId(int? id) {
    return MediaRating.values.firstWhere(
      (element) => element.id == id,
      orElse: () => MediaRating.noRating,
    );
  }
}

@Entity()
class MediaFile {
  @Id()
  int id = 0;

  // Type
  @Transient()
  MediaType? type;
  int? get dbType => type?.id;
  set dbType(int? value) => type = MediaType.fromId(value);

  // Rating
  @Transient()
  MediaRating? rating;
  int? get dbRating => rating?.id;
  set dbRating(int? value) => rating = MediaRating.fromId(value);

  @Index(type: IndexType.value)
  @Unique(onConflict: ConflictStrategy.fail)
  String? fileHash;

  // main name
  String name;
  // name aliases for search purposes stored as a json list
  @Transient()
  List<String> aliases;
  String get dbAliases => jsonEncode(aliases);
  set dbAliases(String jsonList) {
    aliases.clear();
    try {
      final decoded = jsonDecode(jsonList);
      if (decoded case List items) {
        aliases = items.cast<String>();
      }
    } catch (_) {}
  }

  String mediaPath;
  double? duration;
  int playCount;
  bool fileNotFound;

  final funscripts = ToMany<FunscriptFile>();

  @Backlink('entries')
  final categories = ToMany<UserCategory>();

  MediaFile({
    required this.name,
    required this.mediaPath,
    required this.fileHash,
    required this.playCount,
    required this.duration,
    required this.fileNotFound,
    List<String>? aliases,
    this.type,
    this.rating,
  }) : aliases = aliases ?? [];

  bool get isFavorite => rating == MediaRating.like;
  bool get isDislike => rating == MediaRating.dislike;
}
