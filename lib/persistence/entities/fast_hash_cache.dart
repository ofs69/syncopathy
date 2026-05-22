import 'package:objectbox/objectbox.dart';

@Entity()
class FastHashCache {
  @Id()
  int id = 0;

  @Index(type: IndexType.value)
  String path;

  int mtime;
  int size;
  String hash;

  FastHashCache({
    required this.path,
    required this.mtime,
    required this.size,
    required this.hash,
  });
}
