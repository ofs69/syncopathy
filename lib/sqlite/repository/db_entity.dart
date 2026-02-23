abstract class DbEntity<TKey> {
  TKey? id;
  DbEntity(this.id);
  void updateFromMap(Map<String, dynamic> map);
  Map<String, dynamic> toMap();
}
