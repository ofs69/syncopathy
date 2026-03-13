import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
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

  String name;
  String mediaPath;
  double? duration;
  int playCount;

  final funscripts = ToMany<FunscriptFile>();

  @Backlink('entries')
  final lists = ToMany<UserCategory>();

  @Transient()
  Future<String> get mediaHash async {
    // final bytes = utf8.encode(mediaPath);
    // final digest = sha256.convert(bytes);
    // return digest.toString();
    final stat = await File(mediaPath).stat();
    final dataToHash = "${stat.modified.millisecondsSinceEpoch}-${stat.size}";
    final bytes = utf8.encode(dataToHash);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  MediaFile({
    required this.name,
    required this.mediaPath,
    required this.playCount,
    required this.duration,
    this.type,
    this.rating,
  });

  bool get isFavorite => rating == MediaRating.like;
  bool get isDislike => rating == MediaRating.dislike;
}
