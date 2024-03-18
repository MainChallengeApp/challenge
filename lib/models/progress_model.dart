import 'package:challenge/models/repetition_model.dart';

import 'media_model.dart';

class ProgressModel {
  DateTime date;
  final int frequencyAmount;
  double progress;
  double percentProgress;
  List<String> mediaIds;

  ProgressModel(
      {required this.progress,
      required this.mediaIds,
      required this.date,
      required this.percentProgress,
      required this.frequencyAmount});

  static fromJsonList(json) {
    List<ProgressModel> progressList = [];
    json?.forEach((e) => progressList.add(ProgressModel(
        progress: e['progress'],
        mediaIds: List.from(e['mediaIds']),
        percentProgress: e['percentProgress'],
        date: e['date'],
        frequencyAmount: e['frequencyAmount'])));
    return progressList;
  }

  static toJsonList(List<ProgressModel> progressList) {
    return progressList
        .map((progress) => {
              'date': progress.date.toString(),
              'progress': progress.progress,
              'percentProgress': progress.percentProgress,
              'mediaIds': progress.mediaIds,
              'frequencyAmount': progress.frequencyAmount
            })
        .toList();
  }

  static copyRepetition(RepetitionModel repetition) {
    RepetitionModel repetitiontCopy = RepetitionModel(
        repetitionNumber: repetition.repetitionNumber, progressList: []);
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
      repetitionListCopy.add(ProgressModel.copyRepetition(e));
    }
    return repetitionListCopy;
  }
}
