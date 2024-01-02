import 'package:uuid/uuid.dart';

import 'package:challenge/enums/challenge_status.dart';
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
      {this.id,
      required this.status,
      required this.title,
      required this.description,
      required this.thumbnailPath,
      this.startDate,
      this.endDate,
      required this.acceptanceCriteria,
      required this.media}) {
    if (id == null || id!.isEmpty) {
      id = const Uuid().v4();
    }
  }

  static Challenge fromJson(Map json) {
    return Challenge(
        id: json.containsKey('id') ? json['id'] : null,
        status: ChallengeStatus.factory(json['status']),
        title: json['title'],
        description: json['description'],
        thumbnailPath: json['thumbnailPath'],
        startDate: json['startDate'] == null || json['startDate'] == 'null'
            ? null
            : DateTime.parse(json['startDate']),
        endDate: json['endDate'] == null || json['endDate'] == 'null'
            ? null
            : DateTime.parse(json['endDate']),
        acceptanceCriteria:
            AcceptanceCriteria.fromJsonList(json['acceptanceCriteria']),
        media: Media.fromJsonList(json['media']));
  }

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

  static Challenge copyChallenge(Challenge challenge,
      {bool isTryAgain = false}) {
    Challenge challengeCopy = Challenge(
        status: isTryAgain ? ChallengeStatus.inProgress : challenge.status,
        title: challenge.title,
        startDate: isTryAgain ? null : challenge.startDate,
        endDate: isTryAgain ? null : challenge.endDate,
        description: challenge.description,
        thumbnailPath: challenge.thumbnailPath,
        acceptanceCriteria: AcceptanceCriteria.copyAcceptanceCriteriaList(
            challenge.acceptanceCriteria,
            isTryAgain: isTryAgain),
        media: isTryAgain ? [] : Media.copyMediaList(challenge.media));
    return challengeCopy;
  }

  bool searchInChallenge(String searchText) {
    if (title.toLowerCase().contains(searchText.toLowerCase())) return true;
    if (description.toLowerCase().contains(searchText.toLowerCase())) {
      return true;
    }
    for (var a in acceptanceCriteria) {
      if (a.activity.title.toLowerCase().contains(searchText.toLowerCase())) {
        return true;
      }
    }
    return false;
  }

  @override
  String toString() {
    return 'Challenge{id: $id, status: $status, title: $title, description: $description, thumbnailPath: $thumbnailPath, startDate: $startDate, endDate: $endDate, acceptanceCriteria: $acceptanceCriteria, media: $media}';
  }
}
