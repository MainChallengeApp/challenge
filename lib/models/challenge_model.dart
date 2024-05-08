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
      this.title = "",
      this.description = "",
      this.thumbnailPath = "",
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
      {required ChallengeModel challenge,
      bool isTryAgain = false,
      bool withId = false}) {
    ChallengeModel challengeCopy = ChallengeModel(
        id: withId ? challenge.id : null,
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
            repetition.repetitionNumber == getCurrentRepetitionNumber(),
        orElse: () => RepetitionModel.empty(
            // shouldnt be called
            repetitionNumber: getCurrentRepetitionNumber(),
            goalAmount: acceptanceCriteria.amount,
            repetitionStatus: RepetitionStatusEnum.backlog));
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
                      (repetitionNumber < getCurrentRepetitionNumber() ||
                          !isInProgress())
                  ? startDate?.add(Duration(days: repetitionNumber - 1))
                  : null,
              repetitionNumber: repetitionNumber,
              goalAmount: acceptanceCriteria.amount,
              repetitionStatus: repetitionNumber < getCurrentRepetitionNumber()
                  ? RepetitionStatusEnum.failed
                  : frequency.type == FrequencyTypeEnum.time &&
                          isInProgress() &&
                          repetitionNumber == getCurrentRepetitionNumber()
                      ? RepetitionStatusEnum.inProgress
                      : RepetitionStatusEnum.backlog));
    }

    repetitions = allRepetitions;
    return allRepetitions;
  }

  setRepetitionsEndDate() {
    if (frequency.type != FrequencyTypeEnum.daily) {
      return;
    }

    List<RepetitionModel> allRepetitions = getAllRepetitions();
    for (var repetition in allRepetitions) {
      if (startDate != null &&
          (repetition.repetitionNumber != getCurrentRepetitionNumber() ||
              startDate!
                  .add(const Duration(days: 1))
                  .isBefore(DateTime.now()))) {
        repetition.endDate =
            startDate!.add(Duration(days: repetition.repetitionNumber));
      }
    }
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

  addRepetition() {
    RepetitionModel? currentRepetition = getLastRepetition();
    if (currentRepetition == null ||
        frequency.amount == null ||
        currentRepetition.repetitionNumber <
            frequency.getMaxAmoutOfRepetitions()!) {
      int newRepetitionNumber = currentRepetition == null
          ? 1
          : currentRepetition.repetitionNumber + 1;

      RepetitionModel addingRepetition = RepetitionModel(
          repetitionNumber: newRepetitionNumber,
          goalAmount: acceptanceCriteria.amount,
          progressList: [],
          repetitionStatus: RepetitionStatusEnum.backlog);
      repetitions.add(addingRepetition);
      return addingRepetition;
    }
  }

  evaluateRepetitionStatus(RepetitionModel repetition) {
    if (repetition.isComplete() &&
        repetition.endDate != null &&
        repetition.endDate!.isBefore(DateTime.now())) {
      repetition.repetitionStatus = RepetitionStatusEnum.success;
      return repetition.repetitionStatus;
    } else if (repetition.endDate != null &&
        repetition.endDate!.isBefore(DateTime.now())) {
      repetition.repetitionStatus = RepetitionStatusEnum.failed;
      return repetition.repetitionStatus;
    }
    if (repetition.startDate != null) {
      repetition.repetitionStatus = RepetitionStatusEnum.inProgress;
      return repetition.repetitionStatus;
    }

    repetition.repetitionStatus = RepetitionStatusEnum.backlog;
    return repetition.repetitionStatus;
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
    if (endDate == null) {
      setEndDate();
    } else {
      setFrequencyAmount();
    }
    if (frequency.amount == 0) {
      end();
      return;
    }
    status = ChallengeStatusEnum.inProgress;
    if (getAllRepetitions().isEmpty &&
        (frequency.amount == null || frequency.amount! > 0)) {
      RepetitionModel addingRepetition = addRepetition();
      addingRepetition.start();
    } else {
      RepetitionModel? currentRepetition = getCurrentRepetition();
      if (currentRepetition != null) {
        currentRepetition.start();
      }
    }
  }

  end() {
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

  static List<ChallengeModel> copyChallengeListWithId(
      {required List<ChallengeModel> challenges}) {
    List<ChallengeModel> challengeCopies = [];
    for (var challenge in challenges) {
      challengeCopies.add(copyChallenge(challenge: challenge, withId: true));
    }
    return challengeCopies;
  }

  static List<ChallengeModel> sortChallengeList(
      {required List<ChallengeModel> challenges}) {
    for (ChallengeModel challenge in challenges) {
      challenge.checkChallengeStatus();
    }
    // challengeList.sort((a, b) => a.isSucceeded() && !b.isSucceeded()
    //     ? -1
    //     : b.isSucceeded() && !a.isSucceeded()
    //         ? 1
    //         : 0);
    challenges.sort((a, b) =>
        (a.isSucceeded() || a.isFailed()) && !(b.isSucceeded() || b.isFailed())
            ? 1
            : (b.isSucceeded() || b.isFailed()) &&
                    !(a.isSucceeded() || a.isFailed())
                ? -1
                : a.getCurrentPercentage().compareTo(b.getCurrentPercentage()));
    return challenges;
  }

  bool canEndRepetition() {
    return frequency.type == FrequencyTypeEnum.time &&
        getCurrentRepetition()?.isInProgress() &&
        getCurrentRepetition()!.progressList.isNotEmpty &&
        getCurrentRepetitionNumber() != frequency.getMaxAmoutOfRepetitions();
  }

  nextIn() {
    if (frequency.type == FrequencyTypeEnum.daily) {
      RepetitionModel? currentRepetition = getCurrentRepetition();
      Duration difference = currentRepetition?.startDate
              ?.add(const Duration(days: 1))
              .difference(DateTime.now()) ??
          Duration.zero;
      if (difference.inHours <= 0) {
        return '${difference.inMinutes} min';
      }
      return '${difference.inHours} h';
    }
    return 0;
  }
}
