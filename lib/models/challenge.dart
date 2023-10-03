class Challenge {
  final int id;
  final String title;
  final String description;
  final String thumbnailPath;

  Challenge({required this.id, required this.title, required this.description, required this.thumbnailPath});

  static Challenge fromJson(json) =>
    Challenge(id: json['id'], title: json['title'], description: json['description'], thumbnailPath: json['thumbnailPath']);
}