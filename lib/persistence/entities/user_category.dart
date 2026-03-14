import 'package:objectbox/objectbox.dart';
import 'package:syncopathy/persistence/entities/media_file.dart';

@Entity()
class UserCategory {
  @Id()
  int id = 0;

  @Unique(onConflict: ConflictStrategy.fail)
  String name;
  String? description;

  int sortOrder;

  final entries = ToMany<MediaFile>();

  UserCategory({required this.name, this.description, this.sortOrder = 0});
}
