import 'package:uuid/uuid.dart';

import '../enums/challenge_status.dart';
import 'acceptance_criteria.dart';
import 'media.dart';

class Challenge {
  String? id; // set id automatically
  ChallengeStatus? status;
  String title;
  String description;
  String thumbnailPath;
  DateTime? startDate;
  DateTime? endDate;
  List<AcceptanceCriteria> acceptanceCriteria;
  List<Media> media;

  Challenge(
      {required this.status,
      required this.title,
      required this.description,
      required this.thumbnailPath,
      this.startDate,
      this.endDate,
      required this.acceptanceCriteria,
      required this.media}) {
    id = const Uuid().v4();
  }

  static Challenge fromJson(json) => Challenge(
      status: ChallengeStatus.factory(json['status']),
      title: json['title'],
      description: json['description'],
      thumbnailPath: json['thumbnailPath'],
      startDate:
          json['startDate'] != null ? DateTime.parse(json['startDate']) : null,
      endDate: json['endDate'] != null ? DateTime.parse(json['endDate']) : null,
      acceptanceCriteria:
          AcceptanceCriteria.fromJsonList(json['acceptanceCriteria']),
      media: Media.fromJsonList(json['media']));

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'status': status.toString(),
      'title': title,
      'description': description,
      'thumbnailPath': thumbnailPath,
      'startDate': startDate.toString(),
      'endDate': endDate.toString(),
      'acceptanceCriteria': AcceptanceCriteria.toJsonList(acceptanceCriteria),
      'media': Media.toJsonList(media)
    };
  }

  static Challenge copyChallenge(Challenge challenge) {
    Challenge challengeCopy = Challenge(
        status: challenge.status,
        title: challenge.title,
        description: challenge.description,
        thumbnailPath: challenge.thumbnailPath,
        acceptanceCriteria: AcceptanceCriteria.copyAcceptanceCriteriaList(
            challenge.acceptanceCriteria),
        media: Media.copyMediaList(challenge.media));
    return challengeCopy;
  }

  @override
  String toString() {
    return 'Challenge{id: $id, status: $status, title: $title, description: $description, thumbnailPath: $thumbnailPath, startDate: $startDate, endDate: $endDate, acceptanceCriteria: $acceptanceCriteria, media: $media}';
  }
}
