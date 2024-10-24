import 'dart:math';

import 'package:challenge/enums/challenge_category_enum.dart';
import 'package:challenge/enums/challenge_status_enum.dart';
import 'package:challenge/enums/frequency_type_enum.dart.dart';
import 'package:challenge/enums/repetition_status_enum.dart';
import 'package:challenge/models/challenge/frequency_model.dart';
import 'package:challenge/models/challenge/repetition_model.dart';
import 'package:challenge/models/challenge/thumbnail_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

import 'acceptance_criteria_model.dart';
import 'media_model.dart';

class ChallengeModel {
  String id;
  static const String idField = 'id';

  ChallengeStatusEnum status;
  static const String statusField = 'status';

  String title;
  static const String titleField = 'title';

  String titleLowerCase; // only for search
  static const String titleLowerCaseField = 'titleLowerCase';

  String description;
  static const String descriptionField = 'description';

  ThumbnailModel? thumbnail;
  static const String thumbnailField = 'thumbnail';

  DateTime? startDate;
  static const String startDateField = 'startDate';

  DateTime? endDate;
  static const String endDateField = 'endDate';

  late AcceptanceCriteriaModel acceptanceCriteria;
  static const String acceptanceCriteriaField = 'acceptanceCriteria';

  late FrequencyModel frequency;
  static const String frequencyField = 'frequency';

  List<RepetitionModel> repetitions;
  static const String repetitionsField = 'repetitions';

  List<MediaModel> media;
  static const String mediaField = 'media';

  List<ChallengeCategoryEnum> categories;
  static const String categoriesField = 'categories';

  DateTime createdAt;
  static const String createdAtField = 'createdAt';

  ChallengeModel({
    required this.id,
    required this.status,
    required this.title,
    required this.titleLowerCase,
    required this.description,
    required this.thumbnail,
    this.startDate,
    this.endDate,
    required this.acceptanceCriteria,
    required this.frequency,
    required this.repetitions,
    required this.media,
    this.categories = const [],
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  ChallengeModel.empty({
    this.id = '',
    this.status = ChallengeStatusEnum.backlog,
    this.title = '',
    this.titleLowerCase = '',
    this.description = '',
    this.repetitions = const [],
    this.media = const [],
    this.categories = const [],
    DateTime? createdAt,
    this.thumbnail,
  }) : createdAt = createdAt ?? DateTime.now() {
    id = const Uuid().v4();
    acceptanceCriteria = AcceptanceCriteriaModel.empty();
    frequency = FrequencyModel.empty();
    repetitions = [];
    media = [];
  }

  static ChallengeModel fromDoc(DocumentSnapshot doc) {
    try {
      ChallengeModel challenge = ChallengeModel(
        id: doc.id,
        status: ChallengeStatusEnum.fromString(doc[statusField]),
        title: doc[titleField],
        titleLowerCase: doc[titleLowerCaseField],
        description: doc[descriptionField],
        thumbnail: doc[thumbnailField] == null
            ? null
            : ThumbnailModel.fromDoc(doc[thumbnailField]),
        startDate: doc[startDateField] == null
            ? null
            : (doc[startDateField] as Timestamp).toDate(),
        endDate: doc[endDateField] == null
            ? null
            : (doc[endDateField] as Timestamp).toDate(),
        acceptanceCriteria:
            AcceptanceCriteriaModel.fromDoc(doc[acceptanceCriteriaField]),
        frequency: FrequencyModel.fromDoc(doc[frequencyField]),
        repetitions: RepetitionModel.fromDocs(doc[repetitionsField]),
        media: MediaModel.fromDocs(doc[mediaField]),
        categories: ChallengeCategoryEnum.fromDocs(doc[categoriesField]),
        createdAt: (doc[createdAtField] as Timestamp).toDate(),
      );

      return challenge;
    } on Exception {
      rethrow;
    }
  }

  Map<String, dynamic> toDoc() {
    return {
      statusField: status.status,
      titleField: title,
      titleLowerCaseField: title.toLowerCase(),
      descriptionField: description,
      thumbnailField: thumbnail?.toDoc(),
      startDateField: startDate,
      endDateField: endDate,
      acceptanceCriteriaField: acceptanceCriteria.toDoc(),
      frequencyField: frequency.toDoc(),
      repetitionsField:
          repetitions.map((repetition) => repetition.toDoc()).toList(),
      mediaField: media.map((media) => media.toDoc()).toList(),
      categoriesField: ChallengeCategoryEnum.toDocs(categories),
      createdAtField: createdAt
    };
  }

  ChallengeModel copyChallenge({bool isTryAgain = false, bool withId = false}) {
    ChallengeModel challengeCopy = ChallengeModel(
        id: withId ? id : '',
        status: isTryAgain ? ChallengeStatusEnum.backlog : status,
        title: title,
        titleLowerCase: titleLowerCase,
        startDate: isTryAgain ? null : startDate,
        endDate: isTryAgain ? null : endDate,
        description: description,
        thumbnail: thumbnail?.copy(),
        acceptanceCriteria: acceptanceCriteria.copy(),
        frequency: frequency.copy(),
        repetitions:
            isTryAgain ? [] : RepetitionModel.copyRepetitionList(repetitions),
        media: isTryAgain ? [] : MediaModel.copyMediaList(media),
        categories: ChallengeCategoryEnum.copyCategoryList(categories));
    return challengeCopy;
  }

  bool searchInChallenge(String searchText) {
    if (title.toLowerCase().startsWith(searchText.toLowerCase())) return true;

    // too advanced for a free Firebase plan
    // TODO: we should implement the search better when we use the paid subscription
    // if (description.toLowerCase().contains(searchText.toLowerCase())) {
    //   return true;
    // }
    // if (acceptanceCriteria.unit
    //     .toLowerCase()
    //     .contains(searchText.toLowerCase())) {
    //   return true;
    // }
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
    return thumbnail != null && thumbnail!.url != '';
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

  // TODO: refactor this function
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
                      startDate != null &&
                      frequency.amount == null
                  ? startDate!.add(Duration(days: repetitionNumber))
                  : frequency.type == FrequencyTypeEnum.daily &&
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
    if (canEndRepetition()) {
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

  // TODO: refactor this function
  int getCurrentRepetitionNumber() {
    if (frequency.type == FrequencyTypeEnum.daily) {
      if (startDate == null) {
        return 0;
      } else if (DateTime.now().isBefore(startDate!)) {
        return 0;
      }

      if (endDate != null && endDate!.isBefore(DateTime.now())) {
        var days = endDate!.difference(startDate!).inDays +
            (endDate!.difference(startDate!).inSeconds -
                        endDate!.difference(startDate!).inDays * 24 * 60 * 60 >
                    0
                ? 1
                : 0);
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
        (getCurrentRepetition()?.isInProgress() ?? false) &&
        getCurrentRepetition()!.progressList.isNotEmpty &&
        getCurrentRepetitionNumber() != frequency.getMaxAmountOfRepetitions();
  }

  String endsIn() {
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
    challenges.sort((a, b) {
      // Check if a is succeeded or failed and b is not
      if ((a.isSucceeded() || a.isFailed()) &&
          !(b.isSucceeded() || b.isFailed())) {
        return 1;
      }

      // Check if b is succeeded or failed and a is not
      if ((b.isSucceeded() || b.isFailed()) &&
          !(a.isSucceeded() || a.isFailed())) {
        return -1;
      }

      // Check if a is in progress and b is in backlog
      if (a.isInProgress() && b.isInBacklog()) {
        return 1;
      }

      // Check if b is in progress and a is in backlog
      if (b.isInProgress() && a.isInBacklog()) {
        return -1;
      }

      // Compare by current percentage
      if (a.getCurrentPercentage().compareTo(b.getCurrentPercentage()) > 0) {
        return 1;
      }

      if (b.getCurrentPercentage().compareTo(a.getCurrentPercentage()) > 0) {
        return -1;
      }

      if ((a.isSucceeded() || a.isFailed()) &&
          (b.isSucceeded() || b.isFailed()) &&
          a.endDate != null &&
          b.endDate != null) {
        if (a.endDate!.compareTo(b.endDate!) > 0) {
          return -1;
        }

        if (b.endDate!.compareTo(a.endDate!) > 0) {
          return 1;
        }
      }

      if (a.createdAt.compareTo(b.createdAt) > 0) {
        return -1;
      }

      if (b.createdAt.compareTo(a.createdAt) > 0) {
        return 1;
      }

      return 0;
    });
    return challenges;
  }
}
