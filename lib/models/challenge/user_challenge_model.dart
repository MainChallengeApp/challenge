import 'dart:math';

import 'package:challenge/enums/challenge_status_enum.dart';
import 'package:challenge/enums/frequency_type_enum.dart.dart';
import 'package:challenge/enums/repetition_status_enum.dart';
import 'package:challenge/models/challenge/challenge_model.dart';
import 'package:challenge/models/challenge/media_model.dart';
import 'package:challenge/models/challenge/repetition_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserChallengeModel extends ChallengeModel {
  String userId;
  static const String userIdField = 'userId';

  List<RepetitionModel> repetitions;
  static const String repetitionsField = 'repetitions';

  UserChallengeModel({
    required super.id,
    required this.userId,
    required this.repetitions,
    required super.status,
    required super.title,
    required super.titleLowerCase,
    required super.description,
    required super.thumbnail,
    super.startDate,
    super.endDate,
    required super.acceptanceCriteria,
    required super.frequency,
    required super.media,
    super.categories = const [],
  });

  UserChallengeModel.fromChallengeModel({
    required ChallengeModel challenge,
    required this.userId,
    required this.repetitions,
  }) : super(
          id: challenge.id,
          status: challenge.status,
          title: challenge.title,
          titleLowerCase: challenge.titleLowerCase,
          description: challenge.description,
          thumbnail: challenge.thumbnail,
          startDate: challenge.startDate,
          endDate: challenge.endDate,
          acceptanceCriteria: challenge.acceptanceCriteria,
          frequency: challenge.frequency,
          media: challenge.media,
          categories: challenge.categories,
          createdAt: challenge.createdAt,
        );

  @override
  Map<String, dynamic> toDoc() {
    return {
      ...super.toDoc(),
      userIdField: userId,
      repetitionsField:
          repetitions.map((repetition) => repetition.toDoc()).toList(),
    };
  }

  static UserChallengeModel fromDoc(DocumentSnapshot doc) {
    try {
      ChallengeModel challenge = ChallengeModel.fromDoc(doc);
      return UserChallengeModel.fromChallengeModel(
          challenge: challenge,
          userId: doc[userIdField],
          repetitions: RepetitionModel.fromDocs(doc[repetitionsField]));
    } on Exception {
      rethrow;
    }
  }

  @override
  UserChallengeModel copyChallenge(
      {bool isTryAgain = false, bool withId = false}) {
    return UserChallengeModel.fromChallengeModel(
      challenge: super.copyChallenge(isTryAgain: isTryAgain, withId: withId),
      userId: userId,
      repetitions:
          isTryAgain ? [] : RepetitionModel.copyRepetitionList(repetitions),
    );
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

  static List<UserChallengeModel> sortChallengeList(
      {required List<UserChallengeModel> userChallenges}) {
    for (UserChallengeModel userChallenge in userChallenges) {
      userChallenge.checkChallengeStatus();
    }
    userChallenges.sort((a, b) {
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
    return userChallenges;
  }
}
