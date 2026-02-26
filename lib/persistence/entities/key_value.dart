import 'package:objectbox/objectbox.dart';

@Entity()
class KeyValue {
  @Id()
  int id = 0;

  @Unique()
  @Index()
  String key;

  String value;

  KeyValue({required this.key, required this.value});
}
