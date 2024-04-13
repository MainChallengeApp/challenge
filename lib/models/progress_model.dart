import 'package:challenge/models/media_model.dart';

class ProgressModel {
  late DateTime date;
  int frequencyAmount;
  double progress;
  double percentProgress;
  List<String> mediaIds;

  ProgressModel(
      {required this.progress,
      required this.mediaIds,
      required this.date,
      required this.percentProgress,
      required this.frequencyAmount});

  ProgressModel.empty(
      {required this.frequencyAmount,
      this.percentProgress = 0,
      this.progress = 0,
      this.mediaIds = const []}) {
    date = DateTime.now();
  }

  static fromJsonList(json) {
    List<ProgressModel> progressList = [];
    json?.forEach((e) => progressList.add(ProgressModel(
        progress: e['progress'],
        mediaIds: List.from(e['mediaIds']),
        percentProgress: e['percentProgress'],
        date: DateTime.parse(e['date']),
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

  static copyProgressList(List<ProgressModel> progressList) {
    List<ProgressModel> list = [];
    for (var progress in progressList) {
      list.add(copyProgress(progress));
    }
    return list;
  }

  static copyProgress(ProgressModel progress) {
    return ProgressModel(
        date: progress.date,
        progress: progress.progress,
        mediaIds: MediaModel.copyMediaIdList(progress.mediaIds),
        percentProgress: progress.percentProgress,
        frequencyAmount: progress.frequencyAmount);
  }

  static emptyProgress(int frequencyAmount) {
    return ProgressModel(
        progress: 0,
        mediaIds: [],
        date: DateTime.now(),
        percentProgress: 0,
        frequencyAmount: frequencyAmount);
  }
}
