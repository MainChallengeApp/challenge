import 'package:uuid/uuid.dart';

import 'package:challenge/enums/challenge_status_enum.dart';
import 'acceptance_criteria_model.dart';
import 'media_model.dart';

class ChallengeModel {
  String? id; // set id automatically
  ChallengeStatusEnum? status;
  String title;
  String description;
  String thumbnailPath;
  DateTime? startDate;
  DateTime? endDate;
  List<AcceptanceCriteriaModel> acceptanceCriterias;
  List<MediaModel> media;

  ChallengeModel(
      {this.id,
      required this.status,
      required this.title,
      required this.description,
      required this.thumbnailPath,
      this.startDate,
      this.endDate,
      required this.acceptanceCriterias,
      required this.media}) {
    if (id == null || id!.isEmpty) {
      id = const Uuid().v4();
    }
  }

  static ChallengeModel fromJson(Map json) {
    return ChallengeModel(
        id: json.containsKey('id') ? json['id'] : null,
        status: ChallengeStatusEnum.factory(json['status']),
        title: json['title'],
        description: json['description'],
        thumbnailPath: json['thumbnailPath'],
        startDate: json['startDate'] == null || json['startDate'] == 'null'
            ? null
            : DateTime.parse(json['startDate']),
        endDate: json['endDate'] == null || json['endDate'] == 'null'
            ? null
            : DateTime.parse(json['endDate']),
        acceptanceCriterias:
            AcceptanceCriteriaModel.fromJsonList(json['acceptanceCriteria']),
        media: MediaModel.fromJsonList(json['media']));
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
      'acceptanceCriteria':
          AcceptanceCriteriaModel.toJsonList(acceptanceCriterias),
      'media': MediaModel.toJsonList(media)
    };
  }

  static ChallengeModel copyChallenge(ChallengeModel challenge,
      {bool isTryAgain = false}) {
    ChallengeModel challengeCopy = ChallengeModel(
        status: isTryAgain ? ChallengeStatusEnum.inProgress : challenge.status,
        title: challenge.title,
        startDate: isTryAgain ? null : challenge.startDate,
        endDate: isTryAgain ? null : challenge.endDate,
        description: challenge.description,
        thumbnailPath: challenge.thumbnailPath,
        acceptanceCriterias: AcceptanceCriteriaModel.copyAcceptanceCriteriaList(
            challenge.acceptanceCriterias,
            isTryAgain: isTryAgain),
        media: isTryAgain ? [] : MediaModel.copyMediaList(challenge.media));
    return challengeCopy;
  }

  bool searchInChallenge(String searchText) {
    if (title.toLowerCase().contains(searchText.toLowerCase())) return true;
    if (description.toLowerCase().contains(searchText.toLowerCase())) {
      return true;
    }
    for (var a in acceptanceCriterias) {
      if (a.activity.title.toLowerCase().contains(searchText.toLowerCase())) {
        return true;
      }
    }
    return false;
  }

  @override
  String toString() {
    return 'Challenge{id: $id, status: $status, title: $title, description: $description, thumbnailPath: $thumbnailPath, startDate: $startDate, endDate: $endDate, acceptanceCriteria: $acceptanceCriterias, media: $media}';
  }

  bool checkChallengeStatus() {
    if (AcceptanceCriteriaModel.areAllAcceptanceCriteriasCompleted(
        acceptanceCriterias: acceptanceCriterias)) {
      status = ChallengeStatusEnum.success;
      return true;
    }

    return false;
  }
}
