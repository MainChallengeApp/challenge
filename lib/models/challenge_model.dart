import 'package:challenge/enums/challenge_category_enum.dart';
import 'package:challenge/enums/frequency_type_enum.dart.dart';
import 'package:challenge/enums/repetition_status_enum.dart';
import 'package:challenge/models/frequency_model.dart';
import 'package:challenge/models/repetition_model.dart';
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
  AcceptanceCriteriaModel acceptanceCriteria;
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
      required this.acceptanceCriteria,
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
        acceptanceCriteria:
            AcceptanceCriteriaModel.fromJson(json['acceptanceCriteria']),
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
      'acceptanceCriteria': AcceptanceCriteriaModel.toJson(acceptanceCriteria),
      'media': MediaModel.toJsonList(media),
      'categories': ChallengeCategoryEnum.toJsonList(categories)
    };
  }

  static ChallengeModel copyChallenge(
      {required ChallengeModel challenge, bool isTryAgain = false}) {
    ChallengeModel challengeCopy = ChallengeModel(
        status: isTryAgain ? ChallengeStatusEnum.inProgress : challenge.status,
        title: challenge.title,
        startDate: isTryAgain ? null : challenge.startDate,
        endDate: isTryAgain ? null : challenge.endDate,
        description: challenge.description,
        thumbnailPath: challenge.thumbnailPath,
        acceptanceCriteria: AcceptanceCriteriaModel.copyAcceptanceCriteria(
            challenge.acceptanceCriteria,
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
    if (acceptanceCriteria.unit
        .toLowerCase()
        .contains(searchText.toLowerCase())) {
      return true;
    }
    return false;
  }

  bool isInCategories(List<ChallengeCategoryEnum> categories) {
    return categories.isEmpty
        ? true
        : this.categories.toSet().intersection(categories.toSet()).isNotEmpty;
  }

  bool isChallengeCompleted() {
    return acceptanceCriteria.isCompleted();
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

  setEndDate() {
    FrequencyModel frequency = acceptanceCriteria.frequency;
    if (startDate != null &&
        frequency.type == FrequencyTypeEnum.daily &&
        frequency.amount != null) {
      endDate = startDate!.add(Duration(days: frequency.amount!));
    } else if (frequency.type == FrequencyTypeEnum.daily &&
        frequency.amount == null) {
      endDate = null;
    }
  }

  setFrequencyAmount() {
    FrequencyModel frequency = acceptanceCriteria.frequency;
    if (startDate != null &&
        endDate != null &&
        frequency.type == FrequencyTypeEnum.daily) {
      int amount = DesignUtil.dateWithoutTime(endDate!)
          .difference(DesignUtil.dateWithoutTime(startDate!))
          .inDays;
      if (amount >= 0) {
        frequency.amount = amount;
      }
    } else if (frequency.type == FrequencyTypeEnum.daily && endDate == null) {
      frequency.amount = null;
    }
  }

  hasThumbnail() {
    return thumbnailPath != '';
  }

  hasRepetitions() {
    return acceptanceCriteria.repetitions.length > 1;
  }

  RepetitionModel? getCurrentRepetition() {
    if (acceptanceCriteria.repetitions.isEmpty) return null;

    acceptanceCriteria.repetitions
        .sort((a, b) => b.repetitionNumber - a.repetitionNumber);
    return acceptanceCriteria.repetitions.last;
  }

  evaluateRepetition() {
    if (acceptanceCriteria.repetitions.isEmpty) {
      return;
    }

    RepetitionModel repetitionInProgress = acceptanceCriteria.repetitions
        .firstWhere((repetition) =>
            repetition.repetitionStatus == RepetitionStatusEnum.inProgress);
    if (repetitionInProgress.progressList.isEmpty ||
        repetitionInProgress.progressList.last.percentProgress < 1) {
      repetitionInProgress.repetitionStatus = RepetitionStatusEnum.failed;
    } else {
      repetitionInProgress.repetitionStatus = RepetitionStatusEnum.success;
    }
  }

  addRepetition() {
    RepetitionModel? currentRepetition = getCurrentRepetition();
    int? frequencyAmount = acceptanceCriteria.frequency.amount;
    if (currentRepetition == null ||
        frequencyAmount == null ||
        currentRepetition.repetitionNumber < frequencyAmount) {
      int newRepetitionNumber = currentRepetition == null
          ? 1
          : currentRepetition.repetitionNumber + 1;
      acceptanceCriteria.repetitions.add(RepetitionModel(
          repetitionNumber: newRepetitionNumber,
          goalAmount: acceptanceCriteria.amount,
          progressList: [],
          repetitionStatus: RepetitionStatusEnum.inProgress));
    }
  }
}
