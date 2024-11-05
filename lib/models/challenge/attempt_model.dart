import 'dart:math';

import 'package:challenge/enums/challenge_status_enum.dart';
import 'package:challenge/enums/frequency_type_enum.dart.dart';
import 'package:challenge/enums/repetition_status_enum.dart';
import 'package:challenge/models/challenge/acceptance_criteria_model.dart';
import 'package:challenge/models/challenge/challenge_model.dart';
import 'package:challenge/models/challenge/frequency_model.dart';
import 'package:challenge/models/challenge/media_model.dart';
import 'package:challenge/models/challenge/repetition_model.dart';
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
    required this.createdAt,
  });

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
      createdAt: DateTime.now(),
    );
  }

  Map<String, dynamic> toDoc() {
    return {
      numberField: number,
      startDateField: startDate,
      endDateField: endDate,
      statusField: status.toString(),
      acceptanceCriteriaField: acceptanceCriteria.toDoc(),
      frequencyField: frequency.toDoc(),
      mediaField: media.map((media) => media.toDoc()).toList(),
      repetitionsField:
          repetitions.map((repetition) => repetition.toDoc()).toList(),
      createdAtField: createdAt,
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

  bool isSucceeded() {
    return status == ChallengeStatusEnum.success;
  }

  bool isFailed() {
    return status == ChallengeStatusEnum.failed;
  }

  bool isInBacklog() {
    return status == ChallengeStatusEnum.backlog;
  }

  ChallengeStatusEnum checkStatus() {
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

  bool isInProgress() {
    return status == ChallengeStatusEnum.inProgress;
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

  static copyList(List<AttemptModel> attempts) {
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
      createdAt: isTryAgain ? DateTime.now() : createdAt,
    );
  }
}
