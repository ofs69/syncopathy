
class UserCategory {
  final int? id;
  final String name;
  final String? description;

  UserCategory({
    this.id,
    required this.name,
    this.description,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
    };
  }

  factory UserCategory.fromMap(Map<String, dynamic> map) {
    return UserCategory(
      id: map['id'],
      name: map['name'],
      description: map['description'],
    );
  }
}
