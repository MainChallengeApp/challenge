import 'package:challenge/enums/repetition_status_enum.dart';
import 'package:challenge/models/progress_model.dart';

class RepetitionModel {
  final int repetitionNumber;
  double goalAmount;
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
    if (isComplete() && endDate != null && endDate!.isBefore(DateTime.now())) {
      repetitionStatus = RepetitionStatusEnum.success;
      return repetitionStatus;
    } else if (!isComplete() &&
        endDate != null &&
        endDate!.isBefore(DateTime.now())) {
      repetitionStatus = RepetitionStatusEnum.failed;
      return repetitionStatus;
    }
    if (startDate != null) {
      repetitionStatus = RepetitionStatusEnum.inProgress;
      return repetitionStatus;
    }

    repetitionStatus = RepetitionStatusEnum.backlog;
    return repetitionStatus;
  }

  double getLastProgressPercentage() {
    if (progressList.isEmpty) {
      return 0;
    }
    return progressList.last.getPercentProgress();
  }

  double getLastProgressAbsolute() {
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
          repetitionNumber: repetitionNumber,
          goal: goalAmount,
          mediaIds: mediaIds);
      progressList.add(emptyProgress);
      return emptyProgress;
    }
    progressList.add(progress);
    return progress;
  }

  toJson() {
    return {
      'repetitionNumber': repetitionNumber,
      'goalAmount': goalAmount,
      'progressList': ProgressModel.toJsonList(progressList),
      'startDate': startDate.toString(),
      'endDate': endDate.toString(),
      'repetitionStatus': repetitionStatus.toString()
    };
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

  copyRepetition() {
    RepetitionModel repetitionCopy = RepetitionModel(
        repetitionNumber: repetitionNumber,
        goalAmount: goalAmount,
        progressList: ProgressModel.copyProgressList(progressList),
        repetitionStatus: repetitionStatus,
        startDate: startDate,
        endDate: endDate);

    return repetitionCopy;
  }

  static copyRepetitionList(List<RepetitionModel> repetitionList) {
    List<RepetitionModel> repetitionListCopy = [];
    for (var repetition in repetitionList) {
      repetitionListCopy.add(repetition.copyRepetition());
    }
    return repetitionListCopy;
  }

  void deleteProgress(ProgressModel progress) {
    progressList.remove(progress);
  }

  void setGoals(double goal) {
    goalAmount = goal;
    for (var progress in progressList) {
      progress.goal = goal;
    }
  }
}
