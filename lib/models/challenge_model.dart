import 'package:challenge/enums/challenge_category_enum.dart';
import 'package:challenge/enums/frequency_type_enum.dart.dart';
import 'package:challenge/models/frequency_model.dart';
import 'package:challenge/utils/design_util.dart';
import 'package:uuid/uuid.dart';

import 'package:challenge/enums/challenge_status_enum.dart';
import 'acceptance_criteria_model.dart';
import 'media_model.dart';

class ChallengeModel {
  String? id; // set id automatically
  ChallengeStatusEnum status;
  String title;
  String description;
  String thumbnailPath;
  DateTime? startDate;
  DateTime? endDate;
  List<AcceptanceCriteriaModel> acceptanceCriterias;
  List<MediaModel> media;
  List<ChallengeCategoryEnum> categories;

  ChallengeModel(
      {this.id,
      required this.status,
      required this.title,
      required this.description,
      required this.thumbnailPath,
      this.startDate,
      this.endDate,
      required this.acceptanceCriterias,
      required this.media,
      this.categories = const []}) {
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
        media: MediaModel.fromJsonList(json['media']),
        categories: ChallengeCategoryEnum.fromJsonList(json['categories']));
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
      'media': MediaModel.toJsonList(media),
      'categories': ChallengeCategoryEnum.toJsonList(categories)
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
        acceptanceCriterias: AcceptanceCriteriaModel.copyAcceptanceCriterias(
            challenge.acceptanceCriterias,
            isTryAgain: isTryAgain),
        media: isTryAgain ? [] : MediaModel.copyMediaList(challenge.media),
        categories:
            ChallengeCategoryEnum.copyCategoryList(challenge.categories));
    return challengeCopy;
  }

  bool searchInChallenge(String searchText) {
    if (title.toLowerCase().contains(searchText.toLowerCase())) return true;
    if (description.toLowerCase().contains(searchText.toLowerCase())) {
      return true;
    }
    for (var a in acceptanceCriterias) {
      if (a.title.toLowerCase().contains(searchText.toLowerCase())) {
        return true;
      }
    }
    return false;
  }

  bool isInCategories(List<ChallengeCategoryEnum> categories) {
    return categories.isEmpty
        ? true
        : this.categories.toSet().intersection(categories.toSet()).isNotEmpty;
  }

  @override
  String toString() {
    return 'Challenge{id: $id, status: $status, title: $title, description: $description, thumbnailPath: $thumbnailPath, startDate: $startDate, endDate: $endDate, acceptanceCriteria: $acceptanceCriterias, media: $media, categories: $categories}';
  }

  bool isChallengeCompleted() {
    if (endDate == null) {
      return false;
    }

    for (var ac in acceptanceCriterias) {
      if (!ac.isCompleted()) {
        return false;
      }
    }
    return true;
  }

  ChallengeStatusEnum checkChallengeStatus() {
    if (isChallengeCompleted()) {
      status = ChallengeStatusEnum.success;
    } else if (endDate != null && endDate!.isBefore(DateTime.now())) {
      status = ChallengeStatusEnum.failed;
    } else if (startDate == null || startDate!.isAfter(DateTime.now())) {
      status = ChallengeStatusEnum.backlog;
    } else {
      status = ChallengeStatusEnum.inProgress;
    }
    return status;
  }

  String getThumbnailPath() {
    if (thumbnailPath.isNotEmpty) {
      return thumbnailPath;
    } else if (media.isNotEmpty) {
      thumbnailPath = media.last.source;
    }
    return thumbnailPath;
  }

  bool isThumbnailFromAssetsImage() {
    return thumbnailPath.startsWith('assets/images/');
  }

  setChallengeEndDate() {
    FrequencyModel frequency = acceptanceCriterias.first.frequency;
    if (startDate != null &&
        frequency.type == FrequencyTypeEnum.daily &&
        frequency.amount != null) {
      endDate = startDate!.add(Duration(days: frequency.amount!));
    } else if (frequency.type == FrequencyTypeEnum.daily &&
        frequency.amount == null) {
      endDate = null;
    }
  }

  setChallengeFrequencyAmount() {
    FrequencyModel frequency = acceptanceCriterias.first.frequency;
    if (startDate != null &&
        endDate != null &&
        frequency.type == FrequencyTypeEnum.daily) {
      int amount = DesignUtil.dateWithoutTime(endDate!)
              .difference(DesignUtil.dateWithoutTime(startDate!))
              .inDays +
          1;
      if (amount > 0) {
        frequency.amount = amount;
      }
    } else if (frequency.type == FrequencyTypeEnum.daily && endDate == null) {
      frequency.amount = null;
    }
  }
}
