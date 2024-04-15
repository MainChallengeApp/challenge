import 'dart:math';

import 'package:challenge/enums/challenge_category_enum.dart';
import 'package:challenge/enums/frequency_type_enum.dart.dart';
import 'package:challenge/enums/repetition_status_enum.dart';
import 'package:challenge/models/frequency_model.dart';
import 'package:challenge/models/progress_model.dart';
import 'package:challenge/models/repetition_model.dart';
import 'package:challenge/utils/design_util.dart';
import 'package:uuid/uuid.dart';
import 'package:challenge/enums/challenge_status_enum.dart';
import 'acceptance_criteria_model.dart';
import 'media_model.dart';

class ChallengeModel {
  late String? id; // set id automatically
  ChallengeStatusEnum status;
  String title;
  String description;
  String thumbnailPath;
  DateTime? startDate;
  DateTime? endDate;
  late AcceptanceCriteriaModel acceptanceCriteria;
  late FrequencyModel frequency;
  List<RepetitionModel> repetitions;
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
      required this.frequency,
      required this.repetitions,
      required this.media,
      this.categories = const []}) {
    if (id == null || id!.isEmpty) {
      id = const Uuid().v4();
    }
  }

  ChallengeModel.empty(
      {this.status = ChallengeStatusEnum.backlog,
      this.title = "",
      this.description = "",
      this.thumbnailPath = "",
      this.repetitions = const [],
      this.media = const [],
      this.categories = const []}) {
    id = const Uuid().v4();
    acceptanceCriteria = AcceptanceCriteriaModel.empty();
    frequency = FrequencyModel.empty();
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
        frequency: FrequencyModel.fromJson(json['frequency']),
        repetitions: RepetitionModel.fromJsonList(json['repetitions']),
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
      'frequency': FrequencyModel.toJson(frequency),
      'repetitions': RepetitionModel.toJsonList(repetitions),
      'media': MediaModel.toJsonList(media),
      'categories': ChallengeCategoryEnum.toJsonList(categories)
    };
  }

  static ChallengeModel copyChallenge(
      {required ChallengeModel challenge, bool isTryAgain = false}) {
    ChallengeModel challengeCopy = ChallengeModel(
        status: isTryAgain ? ChallengeStatusEnum.backlog : challenge.status,
        title: challenge.title,
        startDate: isTryAgain ? null : challenge.startDate,
        endDate: isTryAgain ? null : challenge.endDate,
        description: challenge.description,
        thumbnailPath: challenge.thumbnailPath,
        acceptanceCriteria: AcceptanceCriteriaModel.copyAcceptanceCriteria(
            challenge.acceptanceCriteria,
            isTryAgain: isTryAgain),
        frequency: FrequencyModel.copyFrequency(challenge.frequency),
        repetitions: isTryAgain
            ? []
            : RepetitionModel.copyRepetitionList(challenge.repetitions),
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

  ChallengeStatusEnum checkChallengeStatus() {
    if (isCompleted() && endDate != null && endDate!.isBefore(DateTime.now())) {
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
    return repetitions.length > 1;
  }

  RepetitionModel? getLastRepetition() {
    if (repetitions.isEmpty) return null;
    return repetitions.last;
  }

  RepetitionModel? getCurrentRepetition() {
    RepetitionModel? lastRepetition = getLastRepetition();
    if (lastRepetition == null) {
      return null;
    }
    if (!lastRepetition.isCurrentRepetition(this)) {
      return null;
    }
    return lastRepetition;
  }

  RepetitionModel getOrCreateLastRepetition() {
    return getLastRepetition() ??
        RepetitionModel.empty(
            repetitionNumber: getCurrentRepetitionNumber(),
            goalAmount: acceptanceCriteria.amount);
  }

  ProgressModel? getCurrentRepetitionProgress() {
    if (getCurrentRepetition() != null) {
      return getLastRepetition()!.getLastProgress();
    }
    return null;
  }

  double getCurrentRepetitionProgressProgess() {
    var currentRepetition = getCurrentRepetition();
    if (currentRepetition == null) {
      return 0;
    }

    var currentRepetitionProgress = currentRepetition.getLastProgress();
    if (currentRepetitionProgress == null) {
      return 0;
    }

    return currentRepetitionProgress.progress;
  }

  double getCurrentRepetitionProgressPercentageProgess() {
    var currentRepetition = getCurrentRepetition();
    if (currentRepetition == null) {
      return 0;
    }

    var lastRepetitionProgress = currentRepetition.getLastProgress();
    if (lastRepetitionProgress == null) {
      return 0;
    }

    lastRepetitionProgress.setProgress(
        acceptanceCriteria, lastRepetitionProgress.progress);
    return lastRepetitionProgress.percentProgress;
  }

  evaluateRepetition() {
    if (repetitions.isEmpty) {
      return;
    }

    RepetitionModel repetitionInProgress = getLastRepetition()!;
    if (repetitionInProgress.progressList.isEmpty ||
        repetitionInProgress.progressList.last.percentProgress < 1) {
      repetitionInProgress.repetitionStatus = RepetitionStatusEnum.failed;
    } else {
      repetitionInProgress.repetitionStatus = RepetitionStatusEnum.success;
    }
  }

  addRepetition() {
    RepetitionModel? currentRepetition = getLastRepetition();
    if (currentRepetition == null ||
        frequency.amount == null ||
        currentRepetition.repetitionNumber < frequency.amount!) {
      int newRepetitionNumber = currentRepetition == null
          ? 1
          : currentRepetition.repetitionNumber + 1;

      RepetitionModel addingRepetition = RepetitionModel(
          repetitionNumber: newRepetitionNumber,
          goalAmount: acceptanceCriteria.amount,
          progressList: [],
          repetitionStatus: RepetitionStatusEnum.inProgress);
      repetitions.add(addingRepetition);
      return addingRepetition;
    }
  }

  void nextRepetition() {
    if (frequency.type == FrequencyTypeEnum.time) {
      evaluateRepetition();
      addRepetition();
    }
  }

  bool isCompleted() {
    if (frequency.amount != null &&
            getCurrentRepetitionNumber() <
                frequency.getMaxAmoutOfRepetitions()! ||
        frequency.amount != null &&
            repetitions.length < getCurrentRepetitionNumber()) {
      return false;
    }

    List<RepetitionModel> relevantRepetitions =
        RepetitionModel.copyRepetitionList(repetitions);

    if (frequency.amount == null &&
        relevantRepetitions.isNotEmpty &&
        relevantRepetitions.last.progressList.isEmpty) {
      relevantRepetitions.removeLast();
    }

    for (var repetition in relevantRepetitions) {
      if (!repetition.isComplete()) {
        return false;
      }
    }
    return true;
  }

  int getCurrentRepetitionNumber() {
    if (frequency.type == FrequencyTypeEnum.daily) {
      if (startDate == null) {
        return 0;
      } else if (DateTime.now().isBefore(startDate!)) {
        return 0;
      }
      var days = DateTime.now().difference(startDate!).inDays + 1;
      if (frequency.amount == null) {
        return days;
      }
      return min(days, frequency.amount!);
    } else if (frequency.type == FrequencyTypeEnum.time) {
      return repetitions.length;
    } else {
      return 0;
    }
  }

  void start() {
    startDate = DateTime.now();
    setEndDate();
    status = ChallengeStatusEnum.inProgress;
    evaluateRepetition();
    addRepetition();
  }

  end() {
    endDate = DateTime.now();
    if (isCompleted()) {
      status = ChallengeStatusEnum.success;
    } else {
      status = ChallengeStatusEnum.failed;
    }
  }

  bool isInProgress() {
    return status == ChallengeStatusEnum.inProgress;
  }

  bool isSucceeded() {
    return status == ChallengeStatusEnum.success;
  }

  bool isFailed() {
    return status == ChallengeStatusEnum.failed;
  }

  bool isEditable() {
    return status == ChallengeStatusEnum.backlog;
  }

  double getCurrentPercentage() {
    if (getCurrentRepetitionNumber() == 0) {
      return 0;
    }

    if (frequency.amount != null && frequency.amount! < 2) {
      return getCurrentRepetitionProgressPercentageProgess();
    }

    double percentage = 0;

    for (RepetitionModel repetition in repetitions) {
      percentage += min(1, repetition.getLastProgressPercentage());
    }

    if (frequency.amount == null) {
      return percentage / getCurrentRepetitionNumber();
    }

    double currentPercentage =
        percentage / frequency.getMaxAmoutOfRepetitions()!;
    return currentPercentage;
  }
}
