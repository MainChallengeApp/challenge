import 'package:challenge/enums/repetition_status_enum.dart';
import 'package:challenge/models/challenge/attempt_model.dart';
import 'package:challenge/models/challenge/group_challenge_model.dart';
import 'package:challenge/models/challenge/progress_model.dart';
import 'package:challenge/services/time_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RepetitionModel {
  int repetitionNumber;
  static const String repetitionNumberField = 'repetitionNumber';

  double goalAmount;
  static const String goalAmountField = 'goalAmount';

  late final List<ProgressModel> progressList;
  static const String progressListField = 'progressList';

  DateTime? startDate;
  static const String startDateField = 'startDate';

  DateTime? endDate;
  static const String endDateField = 'endDate';

  RepetitionStatusEnum repetitionStatus;
  static const String repetitionStatusField = 'repetitionStatus';

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

  RepetitionModel.zero({required this.goalAmount})
      : repetitionNumber = 0,
        progressList = [],
        repetitionStatus = RepetitionStatusEnum.backlog;

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
    startDate = TimeService.now();
    repetitionStatus = RepetitionStatusEnum.inProgress;
  }

  void end() {
    endDate = TimeService.now();
    repetitionStatus = isComplete()
        ? RepetitionStatusEnum.success
        : RepetitionStatusEnum.failed;
  }

  evaluateRepetitionStatus() {
    DateTime now = TimeService.now();
    if (isComplete() && endDate != null && endDate!.isBefore(now)) {
      repetitionStatus = RepetitionStatusEnum.success;
      return repetitionStatus;
    } else if (!isComplete() && endDate != null && endDate!.isBefore(now)) {
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

  double getLastProgressPercentage(
      GroupChallengeModel groupChallenge, AttemptModel attempt) {
    if (progressList.isEmpty) {
      return 0;
    }
    return progressList.last.getProgressPercentage(groupChallenge, attempt);
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
      ProgressModel emptyProgress = ProgressModel.empty(mediaIds: mediaIds);
      progressList.add(emptyProgress);
      return emptyProgress;
    }
    progressList.add(progress);
    return progress;
  }

  Map<String, dynamic> toDoc() {
    return {
      repetitionNumberField: repetitionNumber,
      goalAmountField: goalAmount,
      progressListField: ProgressModel.toDocs(progressList),
      startDateField: startDate == null ? null : Timestamp.fromDate(startDate!),
      endDateField: endDate == null ? null : Timestamp.fromDate(endDate!),
      repetitionStatusField: repetitionStatus.status
    };
  }

  static fromDocs(docs) {
    List<RepetitionModel> list = [];
    docs?.forEach((doc) => list.add(RepetitionModel(
        repetitionNumber: doc[repetitionNumberField],
        goalAmount: (doc[goalAmountField] as num)
            .toDouble(), // ?? 0 can be removed when no more home challenges saved without goalAmount
        progressList: ProgressModel.fromDocs(doc[progressListField]),
        startDate: doc[startDateField] == null ||
                doc[startDateField] == 'null' ||
                doc[startDateField] == ''
            ? null
            : (doc[startDateField] as Timestamp).toDate(),
        endDate: doc[endDateField] == null ||
                doc[endDateField] == 'null' ||
                doc[endDateField] == ''
            ? null
            : (doc[endDateField] as Timestamp).toDate(),
        repetitionStatus:
            RepetitionStatusEnum.fromString(doc[repetitionStatusField]))));
    return list;
  }

  copy() {
    RepetitionModel repetitionCopy = RepetitionModel(
        repetitionNumber: repetitionNumber,
        goalAmount: goalAmount,
        progressList: ProgressModel.copyProgressList(progressList),
        repetitionStatus: repetitionStatus,
        startDate: startDate,
        endDate: endDate);

    return repetitionCopy;
  }

  static copyList(List<RepetitionModel> repetitionList) {
    List<RepetitionModel> repetitionListCopy = [];
    for (var repetition in repetitionList) {
      repetitionListCopy.add(repetition.copy());
    }
    return repetitionListCopy;
  }

  void deleteProgress(ProgressModel progress) {
    progressList.remove(progress);
  }

  void setGoals(double goal) {
    goalAmount = goal;
  }
}
