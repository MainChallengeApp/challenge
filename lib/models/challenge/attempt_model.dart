import 'dart:math';

import 'package:challenge/enums/challenge_status_enum.dart';
import 'package:challenge/enums/frequency_type_enum.dart.dart';
import 'package:challenge/enums/repetition_status_enum.dart';
import 'package:challenge/models/challenge/acceptance_criteria_model.dart';
import 'package:challenge/models/challenge/challenge_model.dart';
import 'package:challenge/models/challenge/frequency_model.dart';
import 'package:challenge/models/challenge/group_challenge_model.dart';
import 'package:challenge/models/challenge/media_model.dart';
import 'package:challenge/models/challenge/progress_model.dart';
import 'package:challenge/models/challenge/repetition_model.dart';
import 'package:challenge/services/time_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AttemptModel {
  int number;
  static const String numberField = 'number';

  DateTime? startDate;
  static const String startDateField = 'startDate';

  DateTime? endDate;
  static const String endDateField = 'endDate';

  ChallengeStatusEnum status;
  static const String statusField = 'status';

  AcceptanceCriteriaModel acceptanceCriteria;
  static const String acceptanceCriteriaField = 'acceptanceCriteria';

  FrequencyModel frequency;
  static const String frequencyField = 'frequency';

  List<MediaModel> media;
  static const String mediaField = 'media';

  List<RepetitionModel> repetitions;
  static const String repetitionsField = 'repetitions';

  DateTime createdAt;
  static const String createdAtField = 'createdAt';

  AttemptModel({
    required this.number,
    this.startDate,
    this.endDate,
    required this.status,
    required this.acceptanceCriteria,
    required this.frequency,
    required this.media,
    required this.repetitions,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? TimeService.now();

  AttemptModel.empty()
      : number = 1,
        startDate = null,
        endDate = null,
        status = ChallengeStatusEnum.backlog,
        acceptanceCriteria = AcceptanceCriteriaModel.empty(),
        frequency = FrequencyModel.empty(),
        media = [],
        repetitions = [],
        createdAt = TimeService.now();

  static fromChallengeModel({required ChallengeModel challenge}) {
    return AttemptModel(
      number: 1,
      startDate: null,
      endDate: null,
      status: ChallengeStatusEnum.backlog,
      acceptanceCriteria: challenge.acceptanceCriteria,
      frequency: challenge.frequency,
      media: [],
      repetitions: [],
      createdAt: TimeService.now(),
    );
  }

  Map<String, dynamic> toDoc() {
    return {
      numberField: number,
      startDateField: startDate != null ? Timestamp.fromDate(startDate!) : null,
      endDateField: endDate != null ? Timestamp.fromDate(endDate!) : null,
      statusField: status.toString(),
      acceptanceCriteriaField: acceptanceCriteria.toDoc(),
      frequencyField: frequency.toDoc(),
      mediaField: media.map((media) => media.toDoc()).toList(),
      repetitionsField:
          repetitions.map((repetition) => repetition.toDoc()).toList(),
      createdAtField: Timestamp.fromDate(createdAt),
    };
  }

  static AttemptModel fromDoc(Map<String, dynamic> doc) {
    try {
      return AttemptModel(
          number: doc[numberField],
          startDate: doc[startDateField] == null
              ? null
              : (doc[startDateField] as Timestamp).toDate(),
          endDate: doc[endDateField] == null
              ? null
              : (doc[endDateField] as Timestamp).toDate(),
          status: ChallengeStatusEnum.values
              .firstWhere((e) => e.toString() == doc[statusField]),
          acceptanceCriteria:
              AcceptanceCriteriaModel.fromDoc(doc[acceptanceCriteriaField]),
          frequency: FrequencyModel.fromDoc(doc[frequencyField]),
          media: MediaModel.fromDocs(doc[mediaField]),
          repetitions: RepetitionModel.fromDocs(doc[repetitionsField]),
          createdAt: (doc[createdAtField] as Timestamp).toDate());
    } on Exception {
      rethrow;
    }
  }

  List<RepetitionModel> getAllRepetitions(GroupChallengeModel groupChallenge) {
    List<RepetitionModel> getTimeRepetitions(
        DateTime? startDate,
        DateTime? endDate,
        DateTime now,
        FrequencyModel frequency,
        GroupChallengeModel groupChallenge) {
      if (startDate != null && startDate.isBefore(now) && repetitions.isEmpty) {
        return [
          RepetitionModel.empty(
              repetitionNumber: 1,
              goalAmount: getCalculatedRepetitionGoal(1, groupChallenge),
              startDate: startDate,
              endDate: frequency.amount == 1 ? endDate : null,
              repetitionStatus: RepetitionStatusEnum.inProgress)
        ];
      }
      return repetitions;
    }

    RepetitionStatusEnum determineRepetitionStatus(
        int repetitionNumber, int currentRepetitionNumber) {
      if (repetitionNumber < currentRepetitionNumber) {
        return RepetitionStatusEnum.failed;
      } else if (isInProgress() &&
          repetitionNumber == currentRepetitionNumber) {
        return RepetitionStatusEnum.inProgress;
      } else {
        return RepetitionStatusEnum.backlog;
      }
    }

    DateTime? calculateRepetitionEndDate(int repetitionNumber,
        DateTime? startDate, DateTime? endDate, FrequencyModel frequency) {
      if (startDate == null) return null;
      if (frequency.amount == null) {
        return startDate.add(Duration(days: repetitionNumber));
      }

      DateTime potentialEndDate =
          startDate.add(Duration(days: repetitionNumber));
      return endDate != null && potentialEndDate.isAfter(endDate)
          ? endDate
          : potentialEndDate;
    }

    RepetitionModel createDailyRepetition(
        int repetitionNumber,
        DateTime? startDate,
        DateTime? endDate,
        FrequencyModel frequency,
        int currentRepetitionNumber,
        GroupChallengeModel groupChallenge) {
      DateTime? repetitionStartDate = repetitionNumber == 0
          ? null
          : startDate?.add(Duration(days: repetitionNumber - 1));
      DateTime? repetitionEndDate = repetitionNumber == 0
          ? null
          : calculateRepetitionEndDate(
              repetitionNumber, startDate, endDate, frequency);

      return RepetitionModel.empty(
          startDate: repetitionStartDate,
          endDate: repetitionEndDate,
          repetitionNumber: repetitionNumber,
          goalAmount:
              getCalculatedRepetitionGoal(repetitionNumber, groupChallenge),
          repetitionStatus: determineRepetitionStatus(
              repetitionNumber, currentRepetitionNumber));
    }

    List<RepetitionModel> getDailyRepetitions(
        DateTime? startDate,
        DateTime? endDate,
        DateTime now,
        FrequencyModel frequency,
        GroupChallengeModel groupChallenge) {
      int currentRepetitionNumber = getCurrentRepetitionNumber(groupChallenge);
      if (currentRepetitionNumber == 0) {
        return [];
      }

      List<RepetitionModel> allRepetitions = [];

      for (int i = 0; i <= currentRepetitionNumber; i++) {
        allRepetitions.add(createDailyRepetition(i, startDate, endDate,
            frequency, currentRepetitionNumber, groupChallenge));
      }

      for (RepetitionModel repetition in repetitions) {
        for (ProgressModel progress in repetition.progressList) {
          _moveProgressToRightRepetition(allRepetitions, repetition, progress);
        }
      }

      allRepetitions.removeWhere((repetitionEntry) =>
          repetitionEntry.repetitionNumber == 0 &&
          repetitionEntry.progressList.isEmpty);

      repetitions = allRepetitions;
      return repetitions;
    }

    FrequencyModel frequency = getFrequency(groupChallenge);
    DateTime? startDate = getStartDate(groupChallenge);
    DateTime? endDate = getEndDate(groupChallenge);
    DateTime now = TimeService.now();

    switch (frequency.type) {
      case FrequencyTypeEnum.daily:
        return getDailyRepetitions(
            startDate, endDate, now, frequency, groupChallenge);
      case FrequencyTypeEnum.time:
        return getTimeRepetitions(
            startDate, endDate, now, frequency, groupChallenge);
      default:
        return repetitions;
    }
  }

  RepetitionModel? getLastRepetition(GroupChallengeModel groupChallenge) {
    List<RepetitionModel> allRepetitions = getAllRepetitions(groupChallenge);
    if (allRepetitions.isEmpty) {
      return null;
    }
    return allRepetitions.last;
  }

  RepetitionModel? getCurrentRepetition(GroupChallengeModel groupChallenge) {
    int currentRepetitionNumber = getCurrentRepetitionNumber(groupChallenge);
    if (currentRepetitionNumber == 0) {
      return null;
    }
    List<RepetitionModel> allRepetitions = getAllRepetitions(groupChallenge);
    RepetitionModel currentRepetition = allRepetitions.firstWhere(
        (repetition) => repetition.repetitionNumber == currentRepetitionNumber);
    return currentRepetition;
  }

  double getCurrentRepetitionProgressAbsolute(
      GroupChallengeModel groupChallenge) {
    var currentRepetition = getCurrentRepetition(groupChallenge);

    if (currentRepetition == null) {
      return 0;
    }

    return currentRepetition.getLastProgressAbsolute();
  }

  double getCurrentRepetitionProgressPercentage(
      GroupChallengeModel groupChallenge) {
    var currentRepetition = getCurrentRepetition(groupChallenge);
    if (currentRepetition == null) {
      return 0;
    }

    return currentRepetition.getLastProgressPercentage(groupChallenge, this);
  }

  addRepetition(GroupChallengeModel groupChallenge) {
    RepetitionModel? lastRepetition = getLastRepetition(groupChallenge);
    if (lastRepetition == null ||
        getFrequency(groupChallenge).amount == null ||
        lastRepetition.repetitionNumber <
            getFrequency(groupChallenge).getMaxAmountOfRepetitions()!) {
      int newRepetitionNumber =
          lastRepetition == null ? 1 : lastRepetition.repetitionNumber + 1;

      RepetitionModel addingRepetition = RepetitionModel.empty(
          repetitionNumber: newRepetitionNumber,
          goalAmount:
              getCalculatedRepetitionGoal(newRepetitionNumber, groupChallenge));
      repetitions.add(addingRepetition);
      return addingRepetition;
    }
  }

  void endRepetition(groupChallenge) {
    if (canEndRepetition(groupChallenge)) {
      RepetitionModel? currentRepetition = getCurrentRepetition(groupChallenge);
      currentRepetition?.end();
      currentRepetition?.evaluateRepetitionStatus();
      addRepetition(groupChallenge);
    }
  }

  bool isCompleted(GroupChallengeModel groupChallenge) {
    if (getFrequency(groupChallenge).amount != null &&
            getCurrentRepetitionNumber(groupChallenge) <
                getFrequency(groupChallenge).getMaxAmountOfRepetitions()! ||
        getFrequency(groupChallenge).amount != null &&
            repetitions.length < getCurrentRepetitionNumber(groupChallenge)) {
      return false;
    }

    for (var repetition in repetitions) {
      if (!repetition.isComplete()) {
        return false;
      }
    }
    return true;
  }

  bool isSucceeded() {
    return status == ChallengeStatusEnum.success;
  }

  bool isFailed() {
    return status == ChallengeStatusEnum.failed;
  }

  bool isInBacklog() {
    return status == ChallengeStatusEnum.backlog;
  }

  ChallengeStatusEnum checkStatus(GroupChallengeModel groupChallenge) {
    DateTime now = TimeService.now();
    if (isCompleted(groupChallenge) &&
        getEndDate(groupChallenge) != null &&
        getEndDate(groupChallenge)!.isBefore(now)) {
      status = ChallengeStatusEnum.success;
    } else if (getEndDate(groupChallenge) != null &&
        getEndDate(groupChallenge)!.isBefore(now)) {
      status = ChallengeStatusEnum.failed;
    } else if (getStartDate(groupChallenge) == null ||
        now.isBefore(getStartDate(groupChallenge)!)) {
      status = ChallengeStatusEnum.backlog;
    } else {
      status = ChallengeStatusEnum.inProgress;
    }
    return status;
  }

  int getCurrentRepetitionNumber(GroupChallengeModel groupChallenge) {
    int getDailyRepetitionNumber(DateTime now, DateTime? startDate,
        DateTime? endDate, FrequencyModel frequency) {
      if (startDate == null || now.isBefore(startDate)) {
        return 0;
      }

      int days;
      if (endDate != null && endDate.isBefore(now)) {
        days = endDate.difference(startDate).inDays + 1;
      } else {
        days = now.difference(startDate).inDays + 1;
      }

      return frequency.amount != null ? min(days, frequency.amount!) : days;
    }

    int getTimeRepetitionNumber(
        DateTime now, DateTime? startDate, FrequencyModel frequency) {
      if (frequency.amount == 0) {
        return 0;
      }
      if (startDate == null || now.isBefore(startDate)) {
        return 0;
      }
      return startDate.isBefore(now) && repetitions.isEmpty
          ? 1
          : repetitions.length;
    }

    DateTime now = TimeService.now();
    DateTime? startDate = getStartDate(groupChallenge);
    DateTime? endDate = getEndDate(groupChallenge);
    FrequencyModel frequency = getFrequency(groupChallenge);

    switch (frequency.type) {
      case FrequencyTypeEnum.daily:
        return getDailyRepetitionNumber(now, startDate, endDate, frequency);
      case FrequencyTypeEnum.time:
        return getTimeRepetitionNumber(now, startDate, frequency);
      default:
        return 0;
    }
  }

  void start(GroupChallengeModel groupChallenge) {
    startDate = TimeService.now();
    if (getEndDate(groupChallenge) == null ||
        getFrequency(groupChallenge).amount != null) {
      setEndDate(groupChallenge);
    } else {
      setFrequencyAmount(groupChallenge);
    }
    if (getFrequency(groupChallenge).amount == 0) {
      return;
    }
    status = ChallengeStatusEnum.inProgress;
    RepetitionModel currentRepetition = getCurrentRepetition(
        groupChallenge)!; // not null because start date is set above
    currentRepetition.start();
  }

  setStartDate(GroupChallengeModel groupChallenge) {
    DateTime? endDate = getEndDate(groupChallenge);
    FrequencyModel frequency = getFrequency(groupChallenge);

    if (endDate != null &&
        frequency.type == FrequencyTypeEnum.daily &&
        frequency.amount != null) {
      startDate = endDate.subtract(Duration(days: frequency.amount!));
    } else if (frequency.type == FrequencyTypeEnum.daily &&
        frequency.amount == null) {
      startDate = null;
    }
  }

  setEndDate(GroupChallengeModel groupChallenge) {
    DateTime? startDate = getStartDate(groupChallenge);
    FrequencyModel frequency = getFrequency(groupChallenge);

    if (startDate != null &&
        frequency.type == FrequencyTypeEnum.daily &&
        frequency.amount != null) {
      endDate = startDate.add(Duration(days: frequency.amount!));
    } else if (frequency.type == FrequencyTypeEnum.daily &&
        frequency.amount == null) {
      endDate = null;
    }
  }

  setFrequencyAmount(GroupChallengeModel groupChallenge) {
    if (getStartDate(groupChallenge) == null &&
        getEndDate(groupChallenge) == null) return;

    if (getStartDate(groupChallenge) != null &&
        getEndDate(groupChallenge) != null &&
        getFrequency(groupChallenge).type == FrequencyTypeEnum.daily) {
      int amount = getEndDate(groupChallenge)!
              .difference(getStartDate(groupChallenge)!)
              .inDays +
          (getEndDate(groupChallenge)!
                          .difference(getStartDate(groupChallenge)!)
                          .inSeconds -
                      getEndDate(groupChallenge)!
                              .difference(getStartDate(groupChallenge)!)
                              .inDays *
                          24 *
                          60 *
                          60 >
                  0
              ? 1
              : 0); // if there is not a whole day difference, add one day
      if (amount >= 0) {
        getFrequency(groupChallenge).amount = amount;
      }
    } else if (getFrequency(groupChallenge).type == FrequencyTypeEnum.daily &&
        getEndDate(groupChallenge) == null) {
      getFrequency(groupChallenge).amount = null;
    }
  }

  end(GroupChallengeModel groupChallenge) {
    if (isInProgress()) {
      endDate = TimeService.now();
      acceptanceCriteria.amount = getAcceptanceCriteria(groupChallenge).amount;
      repetitions.removeWhere((repetition) => repetition.startDate == null);

      if (getCurrentRepetition(groupChallenge)?.isInProgress() ?? false) {
        getCurrentRepetition(groupChallenge)!.end();
      }

      if (isCompleted(groupChallenge)) {
        status = ChallengeStatusEnum.success;
      } else {
        status = ChallengeStatusEnum.failed;
      }
    }
  }

  bool isInProgress() {
    return status == ChallengeStatusEnum.inProgress;
  }

  double getCurrentPercentage(GroupChallengeModel groupChallenge) {
    if (getCurrentRepetitionNumber(groupChallenge) == 0) {
      return 0;
    }

    double percentage = 0;

    for (RepetitionModel repetition in repetitions) {
      percentage += min(
          1,
          repetition.getLastProgressPercentage(
              groupChallenge, this)); // max 100%
    }

    if (getFrequency(groupChallenge).amount == null) {
      return percentage / getCurrentRepetitionNumber(groupChallenge);
    }

    double currentPercentage =
        percentage / getFrequency(groupChallenge).getMaxAmountOfRepetitions()!;
    return currentPercentage;
  }

  bool canEndRepetition(GroupChallengeModel groupChallenge) {
    return getFrequency(groupChallenge).type == FrequencyTypeEnum.time &&
        (getCurrentRepetition(groupChallenge)?.isInProgress() ?? false) &&
        getCurrentRepetition(groupChallenge)!.progressList.isNotEmpty &&
        getCurrentRepetitionNumber(groupChallenge) !=
            getFrequency(groupChallenge).getMaxAmountOfRepetitions();
  }

  String endsIn(GroupChallengeModel groupChallenge) {
    DateTime now = TimeService.now();
    if (getFrequency(groupChallenge).type == FrequencyTypeEnum.daily) {
      RepetitionModel? currentRepetition = getCurrentRepetition(groupChallenge);
      Duration difference = currentRepetition?.endDate != null
          ? currentRepetition!.endDate!.difference(now)
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

  AcceptanceCriteriaModel getAcceptanceCriteria(
      GroupChallengeModel groupChallenge) {
    return groupChallenge.groupChallengeOptions.isProgressIndividuell ||
            status == ChallengeStatusEnum.failed ||
            status == ChallengeStatusEnum.success
        ? acceptanceCriteria
        : groupChallenge.acceptanceCriteria;
  }

  FrequencyModel getFrequency(GroupChallengeModel groupChallenge) {
    return groupChallenge.groupChallengeOptions.isProgressIndividuell ||
            status == ChallengeStatusEnum.failed ||
            status == ChallengeStatusEnum.success
        ? frequency
        : groupChallenge.frequency;
  }

  DateTime? getEndDate(GroupChallengeModel groupChallenge) {
    return endDate ?? groupChallenge.endDate;
  }

  DateTime? getStartDate(GroupChallengeModel groupChallenge) {
    return startDate ?? groupChallenge.startDate;
  }

  void setGoals(double goal) {
    acceptanceCriteria.amount = goal;
    for (RepetitionModel repetition in repetitions) {
      repetition.setGoals(goal);
    }
  }

  double getCalculatedRepetitionGoal(
      int repetitionNumber, GroupChallengeModel groupChallenge) {
    return getAcceptanceCriteria(groupChallenge).amount;
  }

  static List<AttemptModel> copyList(List<AttemptModel> attempts) {
    return List<AttemptModel>.from(attempts.map((attempt) => attempt.copy()));
  }

  copy({bool isTryAgain = false}) {
    return AttemptModel(
      number: isTryAgain ? number + 1 : number,
      startDate: isTryAgain ? null : startDate,
      endDate: isTryAgain ? null : endDate,
      status: isTryAgain ? ChallengeStatusEnum.backlog : status,
      acceptanceCriteria: acceptanceCriteria.copy(),
      frequency: frequency.copy(),
      media: isTryAgain ? [] : MediaModel.copyList(media),
      repetitions: isTryAgain ? [] : RepetitionModel.copyList(repetitions),
      createdAt: isTryAgain ? TimeService.now() : createdAt,
    );
  }

  void _moveProgressToRightRepetition(List<RepetitionModel> allRepetitions,
      RepetitionModel repetition, ProgressModel progress) {
    List<RepetitionModel> rightRepetitions =
        allRepetitions.where((repetitionEntry) {
      DateTime startDate =
          repetitionEntry.startDate ?? DateTime(double.maxFinite.toInt());
      DateTime endDate = repetitionEntry.endDate ?? DateTime(0);
      return progress.date.isAfter(startDate) &&
              progress.date.isBefore(endDate) ||
          progress.date.isAtSameMomentAs(startDate);
    }).toList();
    if (rightRepetitions.isEmpty) {
      RepetitionModel repetitionZero = allRepetitions.firstWhere(
          (repetitionEntry) => repetitionEntry.repetitionNumber == 0);
      repetitionZero.progressList.add(progress);
      return;
    }
    rightRepetitions.first.progressList.add(progress);
  }
}
