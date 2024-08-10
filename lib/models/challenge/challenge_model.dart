import 'dart:math';

import 'package:challenge/enums/challenge_category_enum.dart';
import 'package:challenge/enums/challenge_status_enum.dart';
import 'package:challenge/enums/frequency_type_enum.dart.dart';
import 'package:challenge/enums/repetition_status_enum.dart';
import 'package:challenge/models/challenge/frequency_model.dart';
import 'package:challenge/models/challenge/repetition_model.dart';
import 'package:uuid/uuid.dart';

import 'acceptance_criteria_model.dart';
import 'media_model.dart';

class ChallengeModel {
  late String? id;
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
      this.title = '',
      this.description = '',
      this.thumbnailPath = '',
      this.repetitions = const [],
      this.media = const [],
      this.categories = const []}) {
    id = const Uuid().v4();
    acceptanceCriteria = AcceptanceCriteriaModel.empty();
    frequency = FrequencyModel.empty();
    repetitions = [];
    media = [];
  }

  static ChallengeModel fromJson(Map json) {
    try {
      ChallengeModel challenge = ChallengeModel(
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
      return challenge;
    } on Exception {
      rethrow;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'status': status.status,
      'title': title,
      'description': description,
      'thumbnailPath': thumbnailPath,
      'startDate': startDate.toString(),
      'endDate': endDate.toString(),
      'acceptanceCriteria': acceptanceCriteria.toJson(),
      'frequency': frequency.toJson(),
      'repetitions':
          repetitions.map((repetition) => repetition.toJson()).toList(),
      'media': media.map((media) => media.toJson()).toList(),
      'categories': categories.map((category) => category.category).toList()
    };
  }

  ChallengeModel copyChallenge({bool isTryAgain = false, bool withId = false}) {
    ChallengeModel challengeCopy = ChallengeModel(
        id: withId ? id : null,
        status: isTryAgain ? ChallengeStatusEnum.backlog : status,
        title: title,
        startDate: isTryAgain ? null : startDate,
        endDate: isTryAgain ? null : endDate,
        description: description,
        thumbnailPath: thumbnailPath,
        acceptanceCriteria: AcceptanceCriteriaModel.copyAcceptanceCriteria(
            acceptanceCriteria,
            isTryAgain: isTryAgain),
        frequency: frequency.copy(),
        repetitions:
            isTryAgain ? [] : RepetitionModel.copyRepetitionList(repetitions),
        media: isTryAgain ? [] : MediaModel.copyMediaList(media),
        categories: ChallengeCategoryEnum.copyCategoryList(categories));
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
    } else if (startDate == null || DateTime.now().isBefore(startDate!)) {
      status = ChallengeStatusEnum.backlog;
    } else {
      status = ChallengeStatusEnum.inProgress;
    }
    return status;
  }

  String getThumbnailPath() {
    if (thumbnailPath.isEmpty && media.isNotEmpty) {
      return media.last.source;
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
    if (startDate == null && endDate == null) return;

    if (startDate != null &&
        endDate != null &&
        frequency.type == FrequencyTypeEnum.daily) {
      int amount = endDate!.difference(startDate!).inDays +
          (endDate!.difference(startDate!).inSeconds -
                      endDate!.difference(startDate!).inDays * 24 * 60 * 60 >
                  0
              ? 1
              : 0); // if there is not a whole day difference, add one day
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

  RepetitionModel? getLastRepetition() {
    if (getAllRepetitions().isEmpty) {
      return null;
    }
    return getAllRepetitions().last;
  }

  RepetitionModel? getCurrentRepetition() {
    if (getCurrentRepetitionNumber() == 0) {
      return null;
    }
    RepetitionModel currentRepetition = getAllRepetitions().firstWhere(
        (repetition) =>
            repetition.repetitionNumber == getCurrentRepetitionNumber());
    return currentRepetition;
  }

  List<RepetitionModel> getAllRepetitions() {
    repetitions
        .sort((a, b) => a.repetitionNumber.compareTo(b.repetitionNumber));

    List<RepetitionModel> allRepetitions = [...repetitions];

    if (repetitions.length == getCurrentRepetitionNumber()) {
      return allRepetitions;
    }

    for (int repetitionNumber = repetitions.length + 1;
        repetitionNumber <= getCurrentRepetitionNumber();
        repetitionNumber++) {
      allRepetitions.insert(
          repetitionNumber - 1,
          RepetitionModel.empty(
              startDate: frequency.type == FrequencyTypeEnum.daily
                  ? startDate?.add(Duration(days: repetitionNumber - 1))
                  : frequency.type == FrequencyTypeEnum.time &&
                          startDate != null &&
                          repetitionNumber == 1
                      ? startDate
                      : null,
              endDate: frequency.type == FrequencyTypeEnum.daily &&
                      repetitionNumber <= getCurrentRepetitionNumber() &&
                      startDate != null
                  ? startDate!
                              .add(Duration(days: repetitionNumber))
                              .difference(endDate!)
                              .inMilliseconds <=
                          0
                      ? startDate!.add(Duration(days: repetitionNumber))
                      : endDate
                  : null,
              repetitionNumber: repetitionNumber,
              goalAmount: getCalculatedRepetitionGoal(repetitionNumber),
              repetitionStatus: repetitionNumber < getCurrentRepetitionNumber()
                  ? RepetitionStatusEnum.failed
                  : isInProgress() &&
                          repetitionNumber == getCurrentRepetitionNumber()
                      ? RepetitionStatusEnum.inProgress
                      : RepetitionStatusEnum.backlog));
    }

    repetitions = allRepetitions;
    return allRepetitions;
  }

  double getCurrentRepetitionProgressAbsolute() {
    var currentRepetition = getCurrentRepetition();

    if (currentRepetition == null) {
      return 0;
    }

    return currentRepetition.getLastProgressAbsolute();
  }

  double getCurrentRepetitionProgressPercentage() {
    var currentRepetition = getCurrentRepetition();
    if (currentRepetition == null) {
      return 0;
    }

    return currentRepetition.getLastProgressPercentage();
  }

  addRepetition() {
    RepetitionModel? lastRepetition = getLastRepetition();
    if (lastRepetition == null ||
        frequency.amount == null ||
        lastRepetition.repetitionNumber <
            frequency.getMaxAmountOfRepetitions()!) {
      int newRepetitionNumber =
          lastRepetition == null ? 1 : lastRepetition.repetitionNumber + 1;

      RepetitionModel addingRepetition = RepetitionModel.empty(
          repetitionNumber: newRepetitionNumber,
          goalAmount: acceptanceCriteria.amount);
      repetitions.add(addingRepetition);
      return addingRepetition;
    }
  }

  void endRepetition() {
    if (frequency.type == FrequencyTypeEnum.time) {
      RepetitionModel? currentRepetition = getCurrentRepetition();
      currentRepetition?.end();
      currentRepetition?.evaluateRepetitionStatus();
      addRepetition();
    }
  }

  bool isCompleted() {
    if (frequency.amount != null &&
            getCurrentRepetitionNumber() <
                frequency.getMaxAmountOfRepetitions()! ||
        frequency.amount != null &&
            repetitions.length < getCurrentRepetitionNumber()) {
      return false;
    }

    for (var repetition in repetitions) {
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

      if (endDate != null && endDate!.isBefore(DateTime.now())) {
        var days = endDate!.difference(startDate!).inDays;
        return days;
      }

      var days = DateTime.now().difference(startDate!).inDays + 1;
      if (frequency.amount == null) {
        return days;
      }
      return min(days, frequency.amount!);
    } else if (frequency.type == FrequencyTypeEnum.time) {
      if (frequency.amount == 0) {
        return 0;
      }
      return repetitions.isEmpty &&
              startDate != null &&
              startDate!.isBefore(DateTime.now())
          ? 1
          : repetitions.length;
    } else {
      return 0;
    }
  }

  void start() {
    startDate = DateTime.now();
    if (endDate == null || frequency.amount != null) {
      setEndDate();
    } else {
      setFrequencyAmount();
    }
    if (frequency.amount == 0) {
      return;
    }
    status = ChallengeStatusEnum.inProgress;
    RepetitionModel currentRepetition =
        getCurrentRepetition()!; // not null because start date is set above
    currentRepetition.start();
  }

  end() {
    if (isInProgress()) {
      endDate = DateTime.now();

      if (getCurrentRepetition()?.isInProgress() ?? false) {
        getCurrentRepetition()!.end();
      }

      if (isCompleted()) {
        status = ChallengeStatusEnum.success;
      } else {
        status = ChallengeStatusEnum.failed;
      }
    }
  }

  bool isInBacklog() {
    return status == ChallengeStatusEnum.backlog;
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
    return status == ChallengeStatusEnum.backlog ||
        status == ChallengeStatusEnum.inProgress;
  }

  double getCurrentPercentage() {
    if (getCurrentRepetitionNumber() == 0) {
      return 0;
    }

    double percentage = 0;

    for (RepetitionModel repetition in repetitions) {
      percentage += min(1, repetition.getLastProgressPercentage());
    }

    if (frequency.amount == null) {
      return percentage / getCurrentRepetitionNumber();
    }

    double currentPercentage =
        percentage / frequency.getMaxAmountOfRepetitions()!;
    return currentPercentage;
  }

  bool canEndRepetition() {
    return frequency.type == FrequencyTypeEnum.time &&
        getCurrentRepetition()?.isInProgress() &&
        getCurrentRepetition()!.progressList.isNotEmpty &&
        getCurrentRepetitionNumber() != frequency.getMaxAmountOfRepetitions();
  }

  endsIn() {
    if (frequency.type == FrequencyTypeEnum.daily) {
      RepetitionModel? currentRepetition = getCurrentRepetition();
      Duration difference = currentRepetition?.endDate != null
          ? currentRepetition!.endDate!.difference(DateTime.now())
          : Duration.zero;
      if (difference.inHours <= 0) {
        return '${difference.inMinutes} min';
      }
      return '${difference.inHours} h';
    }
    return '';
  }

  removeMedia(MediaModel media) {
    this.media.removeWhere((element) => element.id == media.id);
    for (var repetition in repetitions) {
      for (var progress in repetition.progressList) {
        progress.mediaIds.remove(media.id);
      }
    }
  }

  void setGoals(double goal) {
    acceptanceCriteria.amount = goal;
    for (RepetitionModel repetition in repetitions) {
      repetition.setGoals(goal);
    }
  }

  getCalculatedRepetitionGoal(int repetitionNumber) {
    return acceptanceCriteria.amount;
  }

  // Challenge List Functions

  static List<ChallengeModel> sortChallengeList(
      {required List<ChallengeModel> challenges}) {
    for (ChallengeModel challenge in challenges) {
      challenge.checkChallengeStatus();
    }
    challenges.sort((a, b) =>
        (a.isSucceeded() || a.isFailed()) && !(b.isSucceeded() || b.isFailed())
            ? 1
            : (b.isSucceeded() || b.isFailed()) &&
                    !(a.isSucceeded() || a.isFailed())
                ? -1
                : a.isInProgress() && b.isInBacklog()
                    ? 1
                    : b.isInProgress() && a.isInBacklog()
                        ? -1
                        : a
                            .getCurrentPercentage()
                            .compareTo(b.getCurrentPercentage()));
    return challenges;
  }
}
