import 'dart:convert';

import 'package:objectbox/objectbox.dart';
import 'package:syncopathy/persistence/entities/funscript_file.dart';
import 'package:syncopathy/persistence/entities/media_metadata.dart';
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
  String fileHash;

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
  int playCount;
  bool fileNotFound;
  bool thumbnailGenerationFailed;

  @Property(type: PropertyType.date)
  DateTime? firstIndexedOn;

  final metadata = ToOne<MediaMetadata>();

  final mainFunscript = ToOne<FunscriptFile>();
  final funscripts = ToMany<FunscriptFile>();

  @Backlink('entries')
  final categories = ToMany<UserCategory>();

  MediaFile({
    required this.name,
    required this.mediaPath,
    required this.fileHash,
    required this.playCount,
    required this.fileNotFound,
    this.thumbnailGenerationFailed = false,
    List<String>? aliases,
    this.type,
    this.rating,
  }) : aliases = aliases ?? [];

  bool get isFavorite => rating == MediaRating.like;
  bool get isDislike => rating == MediaRating.dislike;

  bool get isPlayable => unplayable == null;

  /// Why this media cannot be played, or `null` when it is playable. Keeps the
  /// "why can't this play" cascade on the model instead of duplicating it in
  /// widget callbacks.
  UnplayableReason? get unplayable {
    final main = mainFunscript.target;
    if (fileNotFound) return UnplayableReason.mediaMissing;
    if (main == null) return UnplayableReason.noFunscript;
    if (main.fileNotFound) return UnplayableReason.funscriptMissing;
    if (main.isScriptToken) return UnplayableReason.scriptToken;
    return null;
  }

  String? get unplayableReason => unplayable?.description;
}

enum UnplayableReason {
  mediaMissing('Media file not found.'),
  noFunscript('No funscript assigned.'),
  funscriptMissing('Funscript file not found.'),

  /// A deliberate state rather than a broken entry: the script is present but
  /// encrypted, so library cleanup leaves these alone.
  scriptToken('Funscript is a script token.');

  final String description;
  const UnplayableReason(this.description);
}
