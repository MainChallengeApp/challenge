import 'dart:math';

import 'package:challenge/enums/challenge_status_enum.dart';
import 'package:challenge/enums/frequency_type_enum.dart.dart';
import 'package:challenge/enums/repetition_status_enum.dart';
import 'package:challenge/models/challenge/acceptance_criteria_model.dart';
import 'package:challenge/models/challenge/challenge_model.dart';
import 'package:challenge/models/challenge/frequency_model.dart';
import 'package:challenge/models/challenge/group_challenge_model.dart';
import 'package:challenge/models/challenge/media_model.dart';
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

  static fromChallengeModel({required ChallengeModel challenge}) {
    return AttemptModel(
      number: 1,
      startDate: challenge.startDate,
      endDate: challenge.endDate,
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

  // TODO: refactor this function
  List<RepetitionModel> getAllRepetitions(GroupChallengeModel groupChallenge) {
    repetitions
        .sort((a, b) => a.repetitionNumber.compareTo(b.repetitionNumber));

    List<RepetitionModel> allRepetitions = [...repetitions];

    if (repetitions.length == getCurrentRepetitionNumber(groupChallenge)) {
      return allRepetitions;
    }

    for (int repetitionNumber = repetitions.length + 1;
        repetitionNumber <= getCurrentRepetitionNumber(groupChallenge);
        repetitionNumber++) {
      allRepetitions.insert(
          repetitionNumber - 1,
          RepetitionModel.empty(
              startDate:
                  getFrequency(groupChallenge).type == FrequencyTypeEnum.daily
                      ? getStartDate(groupChallenge)
                          ?.add(Duration(days: repetitionNumber - 1))
                      : getFrequency(groupChallenge).type ==
                                  FrequencyTypeEnum.time &&
                              getStartDate(groupChallenge) != null &&
                              repetitionNumber == 1
                          ? getStartDate(groupChallenge)
                          : null,
              endDate: getFrequency(groupChallenge).type ==
                          FrequencyTypeEnum.daily &&
                      getStartDate(groupChallenge) != null &&
                      getFrequency(groupChallenge).amount == null
                  ? getStartDate(groupChallenge)!
                      .add(Duration(days: repetitionNumber))
                  : getFrequency(groupChallenge).type ==
                              FrequencyTypeEnum.daily &&
                          repetitionNumber <=
                              getCurrentRepetitionNumber(groupChallenge) &&
                          getStartDate(groupChallenge) != null
                      ? getStartDate(groupChallenge)!
                                  .add(Duration(days: repetitionNumber))
                                  .difference(endDate!)
                                  .inMilliseconds <=
                              0
                          ? getStartDate(groupChallenge)!
                              .add(Duration(days: repetitionNumber))
                          : endDate
                      : null,
              repetitionNumber: repetitionNumber,
              goalAmount:
                  getCalculatedRepetitionGoal(repetitionNumber, groupChallenge),
              repetitionStatus:
                  repetitionNumber < getCurrentRepetitionNumber(groupChallenge)
                      ? RepetitionStatusEnum.failed
                      : isInProgress() &&
                              repetitionNumber ==
                                  getCurrentRepetitionNumber(groupChallenge)
                          ? RepetitionStatusEnum.inProgress
                          : RepetitionStatusEnum.backlog));
    }

    repetitions = allRepetitions;
    return allRepetitions;
  }

  RepetitionModel? getLastRepetition(GroupChallengeModel groupChallenge) {
    if (getAllRepetitions(groupChallenge).isEmpty) {
      return null;
    }
    return getAllRepetitions(groupChallenge).last;
  }

  RepetitionModel? getCurrentRepetition(GroupChallengeModel groupChallenge) {
    if (getCurrentRepetitionNumber(groupChallenge) == 0) {
      return null;
    }
    RepetitionModel currentRepetition = getAllRepetitions(groupChallenge)
        .firstWhere((repetition) =>
            repetition.repetitionNumber ==
            getCurrentRepetitionNumber(groupChallenge));
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
          goalAmount: getAcceptanceCriteria(groupChallenge).amount);
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
        endDate != null &&
        endDate!.isBefore(now)) {
      status = ChallengeStatusEnum.success;
    } else if (endDate != null && endDate!.isBefore(now)) {
      status = ChallengeStatusEnum.failed;
    } else if (getStartDate(groupChallenge) == null ||
        now.isBefore(getStartDate(groupChallenge)!)) {
      status = ChallengeStatusEnum.backlog;
    } else {
      status = ChallengeStatusEnum.inProgress;
    }
    return status;
  }

  // TODO: refactor this function
  int getCurrentRepetitionNumber(GroupChallengeModel groupChallenge) {
    DateTime now = TimeService.now();
    if (getFrequency(groupChallenge).type == FrequencyTypeEnum.daily) {
      if (getStartDate(groupChallenge) == null) {
        return 0;
      } else if (now.isBefore(getStartDate(groupChallenge)!)) {
        return 0;
      }

      if (endDate != null && endDate!.isBefore(now)) {
        var days = endDate!.difference(getStartDate(groupChallenge)!).inDays +
            (endDate!.difference(getStartDate(groupChallenge)!).inSeconds -
                        endDate!
                                .difference(getStartDate(groupChallenge)!)
                                .inDays *
                            24 *
                            60 *
                            60 >
                    0
                ? 1
                : 0);
        return days;
      }

      var days = now.difference(getStartDate(groupChallenge)!).inDays + 1;
      if (getFrequency(groupChallenge).amount == null) {
        return days;
      }
      return min(days, getFrequency(groupChallenge).amount!);
    } else if (getFrequency(groupChallenge).type == FrequencyTypeEnum.time) {
      if (getFrequency(groupChallenge).amount == 0) {
        return 0;
      }
      return repetitions.isEmpty &&
              getStartDate(groupChallenge) != null &&
              (getStartDate(groupChallenge)!.isBefore(now) ||
                  getStartDate(groupChallenge)!.isAtSameMomentAs(now))
          ? 1
          : repetitions.length;
    } else {
      return 0;
    }
  }

  void start(GroupChallengeModel groupChallenge) {
    startDate = TimeService.now();
    if (endDate == null || getFrequency(groupChallenge).amount != null) {
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

  setEndDate(GroupChallengeModel groupChallenge) {
    if (getStartDate(groupChallenge) != null &&
        getFrequency(groupChallenge).type == FrequencyTypeEnum.daily &&
        getFrequency(groupChallenge).amount != null) {
      endDate = getStartDate(groupChallenge)!
          .add(Duration(days: getFrequency(groupChallenge).amount!));
    } else if (getFrequency(groupChallenge).type == FrequencyTypeEnum.daily &&
        getFrequency(groupChallenge).amount == null) {
      endDate = null;
    }
  }

  setFrequencyAmount(GroupChallengeModel groupChallenge) {
    if (getStartDate(groupChallenge) == null && endDate == null) return;

    if (getStartDate(groupChallenge) != null &&
        endDate != null &&
        getFrequency(groupChallenge).type == FrequencyTypeEnum.daily) {
      int amount = endDate!.difference(getStartDate(groupChallenge)!).inDays +
          (endDate!.difference(getStartDate(groupChallenge)!).inSeconds -
                      endDate!
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
        endDate == null) {
      getFrequency(groupChallenge).amount = null;
    }
  }

  end(GroupChallengeModel groupChallenge) {
    if (isInProgress()) {
      endDate = TimeService.now();
      acceptanceCriteria.amount = getAcceptanceCriteria(groupChallenge).amount;

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
    if (groupChallenge.endDate == null || endDate == null) {
      return groupChallenge.endDate ?? endDate;
    }
    return groupChallenge.endDate!.isBefore(endDate!)
        ? groupChallenge.endDate
        : endDate;
  }

  DateTime? getStartDate(GroupChallengeModel groupChallenge) {
    if (groupChallenge.startDate == null || startDate == null) {
      return groupChallenge.startDate ?? startDate;
    }
    return groupChallenge.startDate!.isAfter(startDate!)
        ? groupChallenge.startDate
        : startDate;
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
}
