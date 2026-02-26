import 'package:objectbox/objectbox.dart';
import 'package:syncopathy/persistence/entities/funscript.dart';
import 'package:syncopathy/persistence/entities/media_list.dart';

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
class Media {
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
  final lists = ToMany<MediaList>();

  Media({
    required this.name,
    required this.mediaPath,
    required this.playCount,
    required this.duration,
    this.type,
    this.rating,
  });
}
