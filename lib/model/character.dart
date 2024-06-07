class Character {
  final String id;
  final String name;
  final String description;
  final String image;
  final String universeId;
  final String creatorId;
  final String createdAt;
  final String updatedAt;

  Character({
    required this.id,
    required this.name,
    required this.description,
    required this.image,
    required this.universeId,
    required this.creatorId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Character.fromJson(Map<String, dynamic> json) {
    return Character(
      id: json['id'].toString(),
      name: json['name'],
      description: json['description'],
      image: json['image'],
      universeId: json['universe_id'].toString(),
      creatorId: json['creator_id'].toString(),
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'image': image,
      'universe_id': universeId,
      'creator_id': creatorId,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}