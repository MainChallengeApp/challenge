class Challenge {
  final int id;
  final String title;
  final String description;
  final String thumbnailPath;
  final DateTime startDate;
  final DateTime endDate;

  Challenge(
      {required this.id,
      required this.title,
      required this.description,
      required this.thumbnailPath,
      required this.startDate,
      required this.endDate});

  static Challenge fromJson(json) => Challenge(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      thumbnailPath: json['thumbnailPath'],
      startDate: DateTime.parse(json['startDate']),
      endDate: DateTime.parse(json['endDate'])      
  );
}
