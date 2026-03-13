class UserCategoryOld {
  final int? id;
  final String name;
  final String? description;
  final int sortOrder;

  UserCategoryOld({
    this.id,
    required this.name,
    this.description,
    this.sortOrder = 0,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'sort_order': sortOrder,
    };
  }

  factory UserCategoryOld.fromMap(Map<String, dynamic> map) {
    return UserCategoryOld(
      id: map['id'],
      name: map['name'],
      description: map['description'],
      sortOrder: map['sort_order'] ?? 0,
    );
  }
}
