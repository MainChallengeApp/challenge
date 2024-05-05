import 'package:challenge/enums/repetition_status_enum.dart';
import 'package:challenge/models/challenge_model.dart';
import 'package:challenge/models/progress_model.dart';

class RepetitionModel {
  final int repetitionNumber;
  final double goalAmount;
  late final List<ProgressModel> progressList;
  DateTime? startDate;
  DateTime? endDate;
  RepetitionStatusEnum repetitionStatus;

  RepetitionModel(
      {required this.repetitionNumber,
      required this.goalAmount,
      required this.progressList,
      this.startDate,
      this.endDate,
      required this.repetitionStatus});

  RepetitionModel.empty(
      {required this.repetitionNumber,
      required this.goalAmount,
      this.startDate,
      this.endDate,
      this.repetitionStatus = RepetitionStatusEnum.backlog}) {
    progressList = [];
  }

  bool isComplete() {
    if (progressList.isEmpty) {
      return false;
    }
    return progressList.last.progress >= goalAmount;
  }

  bool isFailed(ChallengeModel challenge) {
    return repetitionStatus == RepetitionStatusEnum.failed;
  }

  isInProgress() {
    return repetitionStatus == RepetitionStatusEnum.inProgress &&
        startDate != null;
  }

  bool isInBacklog() {
    return repetitionStatus == RepetitionStatusEnum.backlog ||
        startDate == null;
  }

  void start() {
    startDate = DateTime.now();
    repetitionStatus = RepetitionStatusEnum.inProgress;
  }

  void end() {
    endDate = DateTime.now();
    repetitionStatus = isComplete()
        ? RepetitionStatusEnum.success
        : RepetitionStatusEnum.failed;
  }

  evaluateRepetitionStatus() {
    if (isInProgress()) {
      if (isComplete()) {
        repetitionStatus = RepetitionStatusEnum.success;
        return repetitionStatus;
      } else if (endDate != null && endDate!.isBefore(DateTime.now())) {
        repetitionStatus = RepetitionStatusEnum.failed;
        return repetitionStatus;
      }
    }
    if (startDate != null) {
      repetitionStatus = RepetitionStatusEnum.inProgress;
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

  double getLastProgressProgress() {
    if (progressList.isEmpty) {
      return 0;
    }
    return progressList.last.progress;
  }

  ProgressModel? getLastProgress() {
    if (progressList.isEmpty) {
      return null;
    }
    return progressList.last;
  }

  ProgressModel addProgress(
      {ProgressModel? progress, mediaIds = const <String>[]}) {
    if (progress == null) {
      ProgressModel emptyProgress = ProgressModel.empty(
          repetitionNumber: repetitionNumber, mediaIds: mediaIds);
      progressList.add(emptyProgress);
      return emptyProgress;
    }
    progressList.add(progress);
    return progress;
  }

  static toJsonList(List<RepetitionModel> repetitions) {
    return repetitions
        .map((e) => {
              'repetitionNumber': e.repetitionNumber,
              'goalAmount': e.goalAmount,
              'progressList': ProgressModel.toJsonList(e.progressList),
              'startDate': e.startDate.toString(),
              'endDate': e.endDate.toString(),
              'repetitionStatus': e.repetitionStatus.toString()
            })
        .toList();
  }

  static fromJsonList(json) {
    List<RepetitionModel> list = [];
    json?.forEach((json) => list.add(RepetitionModel(
        repetitionNumber: json['repetitionNumber'],
        goalAmount: json['goalAmount'] ??
            0, // ?? 0 can be removed when no more home challenges saved without goalAmount
        progressList: ProgressModel.fromJsonList(json['progressList']),
        startDate: json['startDate'] == null ||
                json['startDate'] == 'null' ||
                json['startDate'] == ''
            ? null
            : DateTime.parse(json['startDate']),
        endDate: json['endDate'] == null ||
                json['endDate'] == 'null' ||
                json['endDate'] == ''
            ? null
            : DateTime.parse(json['endDate']),
        repetitionStatus:
            RepetitionStatusEnum.factory(json['repetitionStatus']))));
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
