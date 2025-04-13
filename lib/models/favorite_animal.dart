class FavoriteAnimal {
  final String name;
  final String imagePath;
  final String type;

  FavoriteAnimal({
    required this.name,
    required this.imagePath,
    required this.type,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'imagePath': imagePath,
      'type': type,
    };
  }

  factory FavoriteAnimal.fromMap(Map<String, dynamic> map) {
    return FavoriteAnimal(
      name: map['name'],
      imagePath: map['imagePath'],
      type: map['type'],
    );
  }
}
