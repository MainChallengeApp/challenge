class Challenge {
  String title;
  String description;

  Challenge({required this.title, required this.description});

  static Challenge fromJson(json) =>
      Challenge(title: json['title'], description: json['description']);
}
  