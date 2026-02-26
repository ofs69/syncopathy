import 'package:objectbox/objectbox.dart';
import 'package:syncopathy/persistence/entities/media.dart';

@Entity()
class MediaList {
  @Id()
  int id = 0;

  @Unique()
  String name;

  String? description;

  int sortOrder;

  final entries = ToMany<Media>();

  MediaList({required this.name, this.description, this.sortOrder = 0});
}
