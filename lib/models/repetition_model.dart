import 'package:challenge/enums/repetition_status_enum.dart';
import 'package:challenge/models/challenge_model.dart';
import 'package:challenge/models/progress_model.dart';

class RepetitionModel {
  final int repetitionNumber;
  final double goalAmount;
  final List<ProgressModel> progressList;
  RepetitionStatusEnum repetitionStatus;

  RepetitionModel(
      {required this.repetitionNumber,
      required this.goalAmount,
      required this.progressList,
      required this.repetitionStatus});

  RepetitionModel.empty(
      {required this.repetitionNumber,
      required this.goalAmount,
      this.progressList = const [],
      this.repetitionStatus = RepetitionStatusEnum.backlog});

  bool isComplete() {
    if (progressList.isEmpty) {
      return false;
    }
    return progressList.last.progress >= goalAmount;
  }

  bool isFailed(ChallengeModel challenge) {
    return evaluateRepetitionStatus(challenge) == RepetitionStatusEnum.failed;
  }

  evaluateRepetitionStatus(ChallengeModel challenge) {
    if (isComplete()) {
      repetitionStatus = RepetitionStatusEnum.success;
      return repetitionStatus;
    }

    final currentRepetitionNumber = challenge.getCurrentRepetitionNumber();

    if (currentRepetitionNumber == repetitionNumber) {
      repetitionStatus = RepetitionStatusEnum.inProgress;
      return repetitionStatus;
    }

    if (currentRepetitionNumber > repetitionNumber) {
      repetitionStatus = RepetitionStatusEnum.failed;
      return repetitionStatus;
    }

    repetitionStatus = RepetitionStatusEnum.backlog;
    return repetitionStatus;
  }

  isCurrentRepetition(ChallengeModel challenge) {
    return challenge.getCurrentRepetitionNumber() == repetitionNumber;
  }

  double getLastProgressPercentage() {
    if (progressList.isEmpty) {
      return 0;
    }
    return progressList.last.percentProgress;
  }

  ProgressModel? getLastProgress() {
    if (progressList.isEmpty) {
      return null;
    }
    return progressList.last;
  }

  ProgressModel addProgress({mediaIds = const <String>[]}) {
    ProgressModel progress = ProgressModel.empty(
        repetitionNumber: repetitionNumber, mediaIds: mediaIds);
    progressList.add(progress);
    return progress;
  }

  static toJsonList(List<RepetitionModel> repetitions) {
    return repetitions
        .map((e) => {
              'repetitionNumber': e.repetitionNumber,
              'goalAmount': e.goalAmount,
              'progressList': ProgressModel.toJsonList(e.progressList),
              'repetitionStatus': e.repetitionStatus.toString()
            })
        .toList();
  }

  static fromJsonList(json) {
    List<RepetitionModel> list = [];
    json?.forEach((e) => list.add(RepetitionModel(
        repetitionNumber: e['repetitionNumber'],
        goalAmount: e['goalAmount'] ??
            0, // ?? 0 can be removed when no more home challenges saved without goalAmount
        progressList: ProgressModel.fromJsonList(e['progressList']),
        repetitionStatus:
            RepetitionStatusEnum.factory(e['repetitionStatus']))));
    return list;
  }

  static copyRepetition(RepetitionModel repetition) {
    RepetitionModel repetitiontCopy = RepetitionModel(
        repetitionNumber: repetition.repetitionNumber,
        goalAmount: repetition.goalAmount,
        progressList: ProgressModel.copyProgressList(repetition.progressList),
        repetitionStatus: repetition.repetitionStatus);
    return repetitiontCopy;
  }

  static copyRepetitionList(List<RepetitionModel> repetitionList) {
    List<RepetitionModel> repetitionListCopy = [];
    for (var e in repetitionList) {
      repetitionListCopy.add(RepetitionModel.copyRepetition(e));
    }
    return repetitionListCopy;
  }
}
