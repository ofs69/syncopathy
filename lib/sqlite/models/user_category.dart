class UserCategory {
  final int? id;
  final String name;
  final String? description;
  final int sortOrder;

  UserCategory({
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

  factory UserCategory.fromMap(Map<String, dynamic> map) {
    return UserCategory(
      id: map['id'],
      name: map['name'],
      description: map['description'],
      sortOrder: map['sort_order'] ?? 0,
    );
  }
}
