import 'package:challenge/models/media_model.dart';
import 'package:challenge/models/progress_model.dart';

class RepetitionModel {
  final int repetitionNumber;
  final double goalAmount;
  final List<ProgressModel> progressList;

  RepetitionModel(
      {required this.repetitionNumber,
      required this.goalAmount,
      required this.progressList});

  double getLastProgressPercentage() {
    if (progressList.isEmpty) {
      return 0;
    }
    progressList.sort((a, b) => b.date.millisecond - a.date.millisecond);
    return progressList.last.percentProgress;
  }

  static toJsonList(List<RepetitionModel> repetitions) {
    return repetitions
        .map((e) => {
              'repetitionNumber': e.repetitionNumber,
              'goalAmount': e.goalAmount,
              'progressList': ProgressModel.toJsonList(e.progressList),
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
        )));
    return list;
  }

  static copyRepetition(RepetitionModel repetition) {
    RepetitionModel repetitiontCopy = RepetitionModel(
        repetitionNumber: repetition.repetitionNumber,
        goalAmount: repetition.goalAmount,
        progressList: []);
    for (var e in repetition.progressList) {
      repetitiontCopy.progressList.add(ProgressModel(
          date: e.date,
          progress: e.progress,
          mediaIds: MediaModel.copyMediaIdList(e.mediaIds),
          percentProgress: e.percentProgress,
          frequencyAmount: e.frequencyAmount));
    }
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
